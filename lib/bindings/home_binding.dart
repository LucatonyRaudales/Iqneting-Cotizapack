import 'package:cotizapack/pages/categories/categories_ctrl.dart';
import 'package:cotizapack/pages/home/home_controller.dart';
import 'package:cotizapack/pages/profile/profile_ctrl.dart';
import 'package:get/get.dart';

class HomeBinding implements Bindings {
  @override
  void dependencies() {
    Get.put<HomeController>(HomeController());
    Get.put<CategoriesCtrl>(CategoriesCtrl());
    Get.put<ProfileCtrl>(ProfileCtrl());
  }
}
