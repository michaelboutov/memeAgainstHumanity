import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pure/blocs/authentication/auth_cubit.dart';
import 'package:pure/blocs/authentication/auth_state.dart';
import 'package:pure/blocs/chats/chats/group/group_chat_cubit.dart';
import 'package:pure/blocs/chats/chats/group/group_cubit.dart';
import 'package:pure/blocs/user_profile/user_profile_cubit.dart';
import 'package:pure/model/pure_user_model.dart';
import 'package:pure/repositories/gif_repository.dart';
import 'package:pure/services/chat/chat_service.dart';
import 'package:pure/services/user_service.dart';
import 'package:pure/utils/image_utils.dart';
import 'package:pure/utils/navigate.dart';
import 'package:pure/views/screens/create_game/create_game_screen.dart';
import 'package:pure/views/screens/gif_choose/gif_choose_screen.dart';
import 'package:pure/views/screens/settings/profile/edit_profile_name.dart';
import 'package:pure/views/widgets/background.dart';
import 'package:pure/views/widgets/custom_textfield.dart';
import 'package:pure/views/widgets/rounded_button.dart';

class StartGameScreen extends StatefulWidget {
  const StartGameScreen({Key? key}) : super(key: key);

  @override
  State<StartGameScreen> createState() => _StartGameScreenState();
}

class _StartGameScreenState extends State<StartGameScreen> {
  TextEditingController inputControler = TextEditingController();
  var chatServise = ChatServiceImp();
  @override
  void initState() {
    Future.delayed(Duration.zero, () {
      if (CurrentUser.currentUserName == "") _showMyDialog(context);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Background(
        child: Center(
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
        child: Column(children: [
          SizedBox(
            height: 20,
          ),
          Image.asset(ImageUtils.logo,
              fit: BoxFit.contain, height: 200.0, width: 200.0),
          SizedBox(
            height: 60,
          ),
          RoundedButton(
            label: 'create game',
            onPressed: () {
              pushToCreateNewGroupScreen(context);
            },
          ),
          SizedBox(
            height: 60,
          ),
          Center(
              child: Text(
            "-or-",
            style: GoogleFonts.chango(
              color: Colors.orangeAccent.withAlpha(110),
              fontSize: 20.0,
            ),
          )),
          SizedBox(
            height: 60,
          ),
          CustomTextField(
              controller: inputControler,
              hintText: 'find game',
              keyboardType: TextInputType.text,
              onSubmit: findGroupScreen(context),
              prefixIcon: Icon(
                Icons.search,
                color: Colors.white,
              )),
        ]),
      ),
    ));
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

  Future<void> pushToCreateNewGroupScreen(BuildContext context) async {
    push(
      context: context,
      rootNavigator: true,
      page: MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => GroupCubit(ChatServiceImp())),
          BlocProvider(
            create: (_) => GroupChatCubit(ChatServiceImp()),
          ),
        ],
        child: CreateGameScreen(),
      ),
    );
  }

  Future<void> findGroupScreen(BuildContext context) async {
    var chatModel = await chatServise.findGroupChat(inputControler.text);
    List<String> newMember = [CurrentUser.currentUserId];
    String chatId = chatModel!.chatId;
    await chatServise.addNewParticipants(chatId, newMember);

    push(
      context: context,
      page: RepositoryProvider(
          create: (context) => GifRepository(),
          child: GifChooseScreen(
            chatModel: chatModel,
            questionNumber: 0,
          )),
    );
  }
}

// ignore: must_be_immutable
Future<void> _showMyDialog(BuildContext context) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: Colors.white,
        title: Text(
          'you dont have nicname',
          style: GoogleFonts.chango(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 18.0,
          ),
        ),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text(
                'You need to set your nicname',
                style: GoogleFonts.chango(
                  color: Colors.black,
                  fontSize: 18.0,
                ),
              ),
            ],
          ),
        ),
        actions: <Widget>[
          BlocListener<AuthCubit, AuthState>(
            listener: signOutListener,
            child: BlocBuilder<AuthCubit, AuthState>(
              builder: (context, state) {
                if (state is Authenticated) {
                  final user = state.user;
                  return Column(
                    children: [
                      // Profile
                      TextButton(
                          onPressed: () => pushToScreen(
                                context,
                                MultiBlocProvider(
                                  providers: [
                                    BlocProvider(
                                      create: (_) =>
                                          UserProfileCubit(UserServiceImpl()),
                                    )
                                  ],
                                  child: EditProfileName(user: user),
                                ),
                              ),
                          child: Text(
                            'set name',
                            style: GoogleFonts.chango(
                              color: Colors.orangeAccent,
                              fontSize: 20.0,
                            ),
                          ))
                    ],
                  );
                }
                return Offstage();
              },
            ),
          )
        ],
      );
    },
  );
}

void signOutListener(BuildContext context, AuthState authState) {
  if (authState is UnAuthenticated) {
    GoRouter.of(context).goNamed("social");
  }
}

void pushToScreen(BuildContext context, Widget page) {
  push(context: context, page: page);
}
