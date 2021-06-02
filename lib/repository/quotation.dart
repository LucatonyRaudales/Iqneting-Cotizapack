import 'package:appwrite/appwrite.dart';
import 'package:cotizapack/common/Collections_api.dart';
import 'package:cotizapack/model/ModelPDF.dart';
import 'package:cotizapack/model/categories.dart';
import 'package:cotizapack/model/user_data.dart';
import 'package:cotizapack/repository/statistics.dart';
import 'package:cotizapack/settings/appwrite.dart';
import 'package:cotizapack/settings/get_storage.dart';

class QuotationRepository {
  final String collectionID = Collections.QUOTATIONS;
  final String productCategoriesCollectionID = Collections.CATEGORYPRODUCTS;
  late Database database;
  UserData _userData = UserData(
      category: UserCategory(
          collection: '', description: '', name: '', enable: true, id: ''));

  Future<Response?> createQuotation({required QuotationModel quotation}) async {
    try {
      database = Database(AppwriteSettings.initAppwrite());
      quotation.createAt = DateTime.now().millisecondsSinceEpoch;
      
      Response res = await database.createDocument(
        collectionId: collectionID,
        data: quotation.toJson(),
        read: ['*'],
        write: ["user:${quotation.userId}"],
      );
      return res;
    } catch (err) {
      print('Error create quotation: .$err');
      return null;
    }
  }

  Future<QuotationsList> getQuotations(int? status) async {
    try {
      database = Database(AppwriteSettings.initAppwrite());
      this._userData = (await MyGetStorage().listenUserData());
      var filter = ["userID=${_userData.userID}", "status=$status"];
      if (status == null) filter = ["userID=${_userData.userID}"];
      var res = await database.listDocuments(
        collectionId: collectionID,
        filters: filter,
      );
      StatisticsRepository()
          .compareStatistics(key: 'totalQuotes', value: res.data["sum"]);
      return QuotationsList.fromJson(res.data['documents']);
    } catch (e) {
      print('Error get quotations: $e');
      return QuotationsList.fromJson([]);
    }
  }

  Future<int> updateQuotation(
      {required QuotationModel quotation,
      required Map<String, dynamic> toUpdate}) async {
    try {
      database = Database(AppwriteSettings.initAppwrite());
      Response res = await database.updateDocument(
        documentId: quotation.id!,
        collectionId: collectionID,
        data: toUpdate,
        read: ['*'],
        write: ["user:${quotation.userId}"],
      );
      return res.statusCode!;
    } catch (err) {
      print('Error create quotation: .$err');
      return 500;
    }
  }
}
