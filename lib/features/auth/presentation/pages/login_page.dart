import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social/core/presentation/components/blue_button.dart';
import 'package:social/core/presentation/components/my_textfield.dart';
import 'package:social/features/auth/presentation/cubits/auth_cubit.dart';

class LoginPage extends StatefulWidget {
  final void Function()? switchPage;

  const LoginPage({super.key, required this.switchPage});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  // login button pressed
  void login() {
    final email = emailController.text;
    final password = passwordController.text;

    if (email.isNotEmpty && password.isNotEmpty) {
      context.read<AuthCubit>().login(email, password);
    }

    // one of the field / both the field is empty
    else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter email and password')),
      );
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // app logo
            Image.asset(
              'images/instagram_word_logo.png',
              width: 200,
            ),

            const SizedBox(height: 20),

            // email input
            MyTextfield(
              controller: emailController,
              hintText: 'Email',
              obscureText: false,
            ),

            const SizedBox(height: 15),

            // password input
            MyTextfield(
              controller: passwordController,
              hintText: 'Password',
              obscureText: true,
            ),

            const SizedBox(height: 15),

            // login button
            BlueButton(
              text: 'Log in',
              onTap: login,
              width: double.infinity,
              height: 50,
            ),

            const SizedBox(height: 15),

            // re direct to sign up page
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Don\'t have an account? ',
                  style: TextStyle(
                    color: Colors.grey.shade400,
                  ),
                ),
                GestureDetector(
                  onTap: widget.switchPage,
                  child: Text(
                    'Sign up.',
                    style: TextStyle(color: Colors.blue.shade300),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
