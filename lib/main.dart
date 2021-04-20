import 'package:cotizapack/pages/splash/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

void main() async {
  await GetStorage.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      color: Colors.grey,
      title: 'Cotiza Pack',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SplashPage()
    );
  }
}