import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class GradientText extends StatelessWidget {
  const GradientText({
    Key? key,
    required this.text,
    required this.fontSize,
    required this.width,
  }) : super(key: key);

  final String text;
  final double fontSize;
  final double width;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: width,
        child: ShaderMask(
          shaderCallback: (Rect bounds) {
            return kPrimayGradient.createShader(Offset.zero & bounds.size);
          },
          child: Center(
            child: Text(
              text,
              style: GoogleFonts.chango(
                color: Colors.white,
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

final kPrimayGradient = LinearGradient(
  colors: [Colors.orange[400]!, Colors.orange[400]!],
);
