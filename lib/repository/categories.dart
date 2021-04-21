import 'package:appwrite/appwrite.dart';
import 'package:cotizapack/common/categories.dart';
import 'package:cotizapack/settings/appwrite.dart';

class CategoriesRepository{
  final String collectionID = "60804a662d7e3";
  late Database database;
  UserCategoryList categories = UserCategoryList();

  Future<UserCategoryList> getCategories()async{
    database = Database(AppwriteSettings.initAppwrite());
    
    try {
      Response result  = await database.listDocuments(collectionId: collectionID);
      categories =  UserCategoryList.fromJson(result.data["documents"]);
      return categories;
    } catch (e) {
      return categories;
    }
  }
}