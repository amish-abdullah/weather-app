import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'weather_page.dart';

class AgreementScreen extends StatelessWidget {
  const AgreementScreen({super.key});

  Future<void> accept(BuildContext context) async {

    SharedPreferences prefs =
        await SharedPreferences.getInstance();

    await prefs.setBool("agreement", true);

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => const WeatherPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: const Color(0xff35507d),

      body: Center(
        child: Container(
          margin: const EdgeInsets.all(20),
          padding: const EdgeInsets.all(20),

          decoration: BoxDecoration(
            color: Colors.black87,
            borderRadius: BorderRadius.circular(30),
          ),

          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [

              const Text(
                "Welcome to Weather",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 20),

              const Text(
                "This app needs location permission to show weather updates based on your location.",
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 18,
                ),
              ),

              const SizedBox(height: 30),

              Row(
                children: [

                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text("Cancel"),
                    ),
                  ),

                  const SizedBox(width: 15),

                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => accept(context),
                      child: const Text("Agree"),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}