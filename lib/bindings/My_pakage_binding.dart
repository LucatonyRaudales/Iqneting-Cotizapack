import 'package:cotizapack/pages/shop_market/My_pakage_page/My_pakage_control.dart';
import 'package:get/get.dart';

class MyPakageBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ListPakageController>(() => ListPakageController());
  }
}
