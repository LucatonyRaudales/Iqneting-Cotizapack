import 'package:appwrite/appwrite.dart';
import 'package:cotizapack/common/Collections_api.dart';
import 'package:cotizapack/model/MyPackage.dart';
import 'package:cotizapack/model/categories.dart';
import 'package:cotizapack/model/my_account.dart';
import 'package:cotizapack/model/user_data.dart';
import 'package:cotizapack/settings/appwrite.dart';
import 'package:cotizapack/settings/get_storage.dart';

class MyPackaRepository {
  final String collectionID = Collections.MYPACKAGE;
  final String userCollection = Collections.USER;
  late Database _database;
  MyAccount myAccount = MyAccount();
  UserData userData = UserData(
    category: UserCategory(
        collection: '', id: '', name: '', description: '', enable: true),
  );

  Future<List<Mypackage>?> getPackages() async {
    _database = Database(AppwriteSettings.initAppwrite());
    try {
      this.userData = (await MyGetStorage().listenUserData());
      Response res =
          await _database.listDocuments(collectionId: collectionID, filters: [
        "userID=${userData.userID}",
      ]);
      // StatisticsRepository()
      //     .compareStatistics(key: 'myClients', value: res.data["sum"]);
      List<Mypackage> list = (res.data["documents"])
          .map<Mypackage>((value) => Mypackage.fromMap(value))
          .toList();
      return list;
    } catch (e) {
      print('Error get myPackage ${e.toString()}');
      return null;
    }
  }

  Future<Response?> saveMyPackage({required Mypackage mypackage}) async {
    _database = Database(AppwriteSettings.initAppwrite());
    try {
      this.userData = (await MyGetStorage().listenUserData());
      mypackage.userId = userData.userID;
      Response res = await _database.createDocument(
        collectionId: collectionID,
        data: mypackage.toMap(),
        read: ["*"],
        write: ["user:${userData.userID}"],
      );
      return res;
    } on AppwriteException catch (e) {
      throw "Error create myPackage ${e.message}";
    }
  }
}
