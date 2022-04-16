import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class IntroSection extends StatelessWidget {
  final String? title;
  final double? fontSize;
  const IntroSection({Key? key, this.title, this.fontSize}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        title ?? "Meme Against Humanity",
        textAlign: TextAlign.center,
        style: GoogleFonts.chango(
          color: Colors.orangeAccent,
          fontSize: 35.0,
        ),
      ),
    );
  }
}
