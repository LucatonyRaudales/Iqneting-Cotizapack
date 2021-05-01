import 'package:cotizapack/styles/colors.dart';
import 'package:cotizapack/styles/typography.dart';
import 'package:flutter/material.dart';

class MyStaticButton extends StatelessWidget {
  final Function() function;
  final String text;
  MyStaticButton({
    required this.function,
    required this.text
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
            onTap: function,
              child: Padding(padding: EdgeInsets.symmetric(horizontal: 20,vertical: 20),
            child: Container(
              height: 45,
              width: double.infinity / 1.8,
              decoration: BoxDecoration(
                color: color500,
                borderRadius: BorderRadius.circular(30)
              ),
              child: Center(
                child: Text(text,style: subtituloblanco,),
              ),
            ),),
          );
  }
}