import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

import '../styles/colors.dart';
import '../styles/typography.dart';

class Button extends StatelessWidget {
  final  String name;
  final void Function() function;
  final RoundedLoadingButtonController btnController;
  Button({
    Key? key,
    required this.name,
    required this.btnController,
    required this.function
    });

  @override
  Widget build(BuildContext context) {
    return FadeInLeft(
      child:  RoundedLoadingButton(
        successColor: Colors.green,
        errorColor: Colors.red,
        color: color500,
        child: Text(name, style:subtituloblanco),
        controller: btnController,
        onPressed: function,
      )
    ); 
  }
}