import 'package:flutter/material.dart';
import 'package:petto_app/dependency_injection.dart';
import 'package:petto_app/pages/main/main_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await DependencyInjection.setup();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorSchemeSeed: Colors.deepPurple,
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: ButtonStyle(
            backgroundColor: const WidgetStatePropertyAll(
              Colors.white,
            ),
            foregroundColor: const WidgetStatePropertyAll(
              Colors.deepPurple,
            ),
            shape: WidgetStatePropertyAll(
              RoundedRectangleBorder(
                side: const BorderSide(color: Colors.deepPurpleAccent),
                borderRadius: BorderRadius.circular(12.0),
              ),
            ),
            side: const WidgetStatePropertyAll(
              BorderSide(
                color: Colors.deepPurpleAccent,
                width: 2.0,
              ),
            ),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
            backgroundColor: const WidgetStatePropertyAll(
              Colors.deepPurpleAccent,
            ),
            foregroundColor: const WidgetStatePropertyAll(
              Colors.white,
            ),
            shape: WidgetStatePropertyAll(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
            ),
          ),
        ),
      ),
      home: const MainPage(),
    );
  }
}
