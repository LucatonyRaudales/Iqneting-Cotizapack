import 'package:appwrite/appwrite.dart';
import 'package:cotizapack/model/social_auth_models.dart';
import 'package:cotizapack/model/social_auth_models.dart';
import 'package:cotizapack/settings/appwrite.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

class SocialAuth{
  late Account account;
  late LoginResult  facebookAccessToken;
  FacebookData _facebookData = FacebookData();

  void facebookSignIn()async{
    account = Account(AppwriteSettings.initAppwrite());
    try{
      Response res = await  account.createOAuth2Session(
        provider: 'facebook',
      );
      if(res.statusCode == 301){
        print('bien hecho');
      }
      print(res.statusCode);
    }catch(e){
      print('Error init session oauth $e');
    }
   /* final LoginResult result = await FacebookAuth.instance.login(permissions:['public_profile','email','pages_show_list','pages_messaging','pages_manage_metadata'],); // by the fault we request the email and the public profile
if (result.status == LoginStatus.success) {
    // you are logged
    final AccessToken accessToken =  result.accessToken!;
}*/
  }

  Future<FacebookData?> facebookLogin()async{
    try{
      facebookAccessToken = await FacebookAuth.instance.login(
      permissions: ['public_profile', 'email'],
    );
    var data = await FacebookAuth.instance.getUserData();
    _facebookData = FacebookData.fromJson(data);
    return _facebookData;
    }catch(e, s){
      print('error facbook login: $e');
      print(s);
      return null;
    }
  }

}