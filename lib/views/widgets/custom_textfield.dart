import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final Future<void> onSubmit;
  final String hintText;
  final TextInputType keyboardType;
  final Icon prefixIcon;

  const CustomTextField({
    required this.controller,
    required this.hintText,
    required this.keyboardType,
    required this.onSubmit,
    required this.prefixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 270,
      height: 50,
      child: TextField(
        controller: controller,
        cursorColor: Colors.white,
        style: const TextStyle(color: Colors.white),
        textAlignVertical: TextAlignVertical.center,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: const TextStyle(color: Colors.white),
          hintTextDirection: TextDirection.ltr,
          prefixIcon: prefixIcon,
          fillColor: Colors.orangeAccent.withAlpha(70),
          filled: true,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide.none,
          ),
        ),
        textAlign: TextAlign.center,
        onSubmitted: (_) => onSubmit,
        keyboardType: keyboardType,
      ),
    );
  }
}
