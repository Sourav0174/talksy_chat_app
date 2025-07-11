import 'package:flutter/material.dart';

class CustomTextfield extends StatelessWidget {
  final String hintText;
  final bool obscureText;
  final Icon? icon;
  final TextEditingController controller;
  const CustomTextfield({
    super.key,
    required this.hintText,
    required this.obscureText,
    required this.controller,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      obscureText: obscureText,
      controller: controller,
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Theme.of(context).colorScheme.tertiary),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Theme.of(context).colorScheme.primary),
        ),
        suffixIcon: GestureDetector(child: icon ?? icon),
        suffixIconColor: Theme.of(context).colorScheme.primary,
        fillColor: Theme.of(context).colorScheme.secondary,
        filled: true,

        hintText: hintText,
        hintStyle: TextStyle(color: Theme.of(context).colorScheme.primary),
      ),
    );
  }
}
