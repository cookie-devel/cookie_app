import 'dart:io';

import 'package:cookie_app/components/CustomTextFormField.dart';
import 'package:cookie_app/components/auth/submit_button.dart';
import 'package:cookie_app/components/auth/validator.dart';
import 'package:cookie_app/handler/signup.handler.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';

// https://docs.flutter.dev/cookbook/forms/validation

class IDField extends CustomTextFormField {
  IDField({Key? key})
      : super(
          key: key,
          labelText: "아이디",
          validator: validateID,
          autofillHints: [AutofillHints.newUsername],
        );
}

class PWField extends CustomTextFormField {
  PWField({Key? key})
      : super(
          key: key,
          obscureText: true,
          labelText: "비밀번호",
          validator: validatePW,
          autofillHints: [AutofillHints.newPassword],
        );
}

class PWCheckField extends CustomTextFormField {
  PWCheckField({Key? key, required PWField pwField})
      : super(
          key: key,
          obscureText: true,
          labelText: "비밀번호 확인",
          validator: (pwCheck) {
            return validatePWCheck(
              pwField.controller.text,
              pwCheck,
            );
          },
          autofillHints: [AutofillHints.newPassword],
        );
}

class NameField extends CustomTextFormField {
  NameField({Key? key})
      : super(
          key: key,
          labelText: "이름",
          validator: validateName,
          autofillHints: [AutofillHints.name],
        );
}

class BirthdayField extends StatefulWidget {
  BirthdayField({super.key});
  String? value;

  @override
  State<BirthdayField> createState() => _BirthdayFieldState();
}

class _BirthdayFieldState extends State<BirthdayField> {
  DateTime? _selectedDate;

  final TextEditingController _dateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      readOnly: false,
      controller: _dateController,
      obscureText: false,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(90.0),
        ),
        labelText: '생년월일',
        suffixIcon: const Icon(Icons.calendar_today),
      ),
      validator: validateBirthday,
      onSaved: (newValue) {
        widget.value = newValue;
      },
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
        DatePicker.showDatePicker(
          context,
          showTitleActions: true,
          locale: LocaleType.ko,
          minTime: DateTime(1900, 1, 1),
          maxTime: DateTime.now(),
          onConfirm: (date) {
            setState(() {
              _selectedDate = date;
            });
            _dateController.text =
                DateFormat('yyyy-MM-dd').format(_selectedDate!);
          },
          currentTime: DateTime(2000, 1, 1),
        );
      },
    );
  }
}

class PhoneNumberField extends CustomTextFormField {
  PhoneNumberField({Key? key})
      : super(
          key: key,
          labelText: "전화번호",
          validator: validatePhoneNumber,
          maxLength: 11,
          autofillHints: [AutofillHints.telephoneNumber],
          keyboardType: TextInputType.phone,
        );
}

ElevatedButton signUpButton({
  required BuildContext context,
  required GlobalKey<FormState> formKey,
  required IDField id,
  required PWField pw,
  required NameField nameField,
  required BirthdayField birthdayField,
  required PhoneNumberField phoneNumberField,
  File? profileImg,
  String? profileMsg,
}) {
  return submitButton(
    onPressed: () async {
      if (!formKey.currentState!.validate()) return null;
      formKey.currentState!.save();
      return await handleSignUp(
        id: id.value!,
        pw: pw.value!,
        name: nameField.value!,
        birthday: birthdayField.value!,
        phoneNumber: phoneNumberField.value!,
        profile: {
          'image': profileImg,
          'message': profileMsg,
        },
      );
    },
    text: '회원가입',
    onSuccess: () {
      const snackBar = SnackBar(
        content: Text('회원가입이 완료되었습니다.'),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      Navigator.pop(context);
    },
    onFailure: () {
      const snackBar = SnackBar(
        content: Text('회원가입에 실패하였습니다.'),
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
