import 'package:flutter/material.dart';
import 'package:social/features/auth/presentation/pages/login_page.dart';
import 'package:social/features/auth/presentation/pages/signup_page.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  bool loginPage = true;

  void switchPage() {
    setState(() {
      loginPage = !loginPage;
    });
  }

  @override
  Widget build(BuildContext context) {
    return loginPage
        ? LoginPage(switchPage: switchPage)
        : SignupPage(switchPage: switchPage);
  }
}
