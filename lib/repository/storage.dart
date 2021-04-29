import 'dart:io';
import 'package:appwrite/appwrite.dart';
import 'package:cotizapack/settings/appwrite.dart';
import 'package:uuid/uuid.dart';

class MyStorage{
    Client client = Client();
  late Storage storage;
  var uuid = Uuid();
  
  Future<Response?> postFile({required File file})async{
    try {
      storage = Storage(AppwriteSettings.initAppwrite());
    Response result = await storage.createFile(
      file: await MultipartFile.fromFile(
        file.path, 
        filename:file.path.split("/").last),
      read: ["*"],
      write: ["*"],
    );
    
    /*if(result.statusCode == 201){
      String id = result.data['\$id'];
      final url = await storage.getFilePreview(fileId: id);
      print('la url de la imagen es: $url');
    }*/
    return result;
    } catch (e) {
      print('Error storage: $e.message');
      return null;
    } 
  }

  Future<Response?> deleteFile({required String fileId})async{
    try{
      storage = Storage(AppwriteSettings.initAppwrite());
      Response res = await storage.deleteFile(fileId: fileId);
      print('Error update Storage');
      return res;
    }catch(e){
      print('Error delete File: $e');
      return null;
    }
  }

  Future<Response?> getFilePreview({required String fileId})async{
    try{
      storage = Storage(AppwriteSettings.initAppwrite());
      Response res = await storage.getFilePreview(fileId: fileId);
      print('Error update Storage');
      return res;
    }catch(e){
      print('Error delete File: $e');
      return null;
    }
  }
}