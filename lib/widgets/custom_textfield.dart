import 'package:flutter/material.dart';

import '/theme/app_theme.dart';

class CustomTextField extends StatelessWidget {
  final Function(String) onChanged;
  final String? Function(String?)? validator;
  final IconData? prefixIcon;
  final String labelText;
  final TextInputType textInputType;
  final bool isPassowrdField;
  final Widget? suffixIcon;
  final String? intialValue;
  final int? maxLines;
  final int? maxLength;
  final int? minLines;

  const CustomTextField({
    super.key,
    required this.onChanged,
    this.isPassowrdField = false,
    this.suffixIcon,
    required this.validator,
    this.prefixIcon,
    required this.labelText,
    required this.textInputType,
    this.intialValue,
    this.maxLines,
    this.maxLength,
    this.minLines,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      style: TextStyle(
        fontSize: 14.0,
        color: AppTheme.color.titleColor,
        fontWeight: FontWeight.bold,
      ),
      initialValue: intialValue,
      maxLines: maxLines,
      minLines: minLines,
      maxLength: maxLength,
      onChanged: onChanged,
      validator: validator,
      obscureText: isPassowrdField,
      keyboardType: textInputType,
      decoration: InputDecoration(
        suffixIcon: suffixIcon,
        prefixIcon:
            prefixIcon != null ? Icon(prefixIcon, color: Colors.black26) : null,
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.black12),
          borderRadius: BorderRadius.circular(8.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppTheme.color.mainColor),
          borderRadius: BorderRadius.circular(8.0),
        ),

        // contentPadding: const EdgeInsets.only(
        //   left: 10.0,
        //   right: 10.0,
        // ),
        labelText: labelText,
        // hintStyle: TextStyle(
        //   fontSize: 14.0,
        //   color: AppTheme.color.grey,
        //   fontWeight: FontWeight.w500,
        // ),
        // labelStyle: const TextStyle(
        //   fontSize: 12.0,
        //   color: Colors.grey,
        //   fontWeight: FontWeight.w500,
        // ),
      ),
      // autocorrect: false,
    );
  }
}
