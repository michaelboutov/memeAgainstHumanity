import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:pure/repositories/gif_repository.dart';
import 'package:pure/services/chat/chat_service.dart';
import 'package:pure/views/screens/gif_choose/gif_choose_screen.dart';
import 'package:pure/views/widgets/gradient_text.dart';
import 'package:pure/views/widgets/rounded_button.dart';
import 'package:pure/views/widgets/snackbars.dart';
import 'package:pure/views/widgets/user_profile_provider.dart';
import '../../../../blocs/bloc.dart';
import '../../../../model/chat/chat_model.dart';
import '../../../../model/pure_user_model.dart';
import '../../../../utils/app_utils.dart';
import '../../../../utils/navigate.dart';

class CreateGameScreen extends StatefulWidget {
  const CreateGameScreen({Key? key}) : super(key: key);

  @override
  _CreateGameScreenState createState() => _CreateGameScreenState();
}

class _CreateGameScreenState extends State<CreateGameScreen> {
  int currentValue = 1;
  File? imageFile;

  @override
  Widget build(BuildContext context) {
    return BlocListener<GroupChatCubit, GroupChatState>(
      listener: createGroupChatStateListener,
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
                fit: BoxFit.cover,
                image: AssetImage('assets/images/background.png')),
          ),
          child: Center(
            child: GlassmorphicContainer(
              width: MediaQuery.of(context).size.width * 0.8,
              height: MediaQuery.of(context).size.height * 0.8,
              borderRadius: 20,
              blur: 25,
              alignment: Alignment.bottomCenter,
              border: 2,
              linearGradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFFffffff).withOpacity(0.15),
                    Color(0xFFFFFFFF).withOpacity(0.15),
                  ],
                  stops: [
                    0.1,
                    1,
                  ]),
              borderGradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFFffffff).withOpacity(0.3),
                  Color((0xFFFFFFFF)).withOpacity(0.3),
                ],
              ),
              child: Column(
                children: [
                  GradientText(
                      text: "create game", fontSize: 30.0, width: 270.0),
                  SizedBox(
                    height: 40,
                  ),
                  Text(
                    'number of players:',
                    style: GoogleFonts.chango(
                      color: Colors.white,
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  NumberPicker(
                    selectedTextStyle: GoogleFonts.chango(
                      color: Colors.orangeAccent,
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                    value: currentValue,
                    minValue: 1,
                    maxValue: 8,
                    onChanged: (value) => setState(() => currentValue = value),
                  ),
                  SizedBox(
                    height: 60,
                  ),
                  BlocBuilder<GroupCubit, GroupState>(
                    builder: (context, state) {
                      return RoundedButton(
                        onPressed: () => createGroupChat(),
                        label: 'lets go',
                      );
                    },
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // update as state in Bloc Listener updates
  void createGroupChatStateListener(
      BuildContext context, GroupChatState state) {
    if (state is GroupChatCreated) {
      EasyLoading.dismiss();
      Navigator.popUntil(context, (route) => route.isFirst);

      push(
        context: context,
        page: GroupMembersProvider(
          members: state.chatModel.questions,
          child: RepositoryProvider(
              create: (context) => GifRepository(),
              child: GifChooseScreen(
                  chatModel: state.chatModel, questionNumber: 0)),
        ),
      );
    } else if (state is GroupChatsFailed) {
      EasyLoading.dismiss();
      showFailureFlash(context, state.message);
    }
  }

  Future<void> createGroupChat() async {
    FocusScope.of(context).unfocus();
    var chatServise = ChatServiceImp();
    final currentState = context.read<GroupCubit>().state;
    if (currentState is GroupMembers) {
      List<String> members = currentState.members.map((e) => e.id).toList();
      members.insert(0, CurrentUser.currentUserId);
      List<String> questions = [];
      for (int i = 0; i < 5; i++) {
        String question = await chatServise.getQuestion();
        questions.insert(i, question);
      }
      String id = generateDatabaseId();
      final chatModel = ChatModel(
        chatId: id,
        type: ChatType.Group,
        groupName: id,
        creationDate: DateTime.now(),
        lastMessage: "Group created",
        groupCreatedBy: CurrentUser.currentUserId,
        questions: questions,
        members: members,
        updateDate: DateTime.now(),
        groupDescription: currentValue,
        groupImage: "",
      );

      context.read<GroupChatCubit>().createGroupChat(
            chatModel,
          );
    }
  }
}
