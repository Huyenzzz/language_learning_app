import 'package:flutter/material.dart';
import 'package:language_learning_app/screens/register/login_page.dart';
import 'package:language_learning_app/screens/register/register_page.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  //intially, show the login
  bool showLoginPage = true;

  void tooggleScreens() {
    setState(() {
      showLoginPage = !showLoginPage;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showLoginPage) {
      return LoginPage(showRegisterPage: tooggleScreens);
    } else {
      return RegisterPage(showLoginPage: tooggleScreens);
    }
  }
}
