import 'dart:io';

import 'package:appwrite/appwrite.dart';
import 'package:cotizapack/settings/appwrite.dart';

class MyStorage{
    Client client = Client();
  late Storage storage;

  
  Future<Response?> postFile({required File file})async{
    try {
      storage = Storage(AppwriteSettings.initAppwrite());
    Response result = await storage.createFile(
      file: await MultipartFile.fromFile(
        file.path, 
        filename: file.path.split("/").last),
      read: ["*"],
      write: ["*"],
    );
    return result;
    } catch (e) {
      print('Error storage: $e.message');
      return null;
    } 
  }
}