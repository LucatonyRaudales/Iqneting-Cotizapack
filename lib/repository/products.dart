import 'package:appwrite/appwrite.dart';
import 'package:cotizapack/common/Collections_api.dart';
import 'package:cotizapack/model/categories.dart';
import 'package:cotizapack/model/my_account.dart';
import 'package:cotizapack/model/product.dart';
import 'package:cotizapack/model/product_category.dart';
import 'package:cotizapack/model/user_data.dart';
import 'package:cotizapack/repository/statistics.dart';
import 'package:cotizapack/settings/appwrite.dart';
import 'package:cotizapack/settings/get_storage.dart';

class ProductRepository {
  MyAccount myAccount = MyAccount();
  final String collectionID = Collections.PRODUCTS_SERVICES;
  final String productCategoriesCollectionID = Collections.CATEGORYPRODUCTS;
  late Database database;
  UserData _userData = UserData(
      category: UserCategory(
          collection: '', description: '', name: '', enable: true, id: ''));

  Future<Response?> saveDocument({required ProductModel data}) async {
    database = Database(AppwriteSettings.initAppwrite());
    try {
      data.enable = true;
      Response result = await database.createDocument(
        collectionId: collectionID,
        data: data.toJson(),
        read: ["*"],
        write: ["user:${data.userId}"],
      );
      return result;
    } catch (e) {
      print('Error $e');
    }
  }

  ///optiene los productos de dicha categoria
  Future<Response?> getProductsByCategory({required String categoryID}) async {
    database = Database(AppwriteSettings.initAppwrite());
    try {
      this._userData = (await MyGetStorage().listenUserData());
      Response result = await database.listDocuments(
          collectionId: collectionID,
          filters: [
            "userID=${_userData.userID}",
            "enable=1",
            "category.\u0024id=$categoryID"
          ]);
      return result;
    } catch (e) {
      print('error repository products $e');
      return null;
    }
  }

  Future<Response?> getProducts() async {
    database = Database(AppwriteSettings.initAppwrite());
    try {
      this._userData = (await MyGetStorage().listenUserData());
      Response result =
          await database.listDocuments(collectionId: collectionID, filters: [
        "userID=${_userData.userID}",
        "enable=1",
      ]);
      StatisticsRepository()
          .compareStatistics(key: 'myProducts', value: result.data["sum"]);
      return result;
    } catch (e) {
      print('error repository products $e');
      return null;
    }
  }

  Future<ListProductCategory?> getProductsCategories(
      {required String userID}) async {
    database = Database(AppwriteSettings.initAppwrite());
    ListProductCategory listProductCategory = ListProductCategory();
    try {
      Response result = await database.listDocuments(
          collectionId: productCategoriesCollectionID,
          filters: ['userID=$userID', 'enable=1']);
      listProductCategory =
          ListProductCategory.fromJson(result.data['documents']);
      return listProductCategory;
    } catch (e) {
      print('error repository products $e');
      return null;
    }
  }

  ///optiene los segun su tipo
  Future<ProductList?> getProductsByType() async {
    database = Database(AppwriteSettings.initAppwrite());
    ProductList listProductbyType = ProductList();
    try {
      this._userData = (await MyGetStorage().listenUserData());
      Response result = await database.listDocuments(
          collectionId: collectionID,
          filters: ['userID=${_userData.userID}', 'enable=1']);
      listProductbyType = ProductList.fromJson(result.data['documents']);
      StatisticsRepository()
          .compareStatistics(key: 'myProducts', value: result.data["sum"]);
      return listProductbyType;
    } catch (e) {
      print('error repository products $e');
      return null;
    }
  }

  Future<bool> updateProduct({required ProductModel product}) async {
    database = Database(AppwriteSettings.initAppwrite());
    try {
      //_userData = _myGetStorage.listenUserData()!;
      Response res = await database.updateDocument(
          collectionId: collectionID,
          documentId: product.id!,
          data: product.toJson(),
          read: ['*'],
          write: ['user:${product.userId}']);
      return res.statusCode == 200 ? true : false;
    } catch (e) {
      print('Error save customer: $e');
      return false;
    }
  }

  Future<bool> disableProduct({required String productID}) async {
    database = Database(AppwriteSettings.initAppwrite());
    try {
      Response res = await database.updateDocument(
          collectionId: collectionID,
          documentId: productID,
          data: {'enable': false},
          read: ['*'],
          write: ['*']);
      return res.statusCode == 200 ? true : false;
    } catch (e) {
      print('Error: $e');
      return false;
    }
  }

  Future<ProductList?> searchProduct(
      {int? type, OrderType order = OrderType.asc}) async {
    database = Database(AppwriteSettings.initAppwrite());
    ProductList searchProduct = ProductList();
    try {
      this._userData = (await MyGetStorage().listenUserData());
      Response res = await database.listDocuments(
        collectionId: collectionID,
        filters: ['userID=${_userData.userID}', 'type=${type ?? ''}'],
        orderType: order,
        orderField: 'price',
      );
      searchProduct = ProductList.fromJson(res.data['documents']);
      return searchProduct;
    } catch (e) {
      print('Error: $e.');
      return null;
    }
  }
}
