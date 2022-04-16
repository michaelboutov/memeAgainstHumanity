import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RoundedButton extends StatelessWidget {
  final Function onPressed;
  final String label;

  const RoundedButton({
    required this.onPressed,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        onPressed();
      },
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      child: Ink(
        decoration: BoxDecoration(
          gradient: kPrimayGradient,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Container(
          width: 250,
          height: 50,
          alignment: Alignment.center,
          child: Text(
            label,
            style: GoogleFonts.chango(
              color: Colors.white,
              fontSize: 22.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}

final kPrimayGradient = RadialGradient(
  radius: 6.0,
  colors: [
    const Color(0xffEEB86D),
    const Color(0xffC47F90),
  ],
);
