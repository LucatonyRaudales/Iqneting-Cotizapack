import 'package:animate_do/animate_do.dart';
import 'package:cotizapack/styles/typography.dart';
import 'package:flutter/material.dart';

class InputText extends StatefulWidget {
  final String name;
  final Widget prefixIcon;
  final String? Function(String?)? validator;
  final Iterable<String>? autofillHints;
  final void Function(String) onChanged;
  final bool? obscureText;
  final TextInputType textInputType;
  final int? maxLines;
  final String? initialValue;
  final int? minLines;
  InputText(
      {Key? key,
      required this.name,
      required this.prefixIcon,
      required this.onChanged,
      required this.textInputType,
      this.obscureText,
      this.validator,
      this.autofillHints,
      this.maxLines,
      this.initialValue,
      this.minLines});

  @override
  _InputTextState createState() => _InputTextState();
}

class _InputTextState extends State<InputText> {
  @override
  Widget build(BuildContext context) {
    return FadeInLeft(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            if (widget.validator.toString().length == 0)
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
          minLines: widget.minLines,
          initialValue: widget.initialValue,
          keyboardType: widget.textInputType,
          maxLines: widget.maxLines,
          obscureText: widget.obscureText ?? false,
          validator: widget.validator,
          autofillHints: widget.autofillHints,
          onChanged: widget.onChanged,
          cursorColor: Colors.deepOrange,
          decoration: InputDecoration(
              filled: true,
              fillColor: Color(0xffFAFAFA),
              hintText: widget.name,
              hintStyle: body1,
              prefixIcon: Material(
                elevation: 0,
                borderRadius: BorderRadius.circular(30),
                child: widget.prefixIcon,
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
