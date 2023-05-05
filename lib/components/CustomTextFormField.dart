import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextFormField extends StatelessWidget {
  CustomTextFormField({
    Key? key,
    this.obscureText = false,
    this.labelText = "",
    this.validator,
    this.autofillHints,
    this.keyboardType,
    this.maxLength,
    this.inputFormatters,
  }) : super(key: key);

  final bool obscureText;
  final String labelText;
  final TextEditingController controller = TextEditingController();
  int? maxLength;
  TextInputType? keyboardType;
  String? Function(String?)? validator;
  Iterable<String>? autofillHints;
  String? value;
  List<TextInputFormatter>? inputFormatters;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      onSaved: (newValue) {
        value = newValue;
      },
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(90.0),
        ),
        labelText: labelText,
      ),
      validator: validator,
      obscureText: obscureText,
      maxLength: maxLength,
      autofillHints: autofillHints,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
    );
  }
}
