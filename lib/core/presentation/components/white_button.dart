import 'package:flutter/material.dart';

class WhiteButton extends StatelessWidget {
  final String text;
  final void Function()? onTap;
  final double? height;
  final double? width;

  const WhiteButton({
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
          // color: Colors.blue,
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Center(
          child: Text(
            text,
            // style: const TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
