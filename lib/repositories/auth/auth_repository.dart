// ignore_for_file: depend_on_referenced_packages

import 'dart:convert';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:local_auth/error_codes.dart'
    as auth_error; // to ge the error code of locala auth
import 'package:local_auth/local_auth.dart';
import 'package:local_auth_android/local_auth_android.dart';
import 'package:local_auth_ios/local_auth_ios.dart';

import '/config/hive_config.dart';
import '/constants/paths.dart';
import '/models/app_user.dart';
import '/models/failure.dart';
import 'base_auth_repo.dart';

class AuthRepository extends BaseAuthRepository {
  final LocalAuthentication _localAuth = LocalAuthentication();

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final CollectionReference usersRef =
      FirebaseFirestore.instance.collection(Paths.users);

  bool checkCode(String pin) {
    try {
      final storedPin = HiveConfig().getAppPIN();
      return storedPin == pin;
    } on HiveError catch (error) {
      print('Error in getting pin ${error.message}');
      throw Failure(message: error.message);
    } catch (error) {
      print('Error in getting pin ${error.toString}');
      throw Failure(message: error.toString());
    }
  }

  Future<void> setAppCode(String pin) async {
    try {
      print('Pin is 1 $pin');
      await HiveConfig().addAppPIN(pin);
    } on HiveError catch (error) {
      print('Error in adding pin ${error.message}');
      throw Failure(message: error.message);
    } catch (error) {
      print('Error in adding pin ${error.toString}');
      throw Failure(message: error.toString());
    }
  }

  bool pinAvailable() {
    return HiveConfig().appCodeAvailable();
  }

  @override
  Future<bool> checkLocalAuthAvailable() async {
    try {
      final bool canAuthenticateWithBiometrics =
          await _localAuth.canCheckBiometrics;
      print('Can authenticate with biometrics $canAuthenticateWithBiometrics');
      final bool canAuthenticate =
          canAuthenticateWithBiometrics || await _localAuth.isDeviceSupported();

      print('canAuthenticate $canAuthenticate');

      return canAuthenticate;
    } on PlatformException catch (error) {
      print('PlatformException Error checking local auth $error');
      throw Failure(message: error.message);
    } catch (error) {
      print('Error checking local auth $error');
      throw const Failure(message: 'Error checking local auth');
    }
  }

  @override
  Future<bool> authenticateWithLocalAuth() async {
    try {
      final List<BiometricType> availableBiometrics =
          await _localAuth.getAvailableBiometrics();

      print('List Of Available biometrics $availableBiometrics');

      if (availableBiometrics.isNotEmpty) {
        // Some biometrics are enrolled.
        if (availableBiometrics.contains(BiometricType.strong) ||
            availableBiometrics.contains(BiometricType.face)) {
          print('We have biometrics available');

          final bool didAuthenticate = await _localAuth.authenticate(
              localizedReason: 'Please authenticate to access your contents',
              options: const AuthenticationOptions(
                useErrorDialogs: false,
                stickyAuth: true,
                sensitiveTransaction: true,
              ),
              authMessages: const [
                AndroidAuthMessages(
                  signInTitle: 'Oops! Biometric authentication required!',
                  cancelButton: 'No thanks',
                ),
                IOSAuthMessages(
                  cancelButton: 'No thanks',
                ),
              ]);

          print('Local auth authenticated $didAuthenticate');
          return didAuthenticate;

          // Specific types of biometrics are available.
          // Use checks like this with caution!
        }
      }

      return false;
    } on PlatformException catch (error) {
      print('Error code ${auth_error.biometricOnlyNotSupported}');
      print('PlatformException in authenticating with local auth $error');
      throw Failure(message: error.message);
    } catch (error) {
      print('Error authenticating with local auth ${error.toString()}');
      throw const Failure(message: 'Error checking local auth');
    }
  }
  // firebase auth

  AppUser? _appUser(User? user) {
    if (user == null) return null;
    return AppUser(
      uid: user.uid,
      name: user.displayName,
    );
  }

  @override
  Stream<AppUser?> get onAuthChanges =>
      _firebaseAuth.userChanges().map((user) => _appUser(user));

  @override
  Future<AppUser?> get currentUser async => _appUser(_firebaseAuth.currentUser);

  String? get userImage => _firebaseAuth.currentUser?.photoURL;

  String? get userId => _firebaseAuth.currentUser?.uid;

  String generateNonce([int length = 32]) {
    const charset =
        '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
    final random = Random.secure();
    return List.generate(length, (_) => charset[random.nextInt(charset.length)])
        .join();
  }

  /// Returns the sha256 hash of [input] in hex notation.
  String sha256ofString(String input) {
    final bytes = utf8.encode(input);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  @override
  Future<AppUser?> loginInWithEmailAndPassword({
    required String? email,
    required String? password,
  }) async {
    try {
      if (email != null && password != null) {
        final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
            email: email, password: password);
        return _appUser(userCredential.user);
      }
      return null;
    } on FirebaseAuthException catch (error) {
      print(error.toString());
      throw Failure(code: error.code, message: error.message!);
    } on PlatformException catch (error) {
      print(error.toString());
      throw Failure(code: error.code, message: error.message!);
    } catch (error) {
      throw const Failure(message: 'Something went wrong.Try again');
    }
  }

  @override
  Future<AppUser?> signUpWithEmailAndPassword({
    required String? email,
    required String? password,
  }) async {
    try {
      if (email != null && password != null) {
        final userCredentail = await _firebaseAuth
            .createUserWithEmailAndPassword(email: email, password: password);
        return _appUser(userCredentail.user);
      }
      return null;
    } on FirebaseAuthException catch (error) {
      print(error.toString());
      throw Failure(code: error.code, message: error.message!);
    } on PlatformException catch (error) {
      print(error.toString());
      throw Failure(code: error.code, message: error.message!);
    } catch (error) {
      throw const Failure(message: 'Something went wrong.Try again');
    }
  }

  @override
  Future<void>? forgotPassword(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (error) {
      print(error.toString());
      throw Failure(code: error.code, message: error.message!);
    } on PlatformException catch (error) {
      print(error.toString());
      throw Failure(code: error.code, message: error.message!);
    } catch (error) {
      throw const Failure(message: 'Something went wrong.Try again');
    }
  }

  @override
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }
}
