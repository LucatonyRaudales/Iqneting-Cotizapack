import 'dart:typed_data';
import 'package:cotizapack/model/PakageModel.dart';
import 'package:cotizapack/repository/mypackage_repository.dart';
import 'package:get/get.dart';

class ListPakageController extends GetxController
    with StateMixin<List<Pakageclass>> {
  Uint8List? image;
  List<Pakageclass> packages = <Pakageclass>[];
  @override
  void onInit() {
    change(null, status: RxStatus.empty());
    getmyPackages();
    super.onInit();
  }

  getmyPackages() async {
    try {
      change(null, status: RxStatus.loading());
      var data = await MyPackaRepository().getPackages();
      data!.map((e) => packages.add(e.package!)).toList();
      change(packages, status: RxStatus.success());
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
