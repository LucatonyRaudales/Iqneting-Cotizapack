import 'package:cotizapack/model/session_model.dart';
import 'package:cotizapack/repository/user.dart';
import 'package:cotizapack/settings/get_storage.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import '../splash/splash_screen.dart';

class ProfileCtrl extends GetxController{
    UserRepository _userRepository = UserRepository();
  Session _session = Session();

  @override
  void onInit() {
    print('page profile');
    super.onInit();
  }

  void logout(){
    try {
      _userRepository.getSessions()
      .then((value){
        //_session = Session.fromJson(value!.data);
          _userRepository.logout()
          .then((value) async {
            await MyGetStorage().reaseData();
            Get.off(SplashPage(), transition: Transition.cupertino);
          });
      });
    } catch (e) {
    }
  }

  
}