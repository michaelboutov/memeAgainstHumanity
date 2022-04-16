import 'dart:collection';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pure/views/widgets/background.dart';
import '../../../services/chat/chat_service.dart';

class ScoreScreen extends StatefulWidget {
  final String chatID;
  ScoreScreen({Key? key, required this.chatID}) : super(key: key);

  @override
  State<ScoreScreen> createState() => _ScoreScreenState();
}

class _ScoreScreenState extends State<ScoreScreen> {
  int rondumInt = Random().nextInt(6);
  Widget build(BuildContext context) {
    return Background(
        child: Scaffold(
      backgroundColor: Colors.transparent,
      body: Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.08,
          ),
          FutureBuilder<LinkedHashMap>(
              future: _getScore(chatID: widget.chatID),
              builder: (context, AsyncSnapshot<LinkedHashMap> scoreData) {
                if (scoreData.hasData == false)
                  return Center(
                    child: CircularProgressIndicator(
                      color: Colors.orangeAccent,
                    ),
                  );
                else
                  return Center(
                    child: GlassmorphicContainer(
                      borderRadius: 20,
                      blur: 25,
                      padding: EdgeInsets.all(4),
                      alignment: Alignment.bottomCenter,
                      border: 2,
                      linearGradient: constLinearGradient(),
                      borderGradient: constLinearGradient(),
                      height: MediaQuery.of(context).size.height * 0.8,
                      width: MediaQuery.of(context).size.width * 0.8,
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20.0),
                              child: Image.asset(
                                'assets/images/congratulations_gif/$rondumInt.gif',
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 50,
                          ),
                          Text(
                            'winner is',
                            style: GoogleFonts.chango(
                              color: Colors.white,
                              fontSize: 30.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          Text(
                            scoreData.data!
                                .kayAt(scoreData.data!.length - 1)
                                .toString(),
                            style: GoogleFonts.chango(
                              color: Colors.orangeAccent,
                              fontSize: 30.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
              }),
          TextButton(
              onPressed: () {
                Navigator.popUntil(
                    context, (Route<dynamic> predicate) => predicate.isFirst);
              },
              child: Text(
                'new game ',
                style: GoogleFonts.chango(
                  color: Colors.orangeAccent,
                  fontSize: 20.0,
                ),
              )),
        ],
      ),
    ));
  }
}

Future<LinkedHashMap> _getScore({required String chatID}) async {
  var chatServise = ChatServiceImp();
  LinkedHashMap winersMap = await chatServise.getWinner(chatID: chatID);
  return winersMap;
}

LinearGradient constLinearGradient() {
  return LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        Color(0xFFffffff).withOpacity(0.15),
        Color(0xFFFFFFFF).withOpacity(0.15),
      ],
      stops: [
        0.1,
        1,
      ]);
}
