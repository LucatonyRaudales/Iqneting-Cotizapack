import 'dart:io';

import 'package:appwrite/appwrite.dart';
import 'package:cotizapack/settings/appwrite.dart';
import 'package:flutter/material.dart';

class MyStorage extends ChangeNotifier{
    Client client = Client();
  late Storage storage;

  AuthState(){
    _init();
  }

  _init(){
    client
    .setEndpoint(AppwriteSettings.endPoint)
    .setProject(AppwriteSettings.projectID);
    storage = Storage(client);
  }
  
  Future<Response?> postFile({required File file})async{
    Response result;
    try {
      result = await storage.createFile(
    file: await MultipartFile.fromFile(
      file.path, 
      filename: file.path.split("/").last),
    read: ["*"],
    write: ["user:fndjk54453"],
  );
  return result;
    } catch (e) {
      print('Error storage: $e');
    } 
  }
}