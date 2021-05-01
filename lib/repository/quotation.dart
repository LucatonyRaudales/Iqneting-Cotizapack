import 'package:appwrite/appwrite.dart';
import 'package:cotizapack/model/quotation.dart';
import 'package:cotizapack/settings/appwrite.dart';

class QuotationRepository{
  final String collectionID = "60876e0763613";
  final String productCategoriesCollectionID = '60822a3365a96';
  late Database database;

  /*Future createColecction()async{
    try{
      Response res = await database-
    }catch(e){
      print('Error create Colecction: $e');
    }
  }*/

  Future<Response?> createQuotation({required QuotationModel quotation})async{
    try{
    database = Database(AppwriteSettings.initAppwrite());
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
}