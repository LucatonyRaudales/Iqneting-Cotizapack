import 'package:cotizapack/pages/shop_market/creditcard_pakage/creditcard_ctrl.dart';
import 'package:get/get.dart';

class CreeditCardBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CreditcardController>(() => CreditcardController());
  }
}
