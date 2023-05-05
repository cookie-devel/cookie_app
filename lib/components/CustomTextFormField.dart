import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  CustomTextFormField({
    Key? key,
    this.obscureText = false,
    this.labelText = "",
    this.validator,
    this.autofillHints,
    this.keyboardType,
    this.maxLength,
  }) : super(key: key);

  final bool obscureText;
  final String labelText;
  final TextEditingController _controller = TextEditingController();
  int? maxLength;
  TextInputType? keyboardType;
  String? Function(String?)? validator;
  Iterable<String>? autofillHints;
  String? value;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: validator,
      controller: _controller,
      obscureText: obscureText,
      onSaved: (newValue) {
        value = newValue;
      },
      maxLength: 30,
      autofillHints: autofillHints,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(90.0),
        ),
        labelText: labelText,
      ),
    );
  }
}
