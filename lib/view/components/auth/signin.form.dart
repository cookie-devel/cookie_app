import 'package:cookie_app/view/components/CustomTextFormField.dart';
import 'package:cookie_app/view/components/auth/submit_button.dart';
import 'package:cookie_app/handler/signinout.handler.dart';
import 'package:cookie_app/main.dart';
import 'package:flutter/material.dart';
import 'package:cookie_app/view/components/auth/validator.dart';

// https://docs.flutter.dev/cookbook/forms/validation

class SignInForm extends StatelessWidget {
  SignInForm({Key? key}) : super(key: key);

  final _formKey = GlobalKey<FormState>();

  IDField idField = IDField();
  PWField pwField = PWField();

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

ElevatedButton signInButton({
  required BuildContext context,
  required GlobalKey<FormState> formKey,
  required IDField id,
  required PWField pw,
}) {
  return submitButton(
    onPressed: () async {
      if (!formKey.currentState!.validate()) return null;
      formKey.currentState!.save();
      return await handleSignIn(id.value, pw.value);
    },
    text: '로그인',
    onSuccess: () {
      const snackBar = SnackBar(
        content: Text('Welcome!'),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const MainWidget(),
        ),
      );
    },
    onFailure: () {
      const snackBar = SnackBar(
        content: Text('로그인에 실패하였습니다.'),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    },
  );
}

Container wrapped(child) {
  return Container(
    margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
    child: child,
  );
}
