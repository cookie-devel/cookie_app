import 'dart:io';

import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:cookie_app/datasource/api/auth.dart';
import 'package:cookie_app/types/account/profile.dart';
import 'package:cookie_app/view/components/auth/submit_button.dart';
import 'package:cookie_app/view/components/profile_imgpicker.dart';
import 'package:cookie_app/view/components/snackbar.dart';
import 'package:cookie_app/view/components/text_form_fields.dart';
import 'package:cookie_app/viewmodel/auth.viewmodel.dart';

class SignUpForm extends StatefulWidget {
  const SignUpForm({super.key});

  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _pass = TextEditingController();

  String? id;
  String? pw;
  String? name;
  DateTime? birthday;
  String? phoneNumber;
  File? profileImg;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: AutofillGroup(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ProfileImagePicker(
              profileImg: profileImg == null
                  ? const AssetImage("assets/images/kz1.png") as ImageProvider
                  : FileImage(profileImg!),
              setImage: (img) => setState(() => profileImg = img),
            ),
            NewIDField(onSaved: (newValue) => id = newValue),
            NewPWField(controller: _pass, onSaved: (newValue) => pw = newValue),
            NewPWConfirmField(pwController: _pass),
            NameField(onSaved: (newValue) => name = newValue),
            BirthdayField(
              onSaved: (newValue) => birthday = DateTime.parse(newValue!),
            ),
            PhoneNumberField(onSaved: (newValue) => phoneNumber = newValue),
            SubmitButton(
              onPressed: () {
                SignUpRequest signUpForm = SignUpRequest(
                  userid: id!,
                  password: pw!,
                  username: name!,
                  birthday: birthday.toString(),
                  phone: phoneNumber!,
                  profile: Profile(
                    image: profileImg?.path,
                    message: null,
                  ),
                );
                if (!_formKey.currentState!.validate()) return;
                _formKey.currentState!.save();

                context
                    .read<AuthViewModel>()
                    .handleSignUp(_formKey.currentState!, signUpForm)
                    .then((_) => onSignUpSuccess(context))
                    .catchError((e) => onSignUpFailure(context, e));
              },
              text: '회원가입',
            ),
          ].map(wrapped).toList(),
          // ],
        ),
      ),
    );
  }

  onSignUpSuccess(context) {
    showSnackBar(context, '회원가입이 완료되었습니다.');
    Navigator.pop(context);
  }

  onSignUpFailure(context, e) {
    showErrorSnackBar(context, '회원가입에 실패하였습니다. ${e.toString()}');
    throw e;
  }
}

Container wrapped(child) {
  return Container(
    margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
    child: child,
  );
}
