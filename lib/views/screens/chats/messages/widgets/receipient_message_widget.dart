import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:glassmorphism/glassmorphism.dart';
import '../../../../../blocs/bloc.dart';
import '../../../../../model/chat/message_model.dart';
import '../../../../../model/pure_user_model.dart';

class ReceipientMessage extends StatelessWidget {
  final MessageModel message;
  final bool hideNip;
  final bool isGroupMessage;
  const ReceipientMessage(
      {Key? key,
      required this.message,
      required this.hideNip,
      this.isGroupMessage = false})
      : super(key: key);

  static late PureUser? _senderUser;

  @override
  Widget build(BuildContext context) {
    if (isGroupMessage) {
      getSenderName(context, message.senderId);
    }
    return Align(
      alignment: Alignment.center,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: 1.sw * 0.85),
        child: GlassmorphicFlexContainer(
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
          child: isGroupMessage
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 2, top: 2),
                      child: Text(
                        "@${_senderUser?.username}",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: _senderUser?.color ?? Colors.green,
                        ),
                      ),
                    ),
                    _MessageBody(message: message),
                  ],
                )
              : _MessageBody(message: message),
        ),
      ),
    );
  }

  void getSenderName(BuildContext context, String userId) {
    final state = BlocProvider.of<GroupCubit>(context).state;
    if (state is GroupMembers)
      _senderUser =
          state.members.firstWhereOrNull((member) => member.id == userId);
  }
}

class _MessageBody extends StatelessWidget {
  final MessageModel message;
  const _MessageBody({Key? key, required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20.0),
      child: Image.network(
        message.text,
        fit: BoxFit.cover,
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
    );
  }
}
