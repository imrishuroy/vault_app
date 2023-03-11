import 'package:flutter/material.dart';
import 'package:vault_app/screens/backup/backup_screen.dart';
import 'package:vault_app/screens/forget-password/forget_password_screen.dart';
import 'package:vault_app/screens/login/remote_login_screen.dart';
import 'package:vault_app/screens/signup/remote_signup_screen.dart';

import '/screens/audios/audios_screen.dart';
import '/screens/bowser/screens/private_browser_screen.dart';
import '/screens/contacts/contacts_screen.dart';
import '/screens/credentials/credentials_screen.dart';
import '/screens/credentials/credit_card_screen.dart';
import '/screens/credentials/screens/add_bank_screen.dart';
import '/screens/credentials/screens/add_password_screen.dart';
import '/screens/documents/documents_screen.dart';
import '/screens/home/home_screen.dart';
import '/screens/images/images_screen.dart';
import '/screens/notes/add_notes_screen.dart';
import '/screens/notes/notes_screen.dart';
import '/screens/videos/videos_screen.dart';
import '../screens/login/local_login_screen.dart';
import 'auth_wrapper.dart';

class CustomRouter {
  static Route onGenerateRoute(RouteSettings settings) {
    print('Route: ${settings.name}');
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(
            settings: const RouteSettings(name: '/'),
            builder: (_) => const Scaffold());

      case AuthWrapper.routeName:
        return AuthWrapper.route();

      case LocalLoginScreen.routeName:
        return LocalLoginScreen.route();

      case RemoteLoginScreen.routeName:
        return RemoteLoginScreen.route();

      case RemoteSignupScreen.routeName:
        return RemoteSignupScreen.route();

      case HomeScreen.routeName:
        return HomeScreen.route();

      case ImagesScreen.routeName:
        return ImagesScreen.route();

      case VideosScreen.routeName:
        return VideosScreen.route();

      case AudiosScreen.routeName:
        return AudiosScreen.route();

      case DocumentsScreen.routeName:
        return DocumentsScreen.route();

      case NotesScreen.routeName:
        return NotesScreen.route();

      case CredentialsScreen.routeName:
        return CredentialsScreen.route();

      case PrivateBrowserScreen.routeName:
        return PrivateBrowserScreen.route();

      case ContactsScreen.routeName:
        return ContactsScreen.route();

      case AddNotesScreen.routeName:
        return AddNotesScreen.route(args: settings.arguments as AddNotesArgs);

      case CreditCardScreen.routeName:
        return CreditCardScreen.route(
            args: settings.arguments as CreditCardArgs);

      case AddBankScreen.routeName:
        return AddBankScreen.route(args: settings.arguments as AddBankArgs);

      case AddPasswordScreen.routeName:
        return AddPasswordScreen.route(
            args: settings.arguments as AddPasswordArgs);

      case ForgotPasswordScreen.routeName:
        return ForgotPasswordScreen.route();

      case BackupScreen.routeName:
        return BackupScreen.route();

      default:
        return _errorRoute();
    }
  }

  static Route onGenerateNestedRouter(RouteSettings settings) {
    print('NestedRoute: ${settings.name}');
    switch (settings.name) {
      default:
        return _errorRoute();
    }
  }

  static Route _errorRoute() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: '/error'),
      builder: (_) => Scaffold(
        appBar: AppBar(
          title: const Text(
            'Error',
          ),
        ),
        body: const Center(
          child: Text(
            'Something went wrong',
            style: TextStyle(
              color: Colors.black,
            ),
          ),
        ),
      ),
    );
  }
}
