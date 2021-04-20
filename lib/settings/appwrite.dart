import 'package:appwrite/appwrite.dart';

class AppwriteSettings {

  static const endPoint = 'https://104.236.201.156/v1';
  static const projectID = '6075d900ebefa';

  static Client initAppwrite(){
    Client client = Client();
    client
      .setEndpoint('https://104.236.201.156/v1') // Your Appwrite Endpoint
      .setProject('6075d900ebefa') // Your project ID
      .setSelfSigned(); // Remove in production;
    return client;
  }
}