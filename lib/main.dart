import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mytat/services/db_helper.dart';
import 'package:mytat/splash_screen.dart';
import 'package:mytat/utilities/di.dart';
import 'package:wakelock/wakelock.dart';

void main() async {
  // Ensure Flutter is initialized before anything else
  WidgetsFlutterBinding.ensureInitialized();

  // Trendsetters Changes
  Wakelock.enable();

// Adde line of Code for SQFLite
  var dbHelper = DatabaseHelper();

  // Initialize the database
  await dbHelper.initDb();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
        transitionDuration: const Duration(milliseconds: 200),
        defaultTransition: Transition.cupertino,
        debugShowCheckedModeBanner: false,
        home: const SplashScreen(),
        initialBinding: RootBinding());
  }
}
