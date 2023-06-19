import 'package:cookie_app/view/components/CustomTextFormField.dart';
import 'package:cookie_app/view/components/auth/submit_button.dart';
import 'package:cookie_app/viewmodel/account.viewmodel.dart';
import 'package:cookie_app/viewmodel/auth.viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:cookie_app/view/components/auth/validator.dart';
import 'package:provider/provider.dart';

// https://docs.flutter.dev/cookbook/forms/validation

class SignInForm extends StatelessWidget {
  SignInForm({Key? key}) : super(key: key);

  final _formKey = GlobalKey<FormState>();

  final IDField idField = IDField();
  final PWField pwField = PWField();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: AutofillGroup(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            idField,
            pwField,
            signInButton(
              context: context,
              formKey: _formKey,
              id: idField,
              pw: pwField,
            ),
          ].map(wrapped).toList(),
        ),
      ),
    );
  }
}

class IDField extends CustomTextFormField {
  IDField({Key? key})
      : super(
          key: key,
          labelText: "아이디",
          validator: validateID,
          autofillHints: [AutofillHints.username],
        );
}

class PWField extends CustomTextFormField {
  PWField({Key? key})
      : super(
          key: key,
          obscureText: true,
          labelText: "비밀번호",
          validator: validatePW,
          autofillHints: [AutofillHints.password],
        );
}

SubmitButton signInButton({
  required BuildContext context,
  required GlobalKey<FormState> formKey,
  required IDField id,
  required PWField pw,
}) {
  return SubmitButton(
    onPressed: () async {
      if (!formKey.currentState!.validate()) return null;
      formKey.currentState!.save();
      await Provider.of<AuthViewModel>(context, listen: false).signIn(
        id: id.value!,
        pw: pw.value!,
        privateAccountViewModel: Provider.of<PrivateAccountViewModel>(context, listen: false),
      );
      return null;
    },
    text: '로그인',
    onSuccess: onSignInSuccess,
    onFailure: onSignInFailure,
  );
}

onSignInSuccess(context) {
  const snackBar = SnackBar(
    content: Text('Welcome!'),
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

onSignInFailure(context) {
  const snackBar = SnackBar(
    content: Text('로그인에 실패하였습니다.'),
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

Container wrapped(child) {
  return Container(
    margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
    child: child,
  );
}
