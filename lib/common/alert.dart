import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../styles/typography.dart';

class MyAlert {

  static showMyDialog({required String title, required String message, required Color color}){
    return Get.snackbar(
    '',
    '',
    snackPosition: SnackPosition.TOP,
    titleText: new Text(title, style: subtituloblanco,),
    messageText: new Text(message, style: body1blanco,),
    backgroundColor: color
    );
  }
}