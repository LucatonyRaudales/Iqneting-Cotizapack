import 'package:cotizapack/model/categories.dart';
import 'package:cotizapack/model/user_data.dart';
import 'package:cotizapack/repository/user.dart';
import 'package:cotizapack/settings/get_storage.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import '../splash/splash_screen.dart';

class ProfileCtrl extends GetxController{
  UserRepository _userRepository = UserRepository();
    UserCategory userCategory = UserCategory(
    collection: "fds",
    enable: true,
    name: "",
    description: "",
    id: "",
  );
  late UserData userData = UserData(category: userCategory);


  @override
  void onInit() {
    getUserData();
    super.onInit();
  }

    void getUserData()async{
    try{
    userData =  MyGetStorage().listenUserData()!;
    print('User name: ${userData.businessName}');
    }catch(e){
      print('Error get UserData: $e');
    }
  }

  void logout(){
    try {
      _userRepository.getSessions()
      .then((value){
        //_session = Session.fromJson(value!.data);
          _userRepository.logout()
          .then((value) async {
            await MyGetStorage().eraseData();
            Get.off(SplashPage(), transition: Transition.cupertino);
          });
      });
    } catch (e) {
    }
  }

  
}