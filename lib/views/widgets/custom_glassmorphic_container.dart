import 'package:flutter/cupertino.dart';
import 'package:glassmorphism/glassmorphism.dart';

// ignore: must_be_immutable
class CustomGlassmorphicContainer extends StatelessWidget {
  Widget child;
  final double height;
  final double width;
  CustomGlassmorphicContainer(
      {Key? key,
      required Widget this.child,
      required this.height,
      required this.width})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GlassmorphicContainer(
        borderRadius: 20,
        blur: 30,
        padding: EdgeInsets.all(4),
        alignment: Alignment.bottomCenter,
        border: 2,
        linearGradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFffffff).withOpacity(0.1),
              Color(0xFFFFFFFF).withOpacity(0.1),
            ],
            stops: [
              0.1,
              1,
            ]),
        borderGradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFffffff).withOpacity(0),
            Color((0xFFFFFFFF)).withOpacity(0),
          ],
        ),
        height: height,
        width: width,
        child: child);
  }
}

// ignore: must_be_immutable
class StartScreenGlassmorphicContainer extends StatelessWidget {
  Widget child;

  StartScreenGlassmorphicContainer({Key? key, required Widget this.child})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GlassmorphicContainer(
        borderRadius: 20,
        blur: 30,
        padding: EdgeInsets.all(4),
        alignment: Alignment.bottomCenter,
        border: 2,
        linearGradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFffffff).withOpacity(0.1),
              Color(0xFFFFFFFF).withOpacity(0.1),
            ],
            stops: [
              0.1,
              1,
            ]),
        borderGradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFffffff).withOpacity(0),
            Color((0xFFFFFFFF)).withOpacity(0),
          ],
        ),
        height: MediaQuery.of(context).size.height * 0.85,
        width: MediaQuery.of(context).size.width * 0.85,
        child: child);
  }
}
