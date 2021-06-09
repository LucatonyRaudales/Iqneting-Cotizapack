import 'dart:typed_data';

import 'package:cotizapack/model/PakageModel.dart';
import 'package:cotizapack/repository/packageRepositori.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

class ShopQuotationsCtrl extends GetxController
    with StateMixin<List<Pakageclass>?> {
  Pakageclass? pakageclass;
  Uint8List? image;
  @override
  void onInit() {
    change(null, status: RxStatus.empty());
    getPakage();
    super.onInit();
  }

  getPakage() {
    try {
      change(null, status: RxStatus.loading());
      PackaRepository().getPackages().then((value) {
        if (value == null)
          change(null, status: RxStatus.error('A Ocurrido un error'));
        if (value?.length == 0) change(null, status: RxStatus.empty());
        change(value, status: RxStatus.success());
      }).timeout(Duration(seconds: 3), onTimeout: () {
        change(
          null,
          status: RxStatus.error(
            'error: ¡Se a Tardado Demaciado!',
          ),
        );
      });
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
