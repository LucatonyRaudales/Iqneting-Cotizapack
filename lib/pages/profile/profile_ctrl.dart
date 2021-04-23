import 'dart:async';

import 'package:cotizapack/common/alert.dart';
import 'package:cotizapack/common/button.dart';
import 'package:cotizapack/common/modalBottomSheet.dart';
import 'package:cotizapack/common/textfields.dart';
import 'package:cotizapack/common/validators.dart';
import 'package:cotizapack/model/categories.dart';
import 'package:cotizapack/model/my_account.dart';
import 'package:cotizapack/model/user_data.dart';
import 'package:cotizapack/repository/account.dart';
import 'package:cotizapack/repository/user.dart';
import 'package:cotizapack/settings/get_storage.dart';
import 'package:cotizapack/styles/typography.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:line_icons/line_icons.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import '../splash/splash_screen.dart';

class ProfileCtrl extends GetxController{
  final RoundedLoadingButtonController btnController = new RoundedLoadingButtonController();
  UserRepository _userRepository = UserRepository();
  AccountRepository _accountRepository = AccountRepository();
  String newPassword = '', oldPassword = '';
    MyAccount myAccount = MyAccount();
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
    giro: "",
    userID: "",
    category: userCategory
  );


  @override
  void onInit() {
    getUserData();
    super.onInit();
  }

    void getUserData(){
    try{
    userData =  MyGetStorage().listenUserData()!;
    print('User name: ${userData.businessName}');
    }catch(e){
      print('Error get UserData: $e');
    }
  }

  void getAccount(){
    try{
    myAccount =  MyGetStorage().readData(key: 'accountData') as MyAccount;
    }catch(e){
    print('Error box getAccount:$e');
    }
  }

  void updatePassword(BuildContext ctx){
  final _formKey = GlobalKey<FormState>();
    MyBottomSheet().show(ctx, 300, Form(
      key: _formKey,
      child: Column(
        children: [
          SizedBox(
            height: 20,
          ),
          new Text('actualizar contraseña'.toUpperCase(), style: subtitulo, textAlign: TextAlign.center,),
          SizedBox(
            height: 20,
          ),
          InputText(
            name: 'Actual contraseña',
            textInputType: TextInputType.visiblePassword,
            validator: Validators.passwordValidator,
            prefixIcon: Icon(LineIcons.lock),
            onChanged: (val)=> this.oldPassword= val,
          ),
          SizedBox(
            height: 20,
          ),
          InputText(
            name: 'Nueva contraseña',
            textInputType: TextInputType.visiblePassword,
            validator: Validators.passwordValidator,
            prefixIcon: Icon(LineIcons.lock),
            onChanged: (val)=> this.newPassword = val,
          ),
          SizedBox(
            height: 30,
          ),
          Button(
            function: (){
              if (!_formKey.currentState!.validate()) {
                return btnController.reset();
              }
              _accountRepository.updatePassword(oldPassword: oldPassword, newPassword: newPassword)
              .then((value) {
                if(value == null){
                  btnController.error();
                  MyAlert.showMyDialog(title: 'Contraseña incorrecta', message: 'por favor ingresa tu antigua contraseña correctamente', color: Colors.red);
                  Timer(Duration(seconds: 3),()=> btnController.reset());
                }else{
                  btnController.success();
                  MyAlert.showMyDialog(title: '¡Contraseña actualizada!', message: 'por favor, inicia sesión', color: Colors.green);
                  Timer(Duration(seconds: 3),()=>logout());
                }
              });
            },
            btnController: btnController,
            name: 'Actualizar'),
          SizedBox(height: 15,),
      ],),
    ));
    
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