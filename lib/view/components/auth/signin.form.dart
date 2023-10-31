import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:cookie_app/service/auth.service.dart';
import 'package:cookie_app/utils/logger.dart';
import 'package:cookie_app/view/components/auth/submit_button.dart';
import 'package:cookie_app/view/components/snackbar.dart';
import 'package:cookie_app/view/components/text_form_fields.dart';

class SignInForm extends StatefulWidget {
  const SignInForm({super.key});

  @override
  State<SignInForm> createState() => _SignInFormState();
}

class _SignInFormState extends State<SignInForm> {
  final _formKey = GlobalKey<FormState>();

  String? id;
  String? pw;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: AutofillGroup(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            IDField(onSaved: (newValue) => id = newValue!),
            PWField(onSaved: (newValue) => pw = newValue!),
            SubmitButton(
              onPressed: () {
                if (!_formKey.currentState!.validate()) return;
                _formKey.currentState!.save();
                context
                    .read<AuthService>()
                    .signIn(
                      id: id!,
                      pw: pw!,
                    )
                    .catchError((e) {
                  logger.w(e.toString());
                  showErrorSnackBar(context, '로그인에 실패하였습니다. ${e.toString()}');
                });
              },
              text: '로그인',
            ),
          ].map(wrapped).toList(),
        ),
      ),
    );
  }
}

Container wrapped(child) {
  return Container(
    margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
    child: child,
  );
}
