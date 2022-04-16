import 'package:flutter/material.dart';

// ignore: must_be_immutable
class Background extends StatelessWidget {
  late Widget child;

  Background({Key? key, required Widget this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
            fit: BoxFit.cover,
            image: AssetImage('assets/images/background.png')),
      ),
      child: child,
    );
  }
}
