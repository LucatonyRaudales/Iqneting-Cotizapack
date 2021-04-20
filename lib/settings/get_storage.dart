import 'package:get_storage/get_storage.dart';

class MyGetStorage{
  final box = GetStorage();

  Future<void> saveData({required String key, required var data})async{
    box.write(key, data);
    print('saved');
    return null;
  }

  Future<dynamic> readData({required String key})async{
    print('reading key: $key');
    return box.read(key);
  }
  bool haveData({required String key}){
    return box.hasData(key);
  }

  Future reaseData(){
    return box.erase();
  }
}