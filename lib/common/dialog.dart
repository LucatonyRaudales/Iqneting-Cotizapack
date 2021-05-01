import 'package:cotizapack/styles/typography.dart';
import 'package:flutter/material.dart';

class MyDialog{
  void show({required BuildContext context, required String title, required Widget content, List<Widget>? actions}){
    showDialog(
        context: context,
    builder: (_) => new AlertDialog(
          title: new Text(title, style: subtitulo, textAlign: TextAlign.center,),
          //shape: CircleBorder(BorderSide.circular(25)),
          content: content,
          actions: actions
        ));
  }
}