import 'package:cotizapack/styles/colors.dart';
import 'package:flutter/material.dart';

class MyBottomSheet{
  void show(BuildContext ctx, double height, Widget content) {
      showModalBottomSheet(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(topLeft: Radius.circular(35.0)),
        ),
        backgroundColor: Colors.transparent,
        isScrollControlled: true,
        context: ctx,
        builder: (context) {
          return Container(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            height: height,
              child:content,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(25),
                  topRight: const Radius.circular(25),
                ),
              ),
          );
        });
  }
}