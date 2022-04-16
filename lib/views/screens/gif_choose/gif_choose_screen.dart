import 'dart:core';
import 'package:flutter/material.dart';
import 'package:checkmark/checkmark.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pure/blocs/chats/chats/group/group_chat_cubit.dart';
import 'package:pure/blocs/chats/chats/group/group_cubit.dart';
import 'package:pure/blocs/gif_bloc/gif_bloc.dart';
import 'package:pure/repositories/gif_repository.dart';
import 'package:pure/services/chat/chat_service.dart';
import 'package:pure/utils/navigate.dart';
import 'package:pure/views/screens/chats/messages/group_chat_message_screen.dart';
import 'package:pure/views/widgets/background.dart';
import 'package:pure/views/widgets/custom_glassmorphic_container.dart';

// ignore: must_be_immutable
class GifChooseScreen extends StatefulWidget {
  var chatModel;
  final questionNumber;

  GifChooseScreen(
      {Key? key, required this.chatModel, required this.questionNumber})
      : super(key: key);

  @override
  State<GifChooseScreen> createState() => _GifChooseScreenState();
}

class _GifChooseScreenState extends State<GifChooseScreen> {
  List<Widget> _showGifs(data, ChatModel, questionNumber) {
    List<Widget> gifsToShow = [];

    for (var item in data) {
      gifsToShow.add(GifCardPic(
        questionNumber: questionNumber,
        item: item,
        chatModel: ChatModel,
      ));
    }

    return gifsToShow;
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => GifBloc(
              RepositoryProvider.of<GifRepository>(context),
            )..add(LoadGifEvent()),
        child: Background(
          child: Material(
              color: Colors.transparent,
              child: BlocBuilder<GifBloc, GifState>(builder: (context, state) {
                if (state is GifLoadingState) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: Colors.orangeAccent,
                    ),
                  );
                }
                if (state is GifLoadedState) {
                  return Column(
                    children: [
                      SizedBox(
                        height: 40,
                      ),
                      Text(
                        "chat id : " + widget.chatModel.chatId,
                        style: GoogleFonts.roboto(
                          color: Colors.white,
                          fontSize: 20.0,
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      CustomGlassmorphicContainer(
                        height: 280,
                        width: MediaQuery.of(context).size.width * 0.92,
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              widget.chatModel.questions[widget.questionNumber],
                              style: GoogleFonts.chango(
                                color: Colors.white,
                                fontSize: 22.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 3,
                      ),
                      Expanded(
                        child: GridView.count(
                            shrinkWrap: true,
                            crossAxisCount: 2,
                            children: _showGifs(state.gifModel,
                                widget.chatModel, widget.questionNumber)),
                      ),
                    ],
                  );
                }
                if (state is GifErrorState) {
                  return Center(
                    child: Text(state.error.toString()),
                  );
                }
                return Container();
              })),
        ));
  }
}

// ignore: must_be_immutable
class GifCardPic extends StatefulWidget {
  var chatModel;
  final int questionNumber;

  GifCardPic({
    Key? key,
    required this.item,
    required this.chatModel,
    required this.questionNumber,
  }) : super(key: key);

  final item;

  @override
  State<GifCardPic> createState() => _GifCardPicState();
}

class _GifCardPicState extends State<GifCardPic> {
  bool checked = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(6.0),
      child: CustomGlassmorphicContainer(
          height: 100,
          width: MediaQuery.of(context).size.width * 0.40,
          child: Center(
              child: Stack(
            children: [
              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20.0),
                  child: Image.network(
                    widget.item.url,
                    fit: BoxFit.cover,
                    loadingBuilder: (BuildContext context, Widget child,
                        ImageChunkEvent? loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Center(
                        child: CircularProgressIndicator(
                          color: Colors.orangeAccent,
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
              Positioned(
                bottom: 8,
                right: 8,
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      checked = !checked;
                      String gifChooseUrl = widget.item.url;
                      push(
                          context: context,
                          rootNavigator: true,
                          page: MultiBlocProvider(
                            providers: [
                              BlocProvider(
                                  create: (_) => GroupCubit(ChatServiceImp())),
                              BlocProvider(
                                create: (_) => GroupChatCubit(ChatServiceImp()),
                              ),
                            ],
                            child: GroupChatMessageScreen(
                              questionNumber: widget.questionNumber,
                              chatModel: widget.chatModel,
                              gifChoosUri: gifChooseUrl,
                            ),
                          ));
                    });
                  },
                  child: SizedBox(
                    height: 40,
                    width: 40,
                    child: CheckMark(
                      inactiveColor: Color(0xffA670FF),
                      active: checked,
                      curve: Curves.decelerate,
                      duration: const Duration(milliseconds: 500),
                    ),
                  ),
                ),
              ),
            ],
          ))),
    );
  }
}
