import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social/core/presentation/components/blue_button.dart';
import 'package:social/core/presentation/components/my_textfield.dart';
import 'package:social/features/auth/presentation/cubits/auth_cubit.dart';

class SignupPage extends StatefulWidget {
  final void Function()? switchPage;

  const SignupPage({super.key, required this.switchPage});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmController = TextEditingController();

  // signup button pressed
  void signup() {
    final name = nameController.text;
    final email = emailController.text;
    final password = passwordController.text;
    final confirm = confirmController.text;

    if (name.isNotEmpty &&
        email.isNotEmpty &&
        password.isNotEmpty &&
        confirm.isNotEmpty) {
      if (password == confirm) {
        context.read<AuthCubit>().signup(name, email, password);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Password does not match')),
        );
      }
    }

    // one of the field or all the field is empty
    else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Please fill out all the required information')),
      );
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmController.dispose();
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

            // name input
            MyTextfield(
              controller: nameController,
              hintText: 'Name',
              obscureText: false,
            ),

            const SizedBox(height: 15),

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

            // confirm password
            MyTextfield(
              controller: confirmController,
              hintText: 'Confirm assword',
              obscureText: true,
            ),

            const SizedBox(height: 15),

            // login button
            BlueButton(
              text: 'Sign up',
              onTap: signup,
              width: double.infinity,
              height: 50,
            ),

            const SizedBox(height: 15),

            // re direct to sign up page
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Already have an account? ',
                  style: TextStyle(
                    color: Colors.grey.shade400,
                  ),
                ),
                GestureDetector(
                  onTap: widget.switchPage,
                  child: Text(
                    'Log in.',
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
