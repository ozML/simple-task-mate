import 'package:flutter/material.dart';

class TestApp extends StatelessWidget {
  const TestApp({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) => MaterialApp(
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: child,
      );
}

/// Week 42, 2024, Mo - So
final testWeek = [
  DateTime(2024, 10, 14),
  DateTime(2024, 10, 15),
  DateTime(2024, 10, 16),
  DateTime(2024, 10, 17),
  DateTime(2024, 10, 18),
  DateTime(2024, 10, 19),
  DateTime(2024, 10, 20),
];
