import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pure/repositories/gif_repository.dart';
import 'package:pure/services/chat/chat_service.dart';
import 'package:pure/utils/navigate.dart';
import 'package:pure/views/screens/gif_choose/gif_choose_screen.dart';
import 'package:pure/views/screens/score/score_screen.dart';
import '../../../../../blocs/bloc.dart';
import '../../../../../model/chat/message_model.dart';
import '../../../../../model/pure_user_model.dart';
import '../../../../../utils/chat_utils.dart';
import 'empty_widget.dart';
import 'message_widgets.dart';
import 'user_message_widget.dart';
import 'package:auto_animated/auto_animated.dart';

class Messagesbody extends StatefulWidget {
  final int questionNumber;
  final ChatModel;

  final String? firstName;
  final int numberPlayers;
  final ValueChanged<MessageModel> onSentButtonPressed;
  final FocusNode inputFocusNode;
  const Messagesbody({
    Key? key,
    required this.numberPlayers,
    this.firstName,
    required this.onSentButtonPressed,
    required this.inputFocusNode,
    required this.ChatModel,
    required this.questionNumber,
  }) : super(key: key);

  @override
  _MessagesbodyState createState() => _MessagesbodyState();
}

class _MessagesbodyState extends State<Messagesbody> {
  final _controller = ScrollController();
  double lastPos = 0.0;
  late String currentUserId;
  var chatServise = ChatServiceImp();

  int showNewMessageAtIndex = -1;

