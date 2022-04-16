import 'package:flutter/material.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pure/services/chat/chat_service.dart';
import '../../../../../model/chat/message_model.dart';

class UserMessage extends StatefulWidget {
  final String question;
  final String chatId;
  final MessageModel message;
  final String senderName;
  final int questionNumber;

  UserMessage({
    Key? key,
    required this.message,
    required this.chatId,
    required this.questionNumber,
    required this.question,
    required this.senderName,
  }) : super(key: key);

  @override
  State<UserMessage> createState() => _UserMessageState();
}

class _UserMessageState extends State<UserMessage> {
  var chatServise = ChatServiceImp();

  bool like = false;

  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: GlassmorphicContainer(
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
        height: MediaQuery.of(context).size.height * 0.40,
        width: MediaQuery.of(context).size.width * 0.9,
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
                child: Text(
                  widget.senderName + ' :',
                  style: GoogleFonts.chango(
                    color: Colors.orangeAccent,
                    fontSize: 22.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: Text(
                widget.question,
                style: GoogleFonts.chango(
                  color: Colors.white,
                  fontSize: 14.0,
                ),
              ),
            ),
            Stack(
              children: [
                _MessageBody(
                  message: widget.message,
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: IconButton(
                      color: like ? Colors.orange : Colors.grey,
                      iconSize: 36.0,
                      splashColor: Colors.purple,
                      splashRadius: 40.0,
                      onPressed: () {
                        setState(() {
                          // Here we changing the icon.
                          like = !like;
                        });
                        chatServise.addLike(
                            chatID: widget.chatId,
                            userID: widget.message.senderName,
                            questionNumber: widget.questionNumber);
                      },
                      icon: Icon(Icons.favorite)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _MessageBody extends StatelessWidget {
  final MessageModel message;
  const _MessageBody({
    Key? key,
    required this.message,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.28,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20.0),
          child: Image.network(
            message.text,
            fit: BoxFit.contain,
            loadingBuilder: (BuildContext context, Widget child,
                ImageChunkEvent? loadingProgress) {
              if (loadingProgress == null) return child;
              return Center(
                child: CircularProgressIndicator(
                  value: loadingProgress.expectedTotalBytes != null
                      ? loadingProgress.cumulativeBytesLoaded /
                          loadingProgress.expectedTotalBytes!
                      : null,
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
