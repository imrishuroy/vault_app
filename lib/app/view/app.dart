import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import '/blocs/auth/auth_bloc.dart';
import '/config/config.dart';
import '/l10n/l10n.dart';
import '/repositories/audios/audios_repository.dart';
import '/repositories/auth/auth_repository.dart';
import '/repositories/backup/backup_repository.dart';
import '/repositories/credentials/credentials_repository.dart';
import '/repositories/documents/documents_repository.dart';
import '/repositories/file/file_repository.dart';
import '/repositories/images/images_repository.dart';
import '/repositories/notes/notes_repository.dart';
import '/repositories/videos/videos_repository.dart';
import '/screens/login/local_login_screen.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<AuthRepository>(
          create: (_) => AuthRepository(),
        ),
        RepositoryProvider<FileRepository>(
          create: (_) => FileRepository(),
        ),
        RepositoryProvider<NotesRepository>(
          create: (_) => NotesRepository(),
        ),
        RepositoryProvider<CredentialsRepository>(
          create: (_) => CredentialsRepository(),
        ),
        RepositoryProvider<AudiosRepository>(
          create: (_) => AudiosRepository(),
        ),
        RepositoryProvider<DocumentsRepository>(
          create: (_) => DocumentsRepository(),
        ),
        RepositoryProvider<ImagesRepository>(
          create: (_) => ImagesRepository(),
        ),
        RepositoryProvider<VideosRepository>(
          create: (_) => VideosRepository(),
        ),
        RepositoryProvider<BackUpRepository>(
          create: (_) => BackUpRepository(),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<AuthBloc>(
            create: (context) => AuthBloc(
              authRepository: context.read<AuthRepository>(),
            ),
          ),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            appBarTheme: const AppBarTheme(
              color: Color(0xFF13B9FF),
              elevation: 0.0,
              centerTitle: true,
            ),
            iconTheme: const IconThemeData(
              color: Colors.white,
            ),
            fontFamily: 'Poppins',
            colorScheme: ColorScheme.fromSwatch(
              accentColor: const Color(0xFF13B9FF),
            ),
          ),
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          onGenerateRoute: CustomRouter.onGenerateRoute,
          //initialRoute: AuthWrapper.routeName,
          initialRoute: LocalLoginScreen.routeName,
        ),
      ),
    );
  }
}
