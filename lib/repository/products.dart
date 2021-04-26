import 'package:appwrite/appwrite.dart';
import 'package:cotizapack/model/my_account.dart';
import 'package:cotizapack/model/product_category.dart';
import 'package:cotizapack/repository/account.dart';
import 'package:cotizapack/settings/appwrite.dart';

class ProductRepository {
    MyAccount myAccount = MyAccount();
  final String collectionID = "608222f2ca95c";
  final String productCategoriesCollectionID = '60822a3365a96';
  late Database database;

  Future<Response?> saveDocument({required Map<dynamic, dynamic> data})async{
    database = Database(AppwriteSettings.initAppwrite());
    try {
    myAccount = (await AccountRepository().getAccount())!;
    Response result = await database.createDocument(
    collectionId: collectionID,
    data: data,
    read: ["*"],
    write: ["user:${myAccount.id}"],
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
      return null;
    }
  }

    Future<ListProductCategory?> getProductsCategories()async{
    database = Database(AppwriteSettings.initAppwrite());
    ListProductCategory listProductCategory = ListProductCategory();
    try {
      Response result  = await database.listDocuments(
        collectionId: productCategoriesCollectionID,
        filters: ['enable=1']
      );
      listProductCategory = ListProductCategory.fromJson(result.data['documents']);
      return listProductCategory;
    } catch (e) {
      print('error repository products $e');
      return null;
    }
  }
}