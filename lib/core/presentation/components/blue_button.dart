import 'package:flutter/material.dart';

class BlueButton extends StatelessWidget {
  final String text;
  final void Function()? onTap;
  final double? width;
  final double? height;

  const BlueButton({
    super.key,
    required this.text,
    required this.onTap,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.blue,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Center(
          child: Text(
            text,
            style: const TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
