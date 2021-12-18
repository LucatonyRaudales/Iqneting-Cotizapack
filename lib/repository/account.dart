import 'package:appwrite/appwrite.dart';
import 'package:cotizapack/model/my_account.dart';
import 'package:cotizapack/model/token_reset_password.dart';
import 'package:cotizapack/settings/appwrite.dart';

class AccountRepository {
  late Account account;
  Future<MyAccount?> getAccount() async {
    try {
      account = Account(AppwriteSettings.initAppwrite());
      Response res = await account.get();
      return MyAccount.fromJson(res.data);
    } catch (e) {
      print('Error getAccount: $e');
      return null;
    }
  }

  Future<MyAccount?> updatePassword(
      {required String oldPassword, required String newPassword}) async {
    try {
      account = Account(AppwriteSettings.initAppwrite());
      Response res = await account.updatePassword(
          oldPassword: oldPassword, password: newPassword);
      return MyAccount.fromJson(res.data);
    } catch (e) {
      print('Error getAccount: $e');
      return null;
    }
  }

  Future<TokenReset> createPasswordRecovery({required String email}) async {
    TokenReset token = TokenReset();
    try {
      account = Account(AppwriteSettings.initAppwrite());
      Response result = await account.createRecovery(
        email: email,
        url: 'https://cotizapack-fd152.web.app/auth/recovery/reset',
      );

      if (result.statusCode == 201) {
        token = TokenReset.fromJson(result.data);
      }
      return token;
    } catch (e) {
      return TokenReset.fromJson({});
    }
  }

  Future<TokenReset> completePasswordRecovery(
      {required TokenReset token,
      required String password1,
      required String password2}) async {
    TokenReset tokenResponse = TokenReset();
    try {
      Response result = await account.updateRecovery(
        userId: token.userId!,
        secret: token.secret!,
        password: password1,
        passwordAgain: password2,
      );

      if (result.statusCode == 201) {
        tokenResponse = TokenReset.fromJson(result.data);
      }
      return tokenResponse;
    } catch (e) {
      return TokenReset.fromJson({});
    }
  }
}
