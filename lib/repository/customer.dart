import 'package:appwrite/appwrite.dart';
import 'package:cotizapack/model/categories.dart';
import 'package:cotizapack/model/customers.dart';
import 'package:cotizapack/model/my_account.dart';
import 'package:cotizapack/model/user_data.dart';
import 'package:cotizapack/settings/appwrite.dart';
import 'package:cotizapack/settings/get_storage.dart';

class CustomerRepository{
    MyAccount myAccount = MyAccount();
    CustomerList list = CustomerList();
      MyGetStorage _myGetStorage = MyGetStorage();
  final String collectionID = "6086a641bf4ab";
  //final String productCategoriesCollectionID = '60822a3365a96';
  late Database database;
  UserData _userData = UserData(category: UserCategory(collection: '', id: '', name: '', description: '', enable: true));

  Future<CustomerList> getMyCustomers()async{
    database = Database(AppwriteSettings.initAppwrite());
    try{
      _userData = _myGetStorage.listenUserData()!;
      Response res = await database.listDocuments(
        collectionId: collectionID,
        filters: [
          'userID=${_userData.userID}',
          'enable=1'
        ]
      );
      list = CustomerList.fromJson(
        res.data["documents"],);
      return list;
    }catch(e){
      print('Error get Customers ${e.toString()}');
      return CustomerList.fromJson([]);
    }
  }

  Future<Response?> saveDocument(CustomerModel customer)async{
    database = Database(AppwriteSettings.initAppwrite());
    try{
      //_userData = _myGetStorage.listenUserData()!;
      Response res = await database.createDocument(
        collectionId: collectionID, 
        data: customer.toJson(), 
        read: ['*'], 
        write: ['user:${customer.userId}']
      );
      return res;
    }catch(e){
      print('Error save customer: $e');
      return null;
    }
  }

  Future<bool> updateCustomer({required CustomerModel customer})async{
        database = Database(AppwriteSettings.initAppwrite());
    try{
      _userData = _myGetStorage.listenUserData()!;
      Response res = await database.updateDocument(
        collectionId: collectionID,
        documentId: customer.id!,
        data: customer.toJson(), 
        read: ['*'], 
        write: ['user:${customer.userId}']
      );
      return res.statusCode == 200 ? true : false;
    }catch(e){
      print('Error save customer: $e');
      return false;
    }
  }

  Future<bool> disableCustomer({required String customerID})async{
    database = Database(AppwriteSettings.initAppwrite());
    try{
      _userData = _myGetStorage.listenUserData()!;
      Response res = await database.updateDocument(
        collectionId: collectionID, 
        documentId: customerID, 
        data: {'enable':false}, 
        read: ['*'], 
        write: ['user:${_userData.userID}']
      );
      return res.statusCode == 200 ? true : false;
    }catch(e){
      print('Error: $e');
      return false;
    }
  }
}