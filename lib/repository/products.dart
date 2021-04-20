import 'package:appwrite/appwrite.dart';
import 'package:cotizapack/settings/appwrite.dart';

class ProductRepository {
  final String collectionID = "6075e8a23227d";
  late Database database;

  Future<Response?> saveDocument({required Map<dynamic, dynamic> data})async{
    database = Database(AppwriteSettings.initAppwrite());
    try {
    Response result = await database.createDocument(
    collectionId: collectionID,
    data: data,
    read: ["user:607a2389ca8b7"],
    write: ["user:607a2389ca8b7"],
  );
  return result;
    } catch (e) {
      print('Error $e');
    }
  }

  Future<Response?> getProducts()async{
    database = Database(AppwriteSettings.initAppwrite());
    try {
      Response result  = await database.listDocuments(collectionId: collectionID);
      return result;
    } catch (e) {
      print('error repository products $e');
    }
  }
}