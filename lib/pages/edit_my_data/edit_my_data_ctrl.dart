import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

class EditMyDataCtrl extends GetxController{
  final RoundedLoadingButtonController btnController = new RoundedLoadingButtonController();
  
  String info = 'edit my data';
  @override
  void onInit() {
    print('Edit my data');
    super.onInit();
  }

  void editMyData()async{

  }
}