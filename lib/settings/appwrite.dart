import 'package:appwrite/appwrite.dart';

class AppwriteSettings {
  // static const endPoint = 'http://137.184.6.58/v1';
  static const endPoint = 'https://cotizaweb.iqneting.com.mx/v1';
  static const projectID = '612d32add254f';

  // .setEndpoint('https://104.236.201.156/v1') // Your Appwrite Endpoint
  // .setProject('6080bf8f2d0d2') // Your project ID
  static Client initAppwrite() {
    Client client = Client();
    client
        .setEndpoint('$endPoint') // Your Appwrite Endpoint
        .setProject('$projectID'); // Your project ID
    // .setSelfSigned(); // Remove in production;
    return client;
  }
}
