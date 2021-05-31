import 'package:cotizapack/model/categories.dart';
import 'package:cotizapack/model/session_model.dart';
import 'package:cotizapack/model/user_data.dart';
import 'package:cotizapack/repository/user.dart';
import 'package:get_storage/get_storage.dart';

class MyGetStorage {
  final box = GetStorage();

  Future<void> saveData({required String key, required var data}) async {
    print('saved');
    return box.write(key, data);
  }

  Map<String, dynamic>? readData({required String key}) {
    print('reading key: $key');
    return box.read(key);
  }

  bool haveData({required String key}) {
    box.erase();
    print(box.read(key));
    return box.hasData(key);
  }

  Future eraseData() {
    return box.erase();
  }

  Future replaceData({required String key, required var data}) async {
    try {
      await box.remove(key);
      return box.write(key, data);
    } catch (e) {
      print('Error replaceData $e');
    }
  }

  Future<UserData?> listenUserData() async {
    Session _mySession = Session();
    UserData _userData = UserData(
        category: UserCategory(
            id: '', collection: '', enable: false, name: '', description: ''));
    try {
      if (box.hasData('userData')) {
        _userData = UserData.fromJson(box.read("userData"));
        print('local db has user data: ${_userData.ceoName}');
        return _userData;
      } else {
        var resultSession = await UserRepository().getSessions();
        _mySession = Session.fromJson(resultSession!.data);

        _userData =
            await UserRepository().chargeUserData(userID: _mySession.userId!);
        return _userData;
      }
    } catch (err) {
      print('Error listen User: $err');
    }
  }
}
