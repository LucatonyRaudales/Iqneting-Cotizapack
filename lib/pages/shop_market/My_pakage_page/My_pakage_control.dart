import 'dart:typed_data';
import 'package:cotizapack/model/PakageModel.dart';
import 'package:cotizapack/model/categories.dart';
import 'package:cotizapack/model/user_data.dart';
import 'package:cotizapack/settings/get_storage.dart';
import 'package:get/get.dart';

class ListPakageController extends GetxController
    with StateMixin<List<Pakageclass>> {
  Uint8List? image;
  @override
  void onInit() {
    change(null, status: RxStatus.empty());
    getmyPackages();
    super.onInit();
  }

  UserData _userData = UserData(
      category: UserCategory(
          collection: '', id: '', name: '', description: '', enable: true));
  getmyPackages() async {
    try {
      change(null, status: RxStatus.loading());
      _userData = (await MyGetStorage().listenUserData());
      change(_userData.packages, status: RxStatus.success());
    } catch (e) {
      change(
        null,
        status: RxStatus.error(
          'error: $e',
        ),
      );
    }
  }
}
