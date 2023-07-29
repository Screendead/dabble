import 'package:flutter/material.dart';

class Dabble extends StatelessWidget {
  const Dabble({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Dabble',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.red),
        useMaterial3: true,
      ),
      home: const Placeholder(),
    );
  }
}
