import 'package:cotizapack/model/categories.dart';
import 'package:cotizapack/model/user_data.dart';
import 'package:cotizapack/settings/get_storage.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

class InitPageCtrl extends GetxController{
  UserCategory userCategory = UserCategory(
    collection: "fds",
    enable: true,
    name: "",
    description: "",
    id: "",
  );
  late UserData userData = UserData(
    ceoName: "",
    nickname: "",
    businessName: "",
    logo: "",
    paymentUrl: "--",
    userID: "",
    category: userCategory);

  @override
  void onInit() {
    getUserData();
    super.onInit();
  }


  void getUserData()async{
    try{
    userData =  (await MyGetStorage().listenUserData());
    print('User name: ${userData.businessName}');
    update();
    }catch(e){
      print('Error get UserData: $e');
    }
  }
}