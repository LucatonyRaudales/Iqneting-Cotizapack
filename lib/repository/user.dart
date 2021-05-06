import 'dart:async';
import 'package:appwrite/appwrite.dart';
import 'package:cotizapack/common/alert.dart';
import 'package:cotizapack/model/categories.dart';
import 'package:cotizapack/model/session_model.dart';
import 'package:cotizapack/model/user_data.dart';
import 'package:cotizapack/model/user_model.dart';
import 'package:cotizapack/pages/splash/splash_screen.dart';
import 'package:cotizapack/repository/statistics.dart';
import 'package:cotizapack/settings/appwrite.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' as getImport;

class UserRepository {
  UserCategory userCategory = UserCategory(
    name: "", 
    description: "", 
    enable: true,
    collection: "",
    id: ""
  );
  Session session = Session();
  late  UserData userData = UserData(category: userCategory);
  final String userCollectionID = "6080caddd98c6";
  late Database database;

  Future<Response?> signup({required UserModel user})async{
  Account account = Account(AppwriteSettings.initAppwrite());
    try{
      Response result = await account.create(
        email: user.email.toString(),
        password: user.password.toString(),
        name: user.nickname.toString());
        if(result.statusCode == 201){
          UserModel usuario = UserModel.fromJson(result.data);
          await StatisticsRepository().createStatistic(usuario);
        }
      return result;
    }catch(err){
      print('ERROR: $err');
    }
  }

  Future<Response?> signIn({required UserModel user})async{
  Account account = Account(AppwriteSettings.initAppwrite());
    try {
      Response response = await account.createSession(
        email: user.email.toString(), 
        password: user.password.toString()
      );
      return response;
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<Response?> logout()async{
  Account account = Account(AppwriteSettings.initAppwrite());
    try{
      Response response = await account.deleteSessions();
      return response;
    }catch(err){
      print('Error $err');
    }
  }

  Future<Response?> getSessions()async{
    try{
    Account account = Account(AppwriteSettings.initAppwrite());
    Response response = await account.get();
    return response;
    }catch(e){
      print('Error getSessions: $e');
    }
  }
  Future<Session?> getUserSessionData()async{
    try{
    Account account = Account(AppwriteSettings.initAppwrite());
    Response response = await account.get();
    session = Session.fromJson(response.data);
    return session;
    }catch(e){
      print('Error getSessions: $e');
      MyAlert.showMyDialog(title: 'Sesión caducada', message: 'Tu actual sesión está caducada, inicia sesión de nuevo', color: Colors.red);
      Timer(Duration(seconds: 2), ()=> getImport.Get.off(SplashPage(), transition: getImport.Transition.zoom));
      return null;
    }
  }

  Future<UserData> saveMyData({required Map<dynamic, dynamic> data})async{
    try{
      database = Database(AppwriteSettings.initAppwrite());
      Response response = await  database.createDocument(
        collectionId: userCollectionID, 
        data: data, 
        /*data:{
          "logo" : "logotiupo mi ciela",
          "ceoName": "ceoName",
          "businessName" : "logbusinessName",
          "phone": "phone",
          "address" : "address mi ciela",
          "nickName": "nickName",
          "userID": sesionData.userId
          "category": 
        },*/
        read: ["*"], write: ["user:${data["userID"]}"]);
        userData = UserData.fromJson(response.data);
      return userData;
    }catch(e){
      print(e);
      return userData;
    }
  }

  Future<Response?> updateMyData({required UserData data})async{
    try{
      database = Database(AppwriteSettings.initAppwrite());
      Response response = await  database.updateDocument(
        collectionId: userCollectionID,
        documentId: data.id!,
        data: data.toJson(),
        read: ["*"], write: ["user:${data.userID}"]);
      return response;
    }catch(e){
      print(e);
      return null;
    }
  }

  Future<UserData> chargeUserData({required String userID})async{
    try {
      database = Database(AppwriteSettings.initAppwrite());
      Response response = await database.listDocuments(
        collectionId: userCollectionID,
        filters: ["userID=$userID"],
        limit: 1
      );
      var data = response.data["documents"][0];
        userData = UserData.fromJson(data);
        return userData;
    } catch (e) {
      print('Error charge Data $e');
      return userData;
    }
  }
}