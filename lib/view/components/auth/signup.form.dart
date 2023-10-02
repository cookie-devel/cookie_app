import 'dart:io';
import 'package:cookie_app/types/account/profile.dart';
import 'package:cookie_app/types/form/signup.dart';
import 'package:cookie_app/view/components/auth/submit_button.dart';
import 'package:cookie_app/view/components/snackbar.dart';
import 'package:cookie_app/view/components/profile_imgpicker.dart';
import 'package:cookie_app/view/components/text_form_fields.dart';
import 'package:cookie_app/viewmodel/auth.viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SignUpForm extends StatefulWidget {
  const SignUpForm({Key? key}) : super(key: key);

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
              onPressed: () async {
                if (!_formKey.currentState!.validate()) return;
                _formKey.currentState!.save();
                await context.read<AuthViewModel>().signUp(
                      SignUpFormModel(
                        id: id!,
                        pw: pw!,
                        name: name!,
                        birthday: birthday.toString(),
                        phoneNumber: phoneNumber!,
                        profile: Profile(
                          image: profileImg?.path,
                          message: null,
                        ),
                      ),
                    );
              },
              text: '회원가입',
              onSuccess: onSignUpSuccess,
              onFailure: onSignUpFailure,
            ),
          ].map(wrapped).toList(),
        ),
      ),
    );
  }

  onSignUpSuccess(context) {
    showSnackBar(context: context, message: '회원가입이 완료되었습니다.');
    Navigator.pop(context);
  }

  onSignUpFailure(context, e) {
    showErrorSnackBar(context, '회원가입에 실패하였습니다. ${e.toString()}');
  }
}

Container wrapped(child) {
  return Container(
    margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
    child: child,
  );
}
