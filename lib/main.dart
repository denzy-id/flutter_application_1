import 'package:flutter/material.dart';
import 'pages/login_page.dart';

void main() {
  runApp(const MyVaultApp());
}

class MyVaultApp extends StatelessWidget {
  const MyVaultApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'myVault Private',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF8FAFC),
      ),
      home: const LoginPage(),
    );
  }
}