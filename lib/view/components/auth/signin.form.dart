import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:cookie_app/view/components/auth/submit_button.dart';
import 'package:cookie_app/view/components/snackbar.dart';
import 'package:cookie_app/view/components/text_form_fields.dart';
import 'package:cookie_app/viewmodel/auth.viewmodel.dart';

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
                    .read<AuthViewModel>()
                    .handleSignIn(id!, pw!)
                    .then((_) => onSignInSuccess(context))
                    .catchError((e) => onSignInFailure(context, e));
              },
              text: '로그인',
            ),
          ].map(wrapped).toList(),
        ),
      ),
    );
  }
}

onSignInSuccess(context) {
  showSnackBar(context, '로그인이 완료되었습니다.');
  Navigator.pop(context);
}

onSignInFailure(context, e) {
  showErrorSnackBar(context, '로그인에 실패하였습니다. ${e.toString()}');
  throw e;
}

Container wrapped(child) {
  return Container(
    margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
    child: child,
  );
}
