import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pure/views/widgets/background.dart';
import '../../../../blocs/bloc.dart';
import '../../../../model/pure_user_model.dart';
import '../../../../utils/app_extension.dart';
import '../../../../utils/validators.dart';
import '../../../widgets/snackbars.dart';

class EditProfileName extends StatefulWidget {
  final PureUser user;
  const EditProfileName({Key? key, required this.user}) : super(key: key);

  @override
  _EditProfileNameState createState() => _EditProfileNameState();
}

class _EditProfileNameState extends State<EditProfileName> {
  final _formKey = GlobalKey<FormState>();

  final _firstNameController = TextEditingController();

  final _firstNameNode = FocusNode();

  @override
  void initState() {
    super.initState();
    initializeUserData(widget.user);
  }

  @override
  void dispose() {
    _firstNameController.dispose();

    _firstNameNode.dispose();

    super.dispose();
  }

  void initializeUserData(final PureUser user) {
    _firstNameController.text = user.firstName;
  }

  // update as state in Bloc Listener updates
  void updateProfileStateListener(
      BuildContext context, UserProfileState state) {
    if (state is Loading) {
      EasyLoading.show(status: 'Updating...');
    } else if (state is UserProfileUpdateSuccess) {
      EasyLoading.dismiss();
      Navigator.pop(context);
    } else if (state is UserProfileUpdateFailure) {
      EasyLoading.dismiss();
      showFailureFlash(context, state.message);
    }
  }

  @override
  Widget build(BuildContext context) {
    final primaryVariantColor = Theme.of(context).colorScheme.primaryContainer;

    return Background(
        child: Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(
          'Edit Name',
          style: GoogleFonts.chango(
            color: Colors.white,
            fontSize: 20.0,
          ),
        ),
        actions: [
          TextButton(
            onPressed: updateProfile,
            child: Text(
              'Save',
              style: GoogleFonts.chango(
                color: Colors.orangeAccent,
                fontSize: 20.0,
              ),
            ),
          ),
        ],
      ),
      body: BlocListener<UserProfileCubit, UserProfileState>(
        listener: updateProfileStateListener,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // profile widget
                  SizedBox(
                    height: 80,
                  ),

                  Column(
                    children: [
                      Center(
                        child: SizedBox(
                          width: 280,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: TextFormField(
                              autofocus: true,
                              onEditingComplete: updateProfile,
                              cursorColor: primaryVariantColor,
                              controller: _firstNameController,
                              focusNode: _firstNameNode,
                              validator: Validators.validateInput(
                                  error: "Enter a valid name"),
                              decoration: InputDecoration(
                                hintText: 'new name',
                                hintStyle: const TextStyle(color: Colors.white),
                                hintTextDirection: TextDirection.ltr,
                                prefixIcon: Icon(
                                  Icons.account_circle_outlined,
                                  color: Colors.white,
                                ),
                                fillColor: Colors.orangeAccent.withAlpha(120),
                                filled: true,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                              onFieldSubmitted: (_) => FocusScope.of(context)
                                  .requestFocus(_firstNameNode),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 30.0),
                ],
              ),
            ),
          ),
        ),
      ),
    ));
  }

  void updateProfile() {
    FocusScope.of(context).unfocus(); // hides active keyboard
    if (_formKey.currentState!.validate()) {
      final user = widget.user;
      final userModel = PureUser(
          id: user.id,
          username: user.username,
          email: user.email,
          firstName: _firstNameController.text.trim().toSentenceCase(),
          lastName: '',
          location: '',
          photoURL: user.photoURL,
          about: '');

      BlocProvider.of<UserProfileCubit>(context)
          .updateUserProfile(user.id, userModel.toUpdateMap());
    }
    CurrentUser.setUserName = _firstNameController.text.trim().toSentenceCase();
    Navigator.of(context).pop();
  }
}
