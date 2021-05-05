import 'package:cotizapack/settings/share.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

class PDFCtrl extends GetxController{
  MyShareClass _share = MyShareClass();
  @override
  void onInit() {
    print('PDF Viewer');
    super.onInit();
  }

  void sharePDF(BuildContext context, String path)async{
    _share.sharePDF(context, path: path)  
      .then((value){
        print('awebo');
      });
  }
}