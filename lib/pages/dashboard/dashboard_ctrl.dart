import 'package:cotizapack/model/categories.dart';
import 'package:cotizapack/model/statistic.dart';
import 'package:cotizapack/model/user_data.dart';
import 'package:cotizapack/repository/statistics.dart';
import 'package:cotizapack/settings/get_storage.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

class DashboardCtrl extends GetxController {
  StatisticsRepository statisticsRepository = StatisticsRepository();
  Statistic statistic = Statistic();
  UserCategory userCategory = UserCategory(
    collection: "fds",
    enable: true,
    name: "",
    description: "",
    id: "",
  );
  late UserData userData = UserData(
      ceoName: "",
      nickname: "",
      businessName: "",
      logo: "",
      paymentUrl: "",
      userID: "",
      category: userCategory);
  @override
  void onInit() {
    print('Welcome to dashboard page');

    super.onInit();
  }

  @override
  void onReady() {
    getUserData();
    super.onReady();
  }

  void getUserData() async {
    try {
      userData = (await MyGetStorage().listenUserData())!;
      print('User name: ${userData.businessName}');
      getmystatistics();
    } catch (e) {
      print('Error get UserData: $e');
    }
  }

  void getmystatistics() {
    if (MyGetStorage().haveData(key: 'statistic')) {
      statistic = Statistic.fromJson(MyGetStorage().readData(key: 'statistic')!);
    } else {
      refreshStatistics();
    }
  }

  void refreshStatistics() async {
    statisticsRepository.getMyStatistics().then((value) {
      statistic = value;
      update();
    });
  }
}
