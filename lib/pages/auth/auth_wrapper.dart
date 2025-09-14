import 'package:flutter/material.dart';
import '../home/home_page.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Always display the home page
    // It handles conditional display of buttons based on authentication state
    return const HomePage();
  }
}