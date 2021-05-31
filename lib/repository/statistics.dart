import 'package:appwrite/appwrite.dart';
import 'package:cotizapack/model/categories.dart';
import 'package:cotizapack/model/statistic.dart';
import 'package:cotizapack/model/user_data.dart';
import 'package:cotizapack/settings/appwrite.dart';
import 'package:cotizapack/settings/get_storage.dart';

class StatisticsRepository {
  UserData _userData = UserData(
      category: UserCategory(
          collection: '', description: '', name: '', enable: true, id: ''));
  final String collectionID = "6092f3e7eef5f";
  late Database database;
  Statistic _statistic = Statistic();

  Future createStatistic(String user) async {
    try {
      database = Database(AppwriteSettings.initAppwrite());
      Response res = await database.createDocument(
          collectionId: collectionID,
          data: {"userID": user},
          read: ['*'],
          write: ["user:$user"]);
      return res;
    } catch (err) {
      print('Error create quotation: .$err');
      return null;
    }
  }

  Future updateStatistic({required Map<dynamic, dynamic> data}) async {
    try {
      database = Database(AppwriteSettings.initAppwrite());
      this._statistic =
          Statistic.fromJson(MyGetStorage().readData(key: 'statistic')!);
      Response res = await database.updateDocument(
          documentId: _statistic.id!,
          collectionId: collectionID,
          data: data,
          read: ['*'],
          write: ["user:${_statistic.userId}"]);
      return res;
    } catch (err) {
      print('Error create quotation: .$err');
      return null;
    }
  }

  Future<Statistic> getMyStatistics() async {
    try {
      database = Database(AppwriteSettings.initAppwrite());
      this._userData = (await MyGetStorage().listenUserData())!;
      Response res = await database.listDocuments(
          collectionId: collectionID,
          orderType: OrderType.desc,
          limit: 1,
          filters: ["userID=${_userData.userID}"]);

      if (res.data["sum"] == 0) {
        await StatisticsRepository().createStatistic(_userData.userID!);
        return getMyStatistics();
      }
      var data = res.data["documents"][0];
      _statistic = Statistic.fromJson(data);
      MyGetStorage().saveData(key: 'statistic', data: data);
      return _statistic;
    } catch (err) {
      print('Error create quotation: .$err');
      return _statistic;
    }
  }

  Future compareStatistics({required String key, required int value}) async {
    if (MyGetStorage().readData(key: 'statistic') != null)
      _statistic =
          Statistic.fromJson(MyGetStorage().readData(key: 'statistic')!);
    switch (key) {
      case "quotesSent":
        return await updateStatistic(
            data: {"quotesSent": _statistic.quotesSent + value});
      /* return _statistic.quotesSent != value ? 
        await updateStatistic(data: {"quotesSent" : _statistic.quotesSent + value}) : null;*/

      case "quotesCanceled":
        return await updateStatistic(
            data: {"quotesCanceled": _statistic.quotesCanceled + value});
      /*return _statistic.quotesCanceled != value ? 
        await updateStatistic(data: {"quotesCanceled" :  _statistic.quotesCanceled + value}) : null;*/

      case "myCategories":
        return _statistic.myCategories != value
            ? await updateStatistic(data: {"myCategories": value})
            : null;

      case "myProducts":
        return _statistic.myProducts != value
            ? await updateStatistic(data: {"myProducts": value})
            : null;

      case "myClients":
        return _statistic.myClients != value
            ? await updateStatistic(data: {"myClients": value})
            : null;

      case "totalQuotes":
        return _statistic.totalQuotes != value
            ? await updateStatistic(data: {"totalQuotes": value})
            : null;
      default:
        print('asaber papito');
    }
  }
}
