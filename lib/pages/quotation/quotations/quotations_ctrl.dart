import 'package:cotizapack/common/alert.dart';
import 'package:cotizapack/model/quotation.dart';
import 'package:cotizapack/repository/quotation.dart';
import 'package:cotizapack/repository/statistics.dart';
import 'package:cotizapack/settings/generate_pdf.dart';
import 'package:cotizapack/settings/share.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:intl/intl.dart';

class QuotationsCtrl extends GetxController{
  QuotationsList quotationsList = QuotationsList();
  QuotationRepository _quotationRepository = QuotationRepository();
  bool haveProducts = true;

  @override
  void onInit() {
    getQuotations();
    super.onInit();
  }

  Future getQuotations()async{
    try{
    this.haveProducts = true; 
      _quotationRepository.getQuotations()
      .then((list){
        if(list.quotations!.isEmpty){
          this.haveProducts = false;
          return update();
        }
        quotationsList = list;
        return update();
      });
    }catch(e){
      print('Error get products: $e');
    }
  }

  void shareQuotation({required QuotationModel quotation}){
      if(MyShareClass().canShare(expirationDate: quotation.expirationDate!)){
        print('Se puede compartir');
        PDF().generateFile(quotation: quotation);
        Get.back();
      }else{
        MyAlert.showMyDialog(
          title: 'No se puede compartir', 
          message: 'la cotización seleccionada expiró el día ${DateFormat.yMMMMEEEEd('es_US').format(DateTime.fromMillisecondsSinceEpoch(quotation.expirationDate!)).toString()}', 
          color: Colors.grey
        );
    }
  }

  void changeQuotationStatus({required QuotationModel quotation, required String status, required int index}){
    int value = status == "quotesSent" ? 1 : 2;
    QuotationRepository().updateQuotation(quotation: quotation, toUpdate: {"status" : value})
      .then((val)async{
        Get.back();
        String toShow = value == 1 ? 'Aceptado' : 'Rechazado';
        MyAlert.showMyDialog(
          title: 'Estado actualizado', 
          message: 'se ha cambiado el estado de la cotización ${quotation.title} de generado a $toShow', 
          color: Colors.green
        );
        quotationsList.quotations![index].status= value;
        await StatisticsRepository().compareStatistics(key: status, value: 1);
        update();
      });
  }
}