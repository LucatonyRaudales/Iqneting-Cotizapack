import 'package:cotizapack/model/categories.dart';
import 'package:cotizapack/model/statistic.dart';
import 'package:cotizapack/model/user_data.dart';
import 'package:cotizapack/repository/statistics.dart';
import 'package:cotizapack/settings/get_storage.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

class DashboardCtrl extends GetxController with StateMixin<Rx<Statistic?>> {
  StatisticsRepository statisticsRepository = StatisticsRepository();
  Rx<Statistic?> statistic = Statistic().obs;
  UserCategory userCategory = UserCategory(
    collection: "",
    enable: true,
    name: "",
    description: "",
    id: "",
  );
  late Rx<UserData> userData = UserData(
          ceoName: "",
          nickname: "",
          businessName: "",
          logo: "",
          paymentUrl: "",
          userID: "",
          category: userCategory)
      .obs;
  @override
  void onInit() {
    change(null, status: RxStatus.empty());
    print('Welcome to dashboard page');
    getUserData();
    super.onInit();
  }

  @override
  void onReady() async {
    userData.value = (await MyGetStorage().listenUserData());
    super.onReady();
  }

  void getUserData() async {
    change(null, status: RxStatus.loading());
    try {
      userData.value = (await MyGetStorage().listenUserData(actualizar: true));
      print('User name: ${userData.value.businessName}');
      userData.refresh();
      getmystatistics();
    } catch (e) {
      print('Error get UserData: $e');
    }
  }

  void getmystatistics() {
    change(null, status: RxStatus.loading());
    if (MyGetStorage().haveData(key: 'statistic')) {
      statistic.value =
          Statistic.fromJson(MyGetStorage().readData(key: 'statistic')!);
      change(statistic, status: RxStatus.success());
    } else {
      refreshStatistics();
    }
  }

  void refreshStatistics() async {
    change(null, status: RxStatus.loading());
    statisticsRepository.getMyStatistics().then((value) async {
      userData.value = (await MyGetStorage().listenUserData());
      change(value.obs, status: RxStatus.success());
      update();
    });
  }
}
