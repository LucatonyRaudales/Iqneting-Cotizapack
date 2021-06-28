import 'package:appwrite/appwrite.dart';
import 'package:cotizapack/common/Collections_api.dart';
import 'package:cotizapack/model/Banner_Model.dart';
import 'package:cotizapack/model/user_data.dart';
import 'package:cotizapack/settings/appwrite.dart';

class UsersRepository {
  final String collectionID = Collections.USER;
  final String collectionBanners = Collections.BANNERS;
  late Database database;

  Future<UserList> getUsers() async {
    try {
      database = Database(AppwriteSettings.initAppwrite());
      Response res = await database
          .listDocuments(collectionId: collectionID, filters: ["enable=1"]);
      return UserList.fromJson(res.data['documents']);
    } on AppwriteException catch (e) {
      print('Error get Users');
      throw 'Error Get Users ${e.message}';
    }
  }

  Future<List<BannersModel>?> getbanner() async {
    var banners = <BannersModel>[];
    try {
      database = Database(AppwriteSettings.initAppwrite());
      Response res = await database.listDocuments(
          collectionId: collectionBanners, filters: ["enable=1"]);
      for (var data in res.data['documents']) {
        banners.add(BannersModel.fromMap(data));
      }
      return banners;
    } on AppwriteException catch (e) {
      print('Error get banners');
      throw 'Error Get banners ${e.message}';
    }
  }
}
