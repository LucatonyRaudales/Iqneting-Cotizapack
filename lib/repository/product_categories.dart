import 'package:appwrite/appwrite.dart';
import 'package:cotizapack/model/categories.dart';
import 'package:cotizapack/model/product_category.dart';
import 'package:cotizapack/model/user_data.dart';
import 'package:cotizapack/settings/appwrite.dart';
import 'package:cotizapack/settings/get_storage.dart';

class ProductCategoryRepository{
  final String collectionID = "60822a3365a96";
  late Database database;
  ListProductCategory categories = ListProductCategory();
  UserData _userData = UserData(category: UserCategory(collection: '', description: '', name: '', enable: true, id: ''));


  Future<ListProductCategory> getCategories()async{
    database = Database(AppwriteSettings.initAppwrite());
      this._userData =(await MyGetStorage().listenUserData())!;
    try {
      Response result  = await database.listDocuments(
        collectionId: collectionID,
        filters: [
          "userID=${_userData.userID}",
          "enable=1",
        ]
      );
      categories =  ListProductCategory.fromJson(result.data["documents"]);
      return categories;
    } catch (e) {
      return categories;
    }
  }

  Future<Response?> saveDocument({required ProductCategory category})async{
    database = Database(AppwriteSettings.initAppwrite());
    try {
    this._userData = (await MyGetStorage().listenUserData())!;
    category.userID = _userData.userID;
    category.createAt = DateTime.now().microsecondsSinceEpoch;
    Response result = await database.createDocument(
    collectionId: collectionID,
    data: category.toJson(),
    read: ["*"],
    write: ["user:${_userData.userID}"],
  );
  return result;
    } catch (e) {
      print('Error $e');
      return null;
    }
  }

    Future<bool> updateCategory({required ProductCategory category})async{
        database = Database(AppwriteSettings.initAppwrite());
    try{
      //_userData = _myGetStorage.listenUserData()!;
      Response res = await database.updateDocument(
        collectionId: collectionID,
        documentId: category.id!,
        data: category.toJson(), 
        read: ['*'], 
        write: ['user:${category.userID}']
      );
      return res.statusCode == 200 ? true : false;
    }catch(e){
      print('Error save customer: $e');
      return false;
    }
  }

    Future<bool> disableCategory({required ProductCategory category})async{
    database = Database(AppwriteSettings.initAppwrite());
    try{
      Response res = await database.updateDocument(
        collectionId: collectionID, 
        documentId: category.id!, 
        data: {'enable':false}, 
        read: ['*'], 
        write: ['user:${category.userID}']
      );
      return res.statusCode == 200 ? true : false;
    }catch(e){
      print('Error: $e');
      return false;
    }
  }
}