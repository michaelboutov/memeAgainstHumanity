import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class OnBoardingBody extends StatelessWidget {
  const OnBoardingBody({
    Key? key,
    required this.image,
    required this.title,
    required this.subTitle,
  }) : super(key: key);

  final String image;
  final String title;
  final String subTitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Center(
            child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: ClipRRect(
              borderRadius: BorderRadius.circular(20.0),
              child: Image.asset(image)),
        )),
        SizedBox(height: 1.sh * 0.07),
        Text(
          title,
          textAlign: TextAlign.center,
          style: GoogleFonts.chango(
            color: Colors.white,
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          width: 1.sw * 0.8,
          child: Text(
            subTitle,
            textAlign: TextAlign.center,
            style: GoogleFonts.chango(
              color: Colors.white,
              fontSize: 16.0,
            ),
          ),
        ),
        const Spacer(flex: 2),
      ],
    );
  }
}
