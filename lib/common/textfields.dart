import 'package:animate_do/animate_do.dart';
import 'package:cotizapack/styles/colors.dart';
import 'package:cotizapack/styles/typography.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class InputText extends GetView {
  final TextEditingController? controller;
  final String name;
  final Widget prefixIcon;
  final Widget? suffixIcon;
  final String? Function(String?)? validator;
  final Iterable<String>? autofillHints;
  final void Function(String) onChanged;
  final bool? obscureText;
  final TextInputType textInputType;
  final int? maxLines;
  final String? initialValue;
  final int? minLines;
  final bool readOnly;
  final void Function()? onEditingComplete;
  InputText(
      {Key? key,
      required this.name,
      required this.prefixIcon,
      required this.onChanged,
      required this.textInputType,
      this.obscureText,
      this.controller,
      this.readOnly = false,
      this.suffixIcon,
      this.validator,
      this.autofillHints,
      this.maxLines,
      this.initialValue,
      this.onEditingComplete,
      this.minLines});
  @override
  Widget build(BuildContext context) {
    return FadeInLeft(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            if (validator.toString().length == 0)
              BoxShadow(
                spreadRadius: -2,
                color: Colors.black.withOpacity(0.2),
                blurRadius: 8,
                offset: const Offset(0, -5),
              ),
            BoxShadow(
              spreadRadius: -2,
              color: Colors.black.withOpacity(0.2),
              blurRadius: 8,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: TextFormField(
          controller: controller,
          readOnly: readOnly,
          onEditingComplete: onEditingComplete,
          minLines: minLines,
          initialValue: initialValue,
          keyboardType: textInputType,
          maxLines: maxLines,
          obscureText: obscureText ?? false,
          validator: validator,
          autofillHints: autofillHints,
          onChanged: onChanged,
          style: TextStyle(color: azulObscuro),
          cursorColor: Colors.deepOrange,
          decoration: InputDecoration(
              filled: true,
              fillColor: Color(0xffFAFAFA),
              hintText: name,
              hintStyle: body1,
              suffixIcon: suffixIcon,
              prefixIcon: Material(
                elevation: 0,
                borderRadius: BorderRadius.circular(30),
                child: prefixIcon,
              ),
              border: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: const BorderRadius.all(
                  const Radius.circular(30),
                ),
              ),
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 25, vertical: 13)),
        ),
      ),
    );
  }
}
