import 'dart:io';

import 'package:cotizapack/model/statistic.dart';
import 'package:cotizapack/repository/statistics.dart';
import 'package:cotizapack/routes/app_pages.dart';
import 'package:cotizapack/settings/get_storage.dart';
import 'package:cotizapack/settings/share.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

class PDFCtrl extends GetxController {
  MyShareClass _share = MyShareClass();
  Statistic _statistic = Statistic();
  bool isDeleted = false;
  File? file;
  @override
  void onInit() {
    isDeleted = false;
    print('PDF Viewer');
    file = Get.arguments ?? null;
    super.onInit();
  }

  void sharePDF(BuildContext context, File file) async {
    _share.sharePDF(context, path: file.path).then((value) async {
      _statistic =
          Statistic.fromJson(MyGetStorage().readData(key: 'statistic')!);
      StatisticsRepository()
          .updateStatistic(data: {"quotesSent": _statistic.quotesSent + 1});
      await file.delete();
      isDeleted = true;
      print('awebo');
    });
  }

  void getBack(File file) async {
    if (isDeleted == false) await file.delete();
    Get.offAllNamed(Routes.INITIAL);
  }
}
