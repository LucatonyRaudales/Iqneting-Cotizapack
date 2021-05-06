import 'package:cotizapack/model/statistic.dart';
import 'package:cotizapack/repository/statistics.dart';
import 'package:cotizapack/settings/get_storage.dart';
import 'package:cotizapack/settings/share.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

class PDFCtrl extends GetxController{
  MyShareClass _share = MyShareClass();
  Statistic _statistic = Statistic();
  @override
  void onInit() {
    print('PDF Viewer');
    super.onInit();
  }

  void sharePDF(BuildContext context, String path)async{
    _share.sharePDF(context, path: path)  
      .then((value){
        _statistic = Statistic.fromJson(MyGetStorage().readData(key: 'statistic'));
        StatisticsRepository().updateStatistic(data: {"quotesSent" : _statistic.quotesSent + 1});
        print('awebo');
      });
  }
}