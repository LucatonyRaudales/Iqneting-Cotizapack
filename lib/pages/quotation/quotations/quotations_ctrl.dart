import 'package:cotizapack/model/quotation.dart';
import 'package:cotizapack/repository/quotation.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

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
}