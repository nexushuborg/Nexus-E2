import 'package:flutter/material.dart';
import 'screens/login.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    initialRoute: 'login',
    routes: {
      'login': (context) => const ArcanumLogin()
    },
  ));
}