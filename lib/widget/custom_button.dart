import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final ButtonStyle buttonStyle;
  final VoidCallback onPressed;

  const CustomButton({super.key, required this.text, required this.onPressed, required this.buttonStyle});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: buttonStyle,
      child: Text(
        text,
        style: const TextStyle(fontSize: 16),
      ),
    );
  }
}
