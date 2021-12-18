import 'package:appwrite/appwrite.dart';
import 'package:cotizapack/model/social_auth_models.dart';
import 'package:cotizapack/settings/appwrite.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

class SocialAuth {
  late Account account;
  late LoginResult facebookAccessToken;
  FacebookData _facebookData = FacebookData();

  facebookSignIn() async {
    account = Account(AppwriteSettings.initAppwrite());
    try {
      return await account.createOAuth2Session(
          provider: 'facebook', failure: '', scopes: [], success: '');
    } catch (e) {
      print('Error init session oauth $e');
    }
  }

  googleSignIn() async {
    account = Account(AppwriteSettings.initAppwrite());
    try {
      return account.createOAuth2Session(
          provider: 'google', failure: '', scopes: [], success: '');
    } on AppwriteException catch (e) {
      print('Error init session oauth ${e.message}');
    }
  }

  Future<FacebookData?> facebookLogin() async {
    try {
      facebookAccessToken = await FacebookAuth.instance.login(
        permissions: ['public_profile', 'email'],
      );
      var data = await FacebookAuth.instance.getUserData();
      _facebookData = FacebookData.fromJson(data);
      return _facebookData;
    } catch (e, s) {
      print('error facbook login: $e');
      print(s);
      return null;
    }
  }
}
