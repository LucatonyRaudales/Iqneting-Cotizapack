import 'package:cotizapack/pages/dashboard/dashboard_ctrl.dart';
import 'package:get/get.dart';

class DashboardBinding implements Bindings {
  @override
  void dependencies() {
    Get.put<DashboardCtrl>(DashboardCtrl());
  }
}