  @override
  void initState() {
    super.initState();
    currentUserId = CurrentUser.currentUserId;
    _controller.addListener(_updateMessageOnScroll);
    _controller.addListener(_fetchOldMessagesOnScroll);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void oldMessagesListener(BuildContext context, final MessageState state) {
    if (state is MessagesLoaded) {
      context.read<MessageCubit>().updateOldMessages(state);
    }
  }

  void newMessagesListener(BuildContext context, final MessageState state) {
    if (state is MessagesLoaded) {
      if (widget.inputFocusNode.hasFocus) {
        // Occur if user keyboard is open, new messages should be updated automatically
        _updateLatestMessage(state);
      } else {
        final isView = true;

        if (isView) {
          _updateLatestMessage(state);
        } else if (state.messagesModel.messages.length > 0) {
          showNewMessageAtIndex = (state.messagesModel.messages.length - 1);
          lastPos = showNewMessageAtIndex * 35;
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Stack(
        children: [
          MultiBlocListener(
            listeners: [
              BlocListener<NewMessagesCubit, MessageState>(
                listener: newMessagesListener,
              ),
              BlocListener<LoadMoreMessageCubit, MessageState>(
                listener: oldMessagesListener,
              )
            ],
            child: BlocBuilder<MessageCubit, MessageState>(
              buildWhen: (prev, current) =>
                  (prev is MessageInitial && current is MessagesLoaded) ||
                  (prev is MessagesLoaded &&
                      current is MessagesLoaded &&
                      prev.messagesModel != current.messagesModel),
              builder: (context, state) {
                if (state is MessagesLoaded) {
                  var messages = state.messagesModel.messages;
                  if (messages.isEmpty && widget.firstName != null)
                    return EmptyMessage(
                      firstName: widget.firstName!,
                      onPressed: (String text) => sendMessage(text),
                    );
                  if (messages.length != 0 &&
                      (messages.length / widget.numberPlayers).isInt) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Expanded(
                            child: LiveList(
                          showItemInterval: Duration(milliseconds: 10000),
                          itemBuilder: (BuildContext context, int index,
                              Animation<double> animation) {
                            return FadeTransition(
                              key: UniqueKey(),
                              opacity: animation,
                              child: UserMessage(
                                senderName: messages[index].senderName,
                                question: widget
                                    .ChatModel.questions[widget.questionNumber],
                                questionNumber: widget.questionNumber,
                                key: ValueKey(messages[index]),
                                chatId: widget.ChatModel.chatId,
                                message: messages[index],
                              ),
                            );
                          },
                          itemCount: widget.numberPlayers,
                        )),
                        if (widget.questionNumber < 4)
                          TextButton(
                              onPressed: () {
                                pushReplacement(
                                  context: context,
                                  page: RepositoryProvider(
                                      create: (context) => GifRepository(),
                                      child: GifChooseScreen(
                                        chatModel: widget.ChatModel,
                                        questionNumber:
                                            widget.questionNumber + 1,
                                      )),
                                );
                              },
                              child: Text(
                                'next match',
                                style: GoogleFonts.chango(
                                  color: Colors.orangeAccent,
                                  fontSize: 20.0,
                                ),
                              )),
                        if (widget.questionNumber == 4)
                          TextButton(
                              onPressed: () {
                                push(
                                    context: context,
                                    rootNavigator: true,
                                    page: ScoreScreen(
                                      chatID: widget.ChatModel.chatId,
                                    ));
                              },
                              child: Text(
                                'finish game ',
                                style: GoogleFonts.chango(
                                  color: Colors.orangeAccent,
                                  fontSize: 20.0,
                                ),
                              )),
                        if (hasFailedMessages(messages.toList()))
                          FailedToDeliverMessageWidget(
                              chatId: widget.ChatModel.chatId)
                      ],
                    );
                  } else
                    return Center(
                        child: Column(
                      children: [
                        SizedBox(
                          height: 100,
                        ),
                        Text(
                          "chat id is : " + widget.ChatModel.chatId,
                          style: GoogleFonts.chango(
                            color: Colors.white,
                            fontSize: 20.0,
                          ),
                        ),
                        SizedBox(
                          height: 140,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(14.0),
                          child: Text(
                            'waiting for all playrs make they choose',
                            style: GoogleFonts.chango(
                              color: Colors.white,
                              fontSize: 22.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ));
                }
                return Offstage();
              },
            ),
          ),
          // shows new message button
        ],
      ),
    );
  }

  void animateToBottom(final double offset) {
    if (_controller.hasClients) {
      _controller.jumpTo(offset);
    }
  }

  void _updateLatestMessage(final MessagesLoaded state) {
    context.read<MessageCubit>().updateNewMessages(state);
    context.read<NewMessagesCubit>().emptyMessages();
    // animateToBottom(lastPos);
    lastPos = 0.0;
  }

  void _updateMessageOnScroll() {
    if (lastPos > 0) {
      final state = context.read<NewMessagesCubit>().state;
      if (state is MessagesLoaded && state.messagesModel.messages.isNotEmpty)
        _updateLatestMessage(state);
    }
  }

  void _fetchOldMessagesOnScroll() {
    final maxScroll = _controller.position.maxScrollExtent;
    final currentScroll = _controller.offset;
    final notOutOfRange = !_controller.position.outOfRange;

    final isInView = maxScroll - currentScroll <= 50;
    if (isInView && notOutOfRange) {
      _fetchMore();
    }
  }

  Future<void> loadAgain(final MessagesModel model) async {
    // call the provider to fetch more messages
    if (model.lastDoc != null) {
      context
          .read<LoadMoreMessageCubit>()
          .loadMoreMessages(widget.ChatModel.chatId, model.lastDoc!);
    }
  }

  Future<void> _fetchMore({bool tryAgain = false}) async {
    final state = context.read<MessageCubit>().state;
    if (state is MessagesLoaded) {
      if (tryAgain) {
        loadAgain(state.messagesModel);
      } else {
        final loadMoreState = context.read<LoadMoreMessageCubit>().state;
        if (loadMoreState is! LoadingMessages &&
            loadMoreState is! MessagesFailed &&
            state.hasMore) {
          loadAgain(state.messagesModel);
        }
      }
    }
  }

  void sendMessage(String text) {
    final message = MessageModel.newMessage(
        text, currentUserId, CurrentUser.currentUserName);
    widget.onSentButtonPressed.call(message);
  }
}

extension on num {
  bool get isInt => this % 1 == 0;
}
