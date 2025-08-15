import 'package:flutter/material.dart';
import 'screens/login.dart';
import 'screens/loading.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    initialRoute: 'loading',
    routes: {
      'loading': (context) => const LoadingScreen(),
      'login': (context) => const ArcanumLogin()

    },
  ));
}