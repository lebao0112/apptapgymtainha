import 'package:doan_tapgymtainha/provider/challenge_provider.dart';
import 'package:doan_tapgymtainha/provider/chalprogress_provider.dart';
import 'package:doan_tapgymtainha/provider/complete_workout_status_provider.dart';
import 'package:doan_tapgymtainha/provider/workout_provider.dart';
import 'package:doan_tapgymtainha/provider/workout_timer_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:doan_tapgymtainha/screen/splash_screen.dart';
import 'package:doan_tapgymtainha/provider/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  await Hive.openBox('userProfileBox');

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ChallengeProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => ChalprogressProvider()),
        ChangeNotifierProvider(create: (_) => CompleteWorkoutStatusProvider()),
        ChangeNotifierProvider(create: (_) => WorkoutProvider()),
        ChangeNotifierProvider(create: (_) => WorkoutTimerProvider()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        brightness: Brightness.light,
        scaffoldBackgroundColor: Colors.white,
        primaryColor: Colors.deepPurple,
        textTheme: TextTheme(
          bodyLarge: TextStyle(color: Colors.black), // Black text for light mode
          bodyMedium: TextStyle(color: Colors.black),
        ),
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: Colors.black,
        primaryColor: Colors.deepPurple,
        textTheme: TextTheme(
          bodyLarge: TextStyle(color: Colors.white), // White text for dark mode
          bodyMedium: TextStyle(color: Colors.white),
        ),
      ),
      themeMode: themeProvider.isDarkMode ? ThemeMode.dark : ThemeMode.light,
      home: SplashScreen(),
    );
  }
}
