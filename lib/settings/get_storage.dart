import 'package:cotizapack/model/user_data.dart';
import 'package:get_storage/get_storage.dart';

class MyGetStorage{
  final box = GetStorage();

  Future<void> saveData({required String key, required var data})async{
    print('saved');
    return box.write(key, data);
  }

  Future<dynamic> readData({required String key})async{
    print('reading key: $key');
    return box.read(key);
  }
  bool haveData({required String key}){
    box.erase();
    return box.hasData(key);
  }

  Future eraseData(){
    return box.erase();
  }
  
  replaceData({required String key, required var data}){
    try{
      box.remove(key);
      return box.write(key, data);
    }catch(e){
      print('Error replaceData $e');
    }
  }

  UserData? listenUserData(){
    try{
      return box.read("userData");
    }catch(err){
      print('Error listen User: $err');
    }
  }
}