import 'package:cotizapack/model/user_data.dart';
import 'package:cotizapack/repository/users.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

class CategoriesCtrl extends GetxController{
  UsersRepository _usersRepository = UsersRepository();
  UserList userList = UserList();
  bool haveUsers = true;

  @override
  void onInit() {
    loadData();
    super.onInit();
  }
  
  Future loadData() async {
    _usersRepository.getUsers()
      .then((value){
        if(value.users!.isEmpty){
          haveUsers = false;
          return update();
        }
        userList = value;
        return update();
      });
  }
}