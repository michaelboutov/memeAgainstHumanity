import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../blocs/bloc.dart';
import '../../../../../model/chat/chat_model.dart';
import '../../../../../model/pure_user_model.dart';
import '../../../../../utils/navigate.dart';
import '../../../../../utils/palette.dart';
import '../../../../widgets/avatar.dart';
import '../../../settings/profile/profile_screen.dart';

class MessageAppBarTitle extends StatelessWidget {
  final String chatId;
  final PureUser receipient;
  final bool hasPresenceActivated;
  const MessageAppBarTitle({
    Key? key,
    required this.chatId,
    required this.receipient,
    this.hasPresenceActivated = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => viewFullProfile(context, receipient),
      child: Row(
        children: [
          Avartar(
            size: 22,
            ringSize: 0.8,
            imageURL: receipient.photoURL,
          ),
          const SizedBox(width: 10.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  receipient.fullName,
                  maxLines: 1,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 17.5,
                    fontFamily: Palette.sanFontFamily,
                    letterSpacing: 0.5,
                  ),
                ),
                if (hasPresenceActivated)
                  BlocBuilder<UserPresenceCubit, UserPresenceState>(
                    builder: (context, state) {
                      final status = state is UserPresenceSuccess &&
                          state.presence.isOnline;
                      if (status)
                        return Padding(
                          padding: const EdgeInsets.only(top: 2.0),
                          child: Text(
                            "Online",
                            maxLines: 1,
                            style: TextStyle(
                              color: Theme.of(context)
                                  .colorScheme
                                  .primaryContainer
                                  .withOpacity(0.6),
                              fontWeight: FontWeight.w400,
                              fontSize: 13.0,
                              fontFamily: Palette.sanFontFamily,
                              letterSpacing: 0.25,
                            ),
                          ),
                        );
                      return Offstage();
                    },
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void viewFullProfile(BuildContext context, PureUser user) {
    push(
      context: context,
      page: ProfileScreen(user: user, hideConnectionStatus: true),
    );
  }
}

class GroupMessageAppBarTitle extends StatefulWidget {
  final ChatModel chat;
  const GroupMessageAppBarTitle({Key? key, required this.chat})
      : super(key: key);

  @override
  State<GroupMessageAppBarTitle> createState() =>
      _GroupMessageAppBarTitleState();
}

class _GroupMessageAppBarTitleState extends State<GroupMessageAppBarTitle> {
  late ChatModel chat;

  @override
  void initState() {
    super.initState();
    chat = widget.chat;
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Center(
        child: Text(
          chat.groupName!,
          maxLines: 1,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 17.5,
            fontFamily: Palette.sanFontFamily,
            letterSpacing: 0.5,
          ),
        ),
      ),
    );
  }
}
