import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../blocs/bloc.dart';
import '../../../../model/chat/chat_model.dart';
import '../../../../model/pure_user_model.dart';
import '../../../../services/chat/message_service.dart';
import 'widgets/message_screen_widget.dart';

// ignore: must_be_immutable
class GroupChatMessageScreen extends StatefulWidget {
  final ChatModel chatModel;
  final int questionNumber;

  var gifChoosUri;
  GroupChatMessageScreen(
      {Key? key,
      required this.chatModel,
      this.gifChoosUri,
      required this.questionNumber})
      : super(key: key);

  @override
  State<GroupChatMessageScreen> createState() => _GroupChatMessageScreenState();
}

class _GroupChatMessageScreenState extends State<GroupChatMessageScreen> {
  @override
  void initState() {
    super.initState();
    // subscribe to notifification from this chat messages
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: MultiBlocProvider(
        providers: [
          BlocProvider(
            lazy: false,
            create: (_) => MessageCubit(MessageServiceImp())
              ..fetchMessages(
                  widget.chatModel.chatId, CurrentUser.currentUserId),
          ),
          BlocProvider(create: (_) => NewMessagesCubit(MessageServiceImp())),
          BlocProvider(
              create: (_) => LoadMoreMessageCubit(MessageServiceImp())),
        ],
        child: MessageBody(
          ChatModel: widget.chatModel,
          chatId: widget.chatModel.chatId,
          gifChoosUri: widget.gifChoosUri,
          numberPlayers: widget.chatModel.groupDescription!,
          questionNumber: widget.questionNumber,
        ),
      ),
    );
  }
}
