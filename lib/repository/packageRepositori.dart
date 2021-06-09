import 'package:appwrite/appwrite.dart';
import 'package:cotizapack/common/Collections_api.dart';
import 'package:cotizapack/model/PakageModel.dart';
import 'package:cotizapack/model/categories.dart';
import 'package:cotizapack/model/my_account.dart';
import 'package:cotizapack/model/user_data.dart';
import 'package:cotizapack/settings/appwrite.dart';

class PackaRepository {
  final String collectionID = Collections.PACKAGE;
  final String userCollection = Collections.USER;
  late Database _database;
  MyAccount myAccount = MyAccount();
  UserData userData = UserData(
    category: UserCategory(
        collection: '', id: '', name: '', description: '', enable: true),
  );

  Future<List<Pakageclass>?> getPackages() async {
    _database = Database(AppwriteSettings.initAppwrite());
    try {
      Response res = await _database.listDocuments(
        collectionId: collectionID,
      );
      // StatisticsRepository()
      //     .compareStatistics(key: 'myClients', value: res.data["sum"]);
      List<Pakageclass> list = (res.data["documents"])
          .map<Pakageclass>((value) => Pakageclass.fromMap(value))
          .toList();
      return list;
    } catch (e) {
      print('Error get Customers ${e.toString()}');
      return null;
    }
  }

  Future<List<Pakageclass>?> getMyPackages() async {
    _database = Database(AppwriteSettings.initAppwrite());
    try {
      Response res = await _database.listDocuments(
        collectionId: userCollection,
      );
      // StatisticsRepository()
      //     .compareStatistics(key: 'myClients', value: res.data["sum"]);
      List<Pakageclass> list = (res.data["documents"])
          .map<Pakageclass>((value) => Pakageclass.fromMap(value))
          .toList();
      return list;
    } catch (e) {
      print('Error get Customers ${e.toString()}');
      return null;
    }
  }
}
