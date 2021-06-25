import 'dart:math';
import 'package:flutter/material.dart';
import '../styles/colors.dart';

class MyCard extends StatelessWidget {
  final Widget content;
  final Widget leading;
  final void Function()? function;
  MyCard(
      {Key? key, required this.content, required this.leading, this.function});

  final Random random = new Random();
  final List colors = [
    [Colors.blue.shade400, Colors.blue.shade200],
    [Colors.pink.shade400, Colors.pink.shade200],
    [Colors.green.shade400, Colors.green.shade200],
    [color200, color100],
    [Colors.red.shade400, Colors.red.shade200],
    [Colors.purple.shade400, Colors.purple.shade200],
    [Colors.orange.shade400, Colors.orange.shade200],
  ];

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: function,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          gradient: LinearGradient(
            colors: colors[random.nextInt(colors.length)],
          ),
          // gradient: LinearGradient(colors: [color200, color100]),
        ),
        width: double.infinity,
        height: 100,
        margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
                width: 50,
                height: 50,
                margin: EdgeInsets.only(right: 15),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  border: Border.all(width: 3, color: Colors.white),
                ),
                child: leading),
            Expanded(
              child: content,
            )
          ],
        ),
      ),
    );
  }
}
