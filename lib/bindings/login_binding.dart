import 'package:cotizapack/pages/login/login_ctrl.dart';
import 'package:get/get.dart';

class LoginBinding implements Bindings {
@override
void dependencies() {
  Get.lazyPut<LoginCtrl>(() => LoginCtrl());
  }
}