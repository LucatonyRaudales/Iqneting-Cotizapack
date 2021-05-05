import 'package:appwrite/appwrite.dart';
import 'package:cotizapack/model/categories.dart';
import 'package:cotizapack/model/quotation.dart';
import 'package:cotizapack/model/user_data.dart';
import 'package:cotizapack/settings/appwrite.dart';
import 'package:cotizapack/settings/get_storage.dart';

class QuotationRepository{
  final String collectionID = "60876e0763613";
  final String productCategoriesCollectionID = '60822a3365a96';
  late Database database;
  UserData _userData = UserData(category: UserCategory(collection: '', description: '', name: '', enable: true, id: ''));

  Future<Response?> createQuotation({required QuotationModel quotation})async{
    try{
    database = Database(AppwriteSettings.initAppwrite());
    quotation.createAt = DateTime.now().millisecondsSinceEpoch;
      Response res = await database.createDocument(
        collectionId: collectionID, 
        data: quotation.toJson(), 
        read: ['*'], 
        write: ["user:${quotation.userId}"]
      );
      return res;
    }catch(err){
      print('Error create quotation: .$err');
      return null;
    }
  }

  Future<QuotationsList> getQuotations()async{
    try{
    database = Database(AppwriteSettings.initAppwrite());
      this._userData = (await MyGetStorage().listenUserData())!;
    var res = await database.listDocuments(
      collectionId: collectionID,
      filters: ["userID=${_userData.userID}"]
      );
      return QuotationsList.fromJson(res.data['documents']);
    }catch(e){
      print('Error get quotations: $e');
      return QuotationsList.fromJson([]);
    }
  }
}