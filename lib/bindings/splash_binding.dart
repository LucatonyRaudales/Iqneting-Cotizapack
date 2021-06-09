import 'package:cotizapack/pages/splash/splash_ctrl.dart';
import 'package:get/get.dart';

class SplashBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SplashCtrl>(() => SplashCtrl());
  }
}
