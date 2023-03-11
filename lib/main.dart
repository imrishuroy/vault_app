import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';

import '/bootstrap.dart';
import 'app/view/app.dart';
import 'config/hive_config.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  final appDir = await getApplicationDocumentsDirectory();

  await Hive.initFlutter(appDir.path);
  HiveConfig().registerAdapters();
  await HiveConfig().init();

  // await FlutterDownloader.initialize(
  //     debug: true // optional: set false to disable printing logs to console
  //     );

  // await HiveConfig().setExpenseCategories();
  // await HiveConfig().setIncomeCategories();

  bootstrap(() => const App());
}
