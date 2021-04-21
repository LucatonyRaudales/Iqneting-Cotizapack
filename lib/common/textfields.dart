import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';

class InputText extends StatefulWidget {
  final  String name;
  final Widget prefixIcon;
  final String? Function(String?)? validator;
  final Iterable<String>? autofillHints;
  final void Function(String) onChanged;
  final bool? obscureText;
  final TextInputType textInputType;
  final int? maxLines;
  final String? initialValue;
  InputText({
    Key? key,
    required this.name,
    required this.prefixIcon,
    required this.onChanged,
    required this.textInputType,
    this.obscureText,
    this.validator,
    this.autofillHints,
    this.maxLines,
    this.initialValue
    });
  
  @override
  _InputTextState createState() => _InputTextState();
}

class _InputTextState extends State<InputText> {

  @override
  Widget build(BuildContext context) {
    return FadeInLeft(
      child: Material(
        elevation: 2.0,
        borderRadius: BorderRadius.all(Radius.circular(30)),
        child: TextFormField(
          initialValue: widget.initialValue,
          keyboardType: widget.textInputType,
          maxLines:  widget.maxLines,
          obscureText: widget.obscureText ?? false,
          validator: widget.validator,
          autofillHints: widget.autofillHints,
          onChanged:widget.onChanged,
          cursorColor: Colors.deepOrange,
          decoration: InputDecoration(
            hintText: widget.name,
            prefixIcon: Material(
              elevation: 0,
              borderRadius: BorderRadius.all(Radius.circular(30)),
              child: widget.prefixIcon,
            ),
            border: InputBorder.none,
            contentPadding:
              EdgeInsets.symmetric(horizontal: 25, vertical: 13)),
        ),
      )
    );
  }
}