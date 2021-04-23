import 'package:appwrite/appwrite.dart';
import 'package:cotizapack/model/my_account.dart';
import 'package:cotizapack/settings/appwrite.dart';

class AccountRepository{
  Future<MyAccount?> getAccount()async{
    try{
  Account account = Account(AppwriteSettings.initAppwrite());
      Response res = await account.get();
      return MyAccount.fromJson(res.data);
    }catch(e){
      print('Error getAccount: $e');
      return null;
    }
  }

  Future<MyAccount?> updatePassword({required String oldPassword, required String newPassword})async{
    try{
  Account account = Account(AppwriteSettings.initAppwrite());
      Response res = await account.updatePassword(
        oldPassword: oldPassword,
        password: newPassword
      );
      return MyAccount.fromJson(res.data);
    }catch(e){
      print('Error getAccount: $e');
      return null;
    }
  }
}