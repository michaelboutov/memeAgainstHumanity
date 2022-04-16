import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../blocs/bloc.dart';
import '../../../../../model/chat/chat_model.dart';
import '../../../../../utils/image_utils.dart';

class GroupBanner extends StatefulWidget {
  final ChatModel chat;
  const GroupBanner({Key? key, required this.chat}) : super(key: key);

  @override
  State<GroupBanner> createState() => _GroupBannerState();
}

class _GroupBannerState extends State<GroupBanner> {
  ImageMethods imageMethods = ImageUtils();

  File? imageFile;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Stack(
        alignment: Alignment.center,
        fit: StackFit.expand,
        children: [
          if (imageFile != null)
            Image.file(imageFile!, fit: BoxFit.cover)
          else if (widget.chat.groupImage!.isEmpty)
            Image.asset(ImageUtils.user, fit: BoxFit.cover)
          else
            Hero(
              tag: widget.chat.groupImage!,
              child: CachedNetworkImage(
                imageUrl: widget.chat.groupImage!,
                fit: BoxFit.cover,
              ),
            ),
          BlocConsumer<GroupChatCubit, GroupChatState>(
            listener: (context, state) {
              if (state is GroupChatUpdated) imageFile = null;
            },
            builder: (context, state) {
              if (state is UploadingGroupImage)
                return Center(child: CircularProgressIndicator());
              return Offstage();
            },
          ),
        ],
      ),
    );
  }
}
