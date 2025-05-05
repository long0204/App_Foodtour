import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../config/themes/theme.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    super.key,
    this.controller,
    this.hintText = '',
    this.hintColor = grey600,
    this.enabledBorderColor = grey300,
    this.enabled = true,
    this.suffixIcon,
    this.prefixIcon,
    this.keyboardType = TextInputType.text,
    this.onChanged,
    this.textInputAction,
    this.onSubmitted,
    this.fillColor = Colors.white,
    this.width = double.maxFinite,
    this.autofocus = false,
    this.error = false,
    this.obscureText = false,
    this.onEditingComplete,
    this.onTap,
    this.focusNode,
    this.contentPadding = const EdgeInsets.all(12),
    this.textAlign = TextAlign.start,
    this.inputFormatters,
    this.suffixIconConstraints = 55,
    this.autofillHints,
  });
  final TextEditingController? controller;
  final String hintText;
  final TextInputType keyboardType;
  final Color enabledBorderColor;
  final Color hintColor;
  final Color fillColor;
  final bool enabled;
  final Widget? suffixIcon;
  final Widget? prefixIcon;

  final Function(String value)? onChanged;
  final TextInputAction? textInputAction;
  final Function(String)? onSubmitted;
  final double width;
  final bool autofocus;
  final bool error;
  final bool obscureText;
  final Function()? onEditingComplete;
  final Function()? onTap;
  final TextAlign textAlign;
  final FocusNode? focusNode;
  final EdgeInsetsGeometry contentPadding;
  final List<TextInputFormatter>? inputFormatters;
  final double suffixIconConstraints;
  final Iterable<String>? autofillHints;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 44.w,
      width: width,
      child: TextField(
        textAlign: textAlign,
        obscureText: obscureText,
        controller: controller,
        enabled: enabled,
        keyboardType: keyboardType,
        onChanged: onChanged,
        textInputAction: textInputAction,
        onSubmitted: onSubmitted,
        onEditingComplete: onEditingComplete,
        onTap: onTap,
        focusNode: focusNode,
        autofocus: autofocus,
        inputFormatters: inputFormatters,
        autofillHints: autofillHints,
        decoration: InputDecoration(
          hintText: ' $hintText',
          filled: true,
          fillColor: fillColor,
          isDense: false,
          contentPadding: contentPadding,
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(40),
            borderSide: const BorderSide(color: grey300),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(40),
            borderSide: const BorderSide(color: primary),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(40),
            borderSide: BorderSide(
                color: error ? red400 : enabledBorderColor, width: 1),
          ),
          suffixIcon: suffixIcon,
          prefixIcon: prefixIcon,
          prefixIconConstraints: const BoxConstraints(maxWidth: 55),
          suffixIconConstraints:
              BoxConstraints(maxWidth: suffixIconConstraints),
        ),
      ),
    );
  }
}

class CustomTextFormField extends StatelessWidget {
  const CustomTextFormField({
    required this.validator,
    super.key,
    this.controller,
    this.hintText = '',
    this.enabled = true,
    this.suffixIcon,
    this.keyboardType = TextInputType.text,
    this.onChanged,
    this.textInputAction,
    this.onFieldSubmitted,
    this.fillColor = Colors.white,
    this.width = double.maxFinite,
    this.autofocus = false,
    this.obscureText = false,
    this.onEditingComplete,
    this.focusNode,
    this.height = 68,
    this.errorText,
    this.maxLines = 1,
    this.enableSuggestions = true,
    this.onTap,
    this.inputFormatters,
    this.autofillHints,
    this.autocorrect = true,
    this.labelText,
  });
  final TextEditingController? controller;
  final String hintText;
  final String? labelText;
  final TextInputType keyboardType;
  final Color fillColor;
  final bool enabled;
  final Widget? suffixIcon;
  final Function(String value)? onChanged;
  final TextInputAction? textInputAction;
  final Function(String)? onFieldSubmitted;
  final Function()? onTap;

  final double width;
  final bool autofocus;
  final bool obscureText;
  final Function()? onEditingComplete;
  final FocusNode? focusNode;
  final String? Function(String?) validator;
  final double height;
  final String? errorText;
  final int maxLines;
  final bool enableSuggestions;
  final List<TextInputFormatter>? inputFormatters;
  final Iterable<String>? autofillHints;
  final bool autocorrect;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height.w,
      width: width,
      child: TextFormField(
        cursorHeight: 16.w,
        obscureText: obscureText,
        controller: controller,
        enabled: enabled,
        keyboardType: keyboardType,
        onChanged: onChanged,
        textInputAction: textInputAction,
        onFieldSubmitted: onFieldSubmitted,
        onEditingComplete: onEditingComplete,
        onTap: onTap,
        focusNode: focusNode,
        autofocus: autofocus,
        validator: validator,
        maxLines: maxLines,
        enableSuggestions: enableSuggestions,
        inputFormatters: inputFormatters,
        autofillHints: autofillHints,
        autocorrect: autocorrect,
        decoration: InputDecoration(
          labelText: labelText,
          errorText: errorText,
          hintText: ' $hintText',
          filled: true,
          fillColor: fillColor,
          contentPadding: EdgeInsets.all(12.w),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(0),
            borderSide: const BorderSide(color: grey300),
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(40),
            borderSide: const BorderSide(color: grey300),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(40),
            borderSide: const BorderSide(color: primary),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(40),
            borderSide: const BorderSide(color: grey300),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(40),
            borderSide: const BorderSide(color: red400),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(40),
            borderSide: const BorderSide(color: red400),
          ),
          suffixIcon: suffixIcon,
          suffixIconConstraints: const BoxConstraints(maxWidth: 55),
        ),
      ),
    );
  }
}

class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    return TextEditingValue(
      text: newValue.text.toUpperCase(),
      selection: newValue.selection,
    );
  }
}
