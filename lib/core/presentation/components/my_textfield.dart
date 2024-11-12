import 'package:flutter/material.dart';

class MyTextfield extends StatelessWidget {
  final TextEditingController controller;
  final bool obscureText;
  final String? hintText;

  const MyTextfield({
    super.key,
    required this.controller,
    required this.obscureText,
    this.hintText,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(6),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey.shade400),
          borderRadius: BorderRadius.circular(6),
        ),
        hintText: hintText,
        hintStyle: TextStyle(color: Colors.grey.shade300),
        filled: true,
        fillColor: Colors.grey.shade50,
      ),
    );
  }
}
