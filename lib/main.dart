import 'package:flutter/material.dart';
import 'screens/moyenne_page.dart';

void main() {
  runApp(const MoyenneApp());
}

class MoyenneApp extends StatelessWidget {
  const MoyenneApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calculateur de Moyenne',
      theme: ThemeData(
        primarySwatch: Colors.teal,
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: const MoyennePage(),
    );
  }
}
