import 'package:cookie_app/components/CustomTextFormField.dart';
import 'package:cookie_app/handler/signinout.handler.dart';
import 'package:cookie_app/main.dart';
import 'package:flutter/material.dart';
import 'package:cookie_app/components/auth/validator.dart';

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
  return ElevatedButton(
    style: ElevatedButton.styleFrom(
      backgroundColor: Colors.deepOrangeAccent,
      minimumSize: const Size.fromHeight(50),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
        side: const BorderSide(color: Colors.black45, width: 2),
      ),
    ),
    child: const Text(
      '로그인',
      style: TextStyle(
        fontSize: 19,
        color: Colors.white,
      ),
    ),
    onPressed: () async {
      if (!formKey.currentState!.validate()) return;
      formKey.currentState!.save();
      bool signin = await handleSignIn(id.value, pw.value);

      signin
          ? Future<void>.microtask(() {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const MainWidget(),
                ),
              );
            })
          : Future<void>.microtask(
              () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('알림'),
                      content: const Text('로그인에 실패하였습니다.'),
                      actions: [
                        TextButton(
                          child: const Text('확인'),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      ],
                    );
                  },
                );
              },
            );
    },
  );
}

Container wrapped(child) {
  return Container(
    margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
    child: child,
  );
}
