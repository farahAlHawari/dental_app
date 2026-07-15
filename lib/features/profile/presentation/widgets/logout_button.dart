import 'package:flutter/material.dart';

class LogoutButton extends StatelessWidget {
  final VoidCallback? onPressed;

  const LogoutButton({
    super.key,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      child: const Text(
        "تسجيل الخروج",
        style: TextStyle(
          color: Colors.red,
          fontWeight: FontWeight.bold,
          fontSize: 17,
        ),
      ),
    );
  }
}