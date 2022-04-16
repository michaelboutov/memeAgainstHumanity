import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:pure/views/widgets/background.dart';
import '../../../blocs/bloc.dart';
import '../../../utils/image_utils.dart';
import '../../../utils/palette.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/snackbars.dart';
import 'widgets/auth_bloc_provider.dart';
import 'widgets/intro_section.dart';
import 'widgets/social_signin_button.dart';

class SocialSignInScreen extends StatelessWidget {
  const SocialSignInScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return const AuthBlocProvider(child: SocialSignInScreenExt());
  }
}

class SocialSignInScreenExt extends StatelessWidget {
  const SocialSignInScreenExt({Key? key}) : super(key: key);

  static TextStyle _style = const TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
  );

  // update as state in Bloc Listener updates
  void authStateListener(BuildContext context, AuthUserState state) {
    if (state is AuthInProgress) {
      EasyLoading.show(status: 'Authenticating...');
    } else if (state is LoginSuccess) {
      EasyLoading.dismiss();
      BlocProvider.of<AuthCubit>(context).authenticateUser();
      GoRouter.of(context).goNamed("home");
    } else if (state is AuthUserFailure) {
      EasyLoading.dismiss();
      showFailureFlash(context, state.message);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Background(
        child: Scaffold(
      backgroundColor: Colors.transparent,
      body: BlocListener<AuthUserCubit, AuthUserState>(
        listener: authStateListener,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20)
                .add(const EdgeInsets.only(bottom: 20)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: 1.sh * 0.22, child: const IntroSection()),
                Image.asset(ImageUtils.logo,
                    fit: BoxFit.contain, height: 200.0, width: 200.0),
                SizedBox(
                  height: 60,
                ),
                const GoogleSignInButton(),
                if (Platform.isIOS)
                  const Padding(
                    padding: EdgeInsets.only(top: 21),
                    child: AppleSignInButton(),
                  ),
                SizedBox(height: 23.h),
                SizedBox(
                  height: 16,
                  child: Row(
                    children: [
                      Expanded(
                        child: Divider(
                          color: Theme.of(context).colorScheme.primaryContainer,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Text(
                          'or',
                          style: _style.copyWith(
                            color:
                                Theme.of(context).colorScheme.primaryContainer,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Divider(
                          color: Theme.of(context).colorScheme.primaryContainer,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 23.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomButton(
                      title: 'SIGN UP',
                      onPressed: () => goTosignUpScreen(context),
                    ),
                    const SizedBox(width: 20),
                    CustomOutlinedButton(
                      title: 'SIGN IN',
                      side: BorderSide(color: Palette.tintColor),
                      onPressed: () => goTosignInScreen(context),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    ));
  }

  Future<void> goTosignInScreen(BuildContext context) async {
    GoRouter.of(context).pushNamed("signin");
  }

  Future<void> goTosignUpScreen(BuildContext context) async {
    GoRouter.of(context).pushNamed("signup");
  }
}
