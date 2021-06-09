import 'dart:async';

import 'package:cotizapack/model/session_model.dart';
import 'package:cotizapack/model/user_data.dart';
import 'package:cotizapack/pages/edit_my_data/edit_my_data_page.dart';
import 'package:cotizapack/repository/user.dart';
import 'package:cotizapack/routes/app_pages.dart';
import 'package:cotizapack/settings/get_storage.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

class SplashCtrl extends GetxController {
  UserRepository _userRepository = UserRepository();
  Session _session = Session();
  // AccountRepository _accountRepository = AccountRepository();

  @override
  void onInit() {
    islogin();
    super.onInit();
  }

  void islogin() async {
    try {
      var response = await _userRepository.getSessions();
      if (response != null) {
        if (response.statusCode == 200) {
          _session = Session.fromJson(response.data);
          bool checked = (await checkuserData(session: _session))!;
          Timer(
              Duration(seconds: 1),
              () => Get.offNamed(
                    checked ? Routes.HOME : Routes.LOGIN,
                  ));
        }
      }
    } catch (e) {
      print('Error splash: $e');
      Timer(Duration(seconds: 2), () => Get.offNamed(Routes.LOGIN));
    }
  }

  Future<bool?> checkuserData({required Session session}) async {
    try {
      if (MyGetStorage().haveData(key: 'userData')) {
        return true;
      } else {
        UserData value =
            await _userRepository.chargeUserData(userID: session.userId!);
        if (value.userID == null) {
          return Get.off(EditMyDataPage(),
              transition: Transition.rightToLeftWithFade,
              arguments: {"editData": false, "data": null});
        }
        MyGetStorage().saveData(key: 'userData', data: value.toJson());
        print('Awevo, se guardaron los datos bien');
        return true;
      }
    } catch (e) {
      print('Error: $e');
      return false;
    }
  }
}
