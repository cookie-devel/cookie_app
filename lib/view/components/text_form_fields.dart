import 'package:flutter/material.dart';

import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:intl/intl.dart';

import 'package:cookie_app/view/components/auth/validator.dart';

class IDField extends TextFormField {
  IDField({super.key, super.onSaved})
      : super(
          decoration: const InputDecoration(
            labelText: "아이디",
          ),
          validator: validateID,
          autofillHints: [AutofillHints.username],
        );
}

class PWField extends TextFormField {
  PWField({super.key, super.onSaved})
      : super(
          obscureText: true,
          decoration: const InputDecoration(
            labelText: "비밀번호",
          ),
          validator: validatePW,
          autofillHints: [AutofillHints.password],
        );
}

class NewIDField extends TextFormField {
  NewIDField({super.key, super.onSaved})
      : super(
          decoration: const InputDecoration(
            labelText: "아이디",
          ),
          validator: validateID,
          autofillHints: [AutofillHints.newUsername],
        );
}

class NewPWField extends TextFormField {
  NewPWField({super.key, required controller, super.onSaved})
      : super(
          controller: controller,
          obscureText: true,
          decoration: const InputDecoration(
            labelText: "비밀번호",
          ),
          validator: validatePW,
          autofillHints: [AutofillHints.newPassword],
        );
}

class NewPWConfirmField extends TextFormField {
  NewPWConfirmField({super.key, required TextEditingController pwController})
      : super(
          obscureText: true,
          decoration: const InputDecoration(
            labelText: "비밀번호 확인",
          ),
          validator: (value) => validatePWConfirm(pwController.text, value),
          autofillHints: [AutofillHints.newPassword],
        );
}

class NameField extends TextFormField {
  NameField({super.key, super.onSaved})
      : super(
          decoration: const InputDecoration(
            labelText: "이름",
          ),
          validator: validateName,
          autofillHints: [AutofillHints.name],
        );
}

class BirthdayField extends StatelessWidget {
  final TextEditingController _controller = TextEditingController();
  final dynamic Function(dynamic)? onSaved;

  BirthdayField({super.key, required this.onSaved});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: _controller,
      readOnly: false,
      obscureText: false,
      decoration: const InputDecoration(
        // border: OutlineInputBorder(
        //   borderRadius: BorderRadius.circular(90.0),
        // ),
        labelText: '생년월일',
        suffixIcon: Icon(Icons.calendar_today),
      ),
      validator: validateBirthday,
      onSaved: onSaved,
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
        DatePicker.showDatePicker(
          context,
          showTitleActions: true,
          locale: LocaleType.ko,
          minTime: DateTime(1900, 1, 1),
          maxTime: DateTime.now(),
          onConfirm: (DateTime date) {
            _controller.text = DateFormat('yyyy-MM-dd').format(date);
          },
        );
      },
    );
  }
}

class PhoneNumberField extends TextFormField {
  PhoneNumberField({super.key, super.onSaved})
      : super(
          decoration: const InputDecoration(
            labelText: "휴대폰 번호",
          ),
          validator: validatePhoneNumber,
          maxLength: 11,
          autofillHints: [AutofillHints.telephoneNumber],
        );
}
