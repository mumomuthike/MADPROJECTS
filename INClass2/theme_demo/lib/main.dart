import 'package:flutter/material.dart';

void main() {
  runApp(const RunMyApp());
}

class RunMyApp extends StatefulWidget {
  const RunMyApp({super.key});

  @override
  State<RunMyApp> createState() => _RunMyAppState();
}

class _RunMyAppState extends State<RunMyApp> {
  // Variable to manage the current theme mode
  ThemeMode _themeMode = ThemeMode.system;

  // Method to toggle the theme
  void changeTheme(ThemeMode themeMode) {
    setState(() {
      _themeMode = themeMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Theme Demo',

      // Light Theme
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
        scaffoldBackgroundColor: Colors.grey[200],
      ),

      // Dark Theme
      darkTheme: ThemeData.dark(),

      themeMode: _themeMode,

      home: Scaffold(
        appBar: AppBar(title: const Text('Theme Demo')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Part 1
              AnimatedContainer(
                duration: const Duration(milliseconds: 500),
                width: 300,
                height: 200,
                margin: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.white
                      : Colors.grey,
                  borderRadius: BorderRadius.circular(20),
                ),
                alignment: Alignment.center,
                child: const Text(
                  'Mobile App Development Testing',
                  style: TextStyle(fontSize: 18, color: Colors.black),
                  textAlign: TextAlign.center,
                ),
              ),

              const SizedBox(height: 20),

              const Text('Choose the Theme:', style: TextStyle(fontSize: 16)),

              const SizedBox(height: 10),

              // Part 2
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.wb_sunny,
                    color: _themeMode == ThemeMode.light
                        ? Colors.amber
                        : Colors.grey,
                  ),
                  Switch(
                    value: _themeMode == ThemeMode.dark,
                    onChanged: (isDark) {
                      changeTheme(isDark ? ThemeMode.dark : ThemeMode.light);
                    },
                  ),
                  Icon(
                    Icons.nightlight_round,
                    color: _themeMode == ThemeMode.dark
                        ? Colors.amber
                        : Colors.grey,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
