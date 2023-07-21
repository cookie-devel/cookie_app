import 'package:cookie_app/view/components/auth/submit_button.dart';
import 'package:cookie_app/view/components/error_message.dart';
import 'package:cookie_app/viewmodel/account.viewmodel.dart';
import 'package:cookie_app/viewmodel/auth.viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cookie_app/view/components/text_form_fields.dart';

class SignInForm extends StatefulWidget {
  const SignInForm({Key? key}) : super(key: key);

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
              onPressed: () async {
                if (!_formKey.currentState!.validate()) return;
                _formKey.currentState!.save();
                return await Provider.of<AuthViewModel>(context, listen: false).signIn(
                  id: id!,
                  pw: pw!,
                  privateAccountViewModel: Provider.of<PrivateAccountViewModel>(
                    context,
                    listen: false,
                  ),
                );
              },
              text: '로그인',
              onFailure: (context, e) =>
                  showErrorSnackBar(context, '로그인에 실패하였습니다. ${e.toString()}'),
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
