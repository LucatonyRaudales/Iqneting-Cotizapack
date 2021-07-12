import 'package:appwrite/appwrite.dart';

class AppwriteSettings {
  static const endPoint = 'https://cotizaweb.iqneting.com.mx/v1';
  static const projectID = '60b55553c0bd4';

  // .setEndpoint('https://104.236.201.156/v1') // Your Appwrite Endpoint
  // .setProject('6080bf8f2d0d2') // Your project ID
  static Client initAppwrite() {
    Client client = Client();
    client
        .setEndpoint('$endPoint') // Your Appwrite Endpoint
        .setProject('$projectID') // Your project ID
        .setSelfSigned(); // Remove in production;
    return client;
  }
}
