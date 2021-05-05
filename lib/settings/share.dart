import 'package:flutter/material.dart';
import 'package:share/share.dart';

class MyShareClass{

  bool canShare({required int expirationDate}){
    DateTime quotationExpire = DateTime.fromMillisecondsSinceEpoch(expirationDate);
    if(DateTime.now().isBefore(quotationExpire)){
      return true;
    }else{
      return false;
    }
  }


  Future sharePDF(BuildContext context, {required String path}) async {
    final RenderBox box = context.findRenderObject() as RenderBox;
    List<String> list = [path];

      await Share.shareFiles(list,
          text: 'PDF',
          subject: 'Cotización',
          sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);
    return null;
  }
}