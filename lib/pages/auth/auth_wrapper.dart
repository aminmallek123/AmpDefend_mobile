import 'package:flutter/material.dart';
import '../home/home_page.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Toujours afficher la page d'accueil
    // Elle gère l'affichage conditionnel des boutons selon l'état d'authentification
    return const HomePage();
  }
}