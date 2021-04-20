import 'package:appwrite/appwrite.dart';
import 'package:cotizapack/model/user_model.dart';
import 'package:cotizapack/settings/appwrite.dart';

class UserRepository {
  // Register User

  Future<Response?> signup({required UserModel user})async{
  Account account = Account(AppwriteSettings.initAppwrite());
    try{
      Response result = await account.create(
        email: user.email.toString(),
        password: user.password.toString(),
        name: user.nickname.toString());
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
}