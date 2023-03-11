import '/models/app_user.dart';

abstract class BaseAuthRepository {
  Future<bool> checkLocalAuthAvailable();
  Future<bool> authenticateWithLocalAuth();
  // firebase auth
  Future<AppUser?> get currentUser;
  Stream<AppUser?> get onAuthChanges;
  Future<void>? forgotPassword(String email);
  Future<AppUser?> signUpWithEmailAndPassword({
    required String? email,
    required String? password,
  });
  Future<AppUser?> loginInWithEmailAndPassword({
    required String? email,
    required String? password,
  });
  Future<void> signOut();
}
