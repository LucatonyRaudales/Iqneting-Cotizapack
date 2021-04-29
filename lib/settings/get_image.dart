import 'dart:io';

import 'package:cotizapack/styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class GetImage{
  final picker = ImagePicker();
  
    Future<File?> _cropImage({required String sourcePath}) async {
    File? croppedFile = await ImageCropper.cropImage(
        sourcePath: sourcePath,
        compressFormat: ImageCompressFormat.png,
        compressQuality: 100,
        aspectRatioPresets: [
                CropAspectRatioPreset.square,
                CropAspectRatioPreset.ratio4x3,
                CropAspectRatioPreset.ratio3x2,
              ],
        androidUiSettings: AndroidUiSettings(
            toolbarTitle: 'Editar imagen',
            toolbarColor: color700,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        iosUiSettings: IOSUiSettings(
          title: 'Editar imagen',
        ));
    if (croppedFile != null) {
      return croppedFile;
    }
  }

  Future<File?> getImage({required ImageSource source}) async {
    File? imagen;
    final pickedFile = await picker.getImage(source: source);

      if (pickedFile != null) {
        imagen = (await _cropImage(sourcePath: pickedFile.path))!;
      }
      return imagen;
  }
}