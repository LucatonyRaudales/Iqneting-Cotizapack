import 'package:cotizapack/pages/quotation/quotations/quotations_ctrl.dart';
import 'package:get/get.dart';

class QuotationsBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<QuotationsCtrl>(() => QuotationsCtrl());
  }
}
