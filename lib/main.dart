import 'package:cotizapack/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'bindings/dashboard_binding.dart';

void main() async {
  await GetStorage.init();
  initializeDateFormatting('es_US');
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      enableLog: true,
      debugShowCheckedModeBanner: false,
      color: Colors.grey,
      initialRoute: Routes.INITIAL,
      title: 'Cotiza Pack',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.grey.shade200,
      ),
      getPages: AppPages.pages,
      initialBinding: DashboardBinding(),
    );
  }
}
