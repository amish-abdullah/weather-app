import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'firebase_options.dart';
import 'weather_pages/agreementcheck.dart';
import 'weather_pages/weather_page.dart';
import 'weather_service/notification_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Initialize notifications BEFORE starting the app
  await NotificationService().initialize();

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool accepted = false;
  bool loading = true;

  @override
  void initState() {
    super.initState();

    print("=== INIT STATE CALLED ===");

    checkAgreement();
  }

  Future<void> checkAgreement() async {
    SharedPreferences prefs =
        await SharedPreferences.getInstance();

    accepted = prefs.getBool("agreement") ?? false;

    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const MaterialApp(
        home: Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        ),
      );
    }

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: accepted
          ? const WeatherPage()
          : const AgreementScreen(),
    );
  }
}