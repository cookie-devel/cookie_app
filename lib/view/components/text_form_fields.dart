import 'package:cookie_app/view/components/auth/validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:intl/intl.dart';

class IDField extends TextFormField {
  IDField({Key? key, required onSaved})
      : super(
          key: key,
          decoration: const InputDecoration(
            labelText: "아이디",
          ),
          validator: validateID,
          autofillHints: [AutofillHints.username],
          onSaved: onSaved,
        );
}

class PWField extends TextFormField {
  PWField({Key? key, required onSaved})
      : super(
          key: key,
          obscureText: true,
          decoration: const InputDecoration(
            labelText: "비밀번호",
          ),
          validator: validatePW,
          autofillHints: [AutofillHints.password],
          onSaved: onSaved,
        );
}

class NewIDField extends TextFormField {
  NewIDField({Key? key, required onSaved})
      : super(
          key: key,
          decoration: const InputDecoration(
            labelText: "아이디",
          ),
          validator: validateID,
          autofillHints: [AutofillHints.newUsername],
          onSaved: onSaved,
        );
}

class NewPWField extends TextFormField {
  NewPWField({Key? key, required controller, required onSaved})
      : super(
          key: key,
          controller: controller,
          obscureText: true,
          decoration: const InputDecoration(
            labelText: "비밀번호",
          ),
          validator: validatePW,
          autofillHints: [AutofillHints.newPassword],
          onSaved: onSaved,
        );
}

class NewPWConfirmField extends TextFormField {
  NewPWConfirmField({Key? key, required TextEditingController pwController})
      : super(
          key: key,
          obscureText: true,
          decoration: const InputDecoration(
            labelText: "비밀번호 확인",
          ),
          validator: (value) => validatePWConfirm(pwController.text, value),
          autofillHints: [AutofillHints.newPassword],
        );
}

class NameField extends TextFormField {
  NameField({Key? key, required onSaved})
      : super(
          key: key,
          decoration: const InputDecoration(
            labelText: "이름",
          ),
          validator: validateName,
          autofillHints: [AutofillHints.name],
          onSaved: onSaved,
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
  PhoneNumberField({Key? key, required onSaved})
      : super(
          key: key,
          decoration: const InputDecoration(
            labelText: "휴대폰 번호",
          ),
          validator: validatePhoneNumber,
          maxLength: 11,
          autofillHints: [AutofillHints.telephoneNumber],
          onSaved: onSaved,
        );
}
