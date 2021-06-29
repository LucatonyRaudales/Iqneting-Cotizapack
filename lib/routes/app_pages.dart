import 'package:cotizapack/bindings/My_pakage_binding.dart';
import 'package:cotizapack/bindings/duotations_binding.dart';
import 'package:cotizapack/bindings/home_binding.dart';
import 'package:cotizapack/bindings/login_binding.dart';
import 'package:cotizapack/bindings/creditcard_binding.dart';
import 'package:cotizapack/bindings/products_search_binding.dart';
import 'package:cotizapack/bindings/splash_binding.dart';
import 'package:cotizapack/pages/customer/customers/customers_page.dart';
import 'package:cotizapack/bindings/shopquotations_binding.dart';
import 'package:cotizapack/pages/home/home_page.dart';
import 'package:cotizapack/pages/login/login_page.dart';
import 'package:cotizapack/pages/product/new_product/new_product_page.dart';
import 'package:cotizapack/pages/product/product_category/product_categories_page.dart';
import 'package:cotizapack/pages/product/products/products_page.dart';
import 'package:cotizapack/pages/product/productssearch/products_search_page.dart';
import 'package:cotizapack/pages/quotation/new_quotation/new_quotation_page.dart';
import 'package:cotizapack/pages/quotation/quotations/quotations_page.dart';
import 'package:cotizapack/pages/shop_market/My_pakage_page/My_pakage_page.dart';
import 'package:cotizapack/pages/shop_market/creditcard_pakage/creditcard_page.dart';

import 'package:cotizapack/pages/shop_market/shop_page.dart';
import 'package:cotizapack/pages/splash/splash_screen.dart';
import 'package:get/get.dart';
part './app_routes.dart';

abstract class AppPages {
  static final pages = [
    GetPage(
      name: Routes.INITIAL,
      page: () => SplashPage(),
      transition: Transition.rightToLeftWithFade,
      binding: SplashBinding(),
    ),
    GetPage(
      name: Routes.CATEGORY,
      page: () => ProductsCategoryPage(),
      transition: Transition.rightToLeftWithFade,
    ),
    GetPage(
      name: Routes.PRODUCTS,
      page: () => ProductsPage(),
      transition: Transition.rightToLeftWithFade,
    ),
    GetPage(
      name: Routes.CUSTOMERS,
      page: () => CustomerPage(),
      transition: Transition.rightToLeftWithFade,
    ),
    GetPage(
      name: Routes.QUOTATIONS,
      page: () => QuotationsPage(),
      binding: QuotationsBinding(),
      transition: Transition.rightToLeftWithFade,
    ),
    GetPage(
      name: Routes.NEWQUOTATIONS,
      page: () => NewQuotationPage(),
      transition: Transition.rightToLeftWithFade,
    ),
    GetPage(
      name: Routes.PRODUCTSSEARCH,
      page: () => PorductSearchPage(),
      binding: ProductsSearchBinding(),
      transition: Transition.rightToLeftWithFade,
    ),
    GetPage(
      name: Routes.NEWPRODUCTS,
      page: () => NewProductPage(),
      transition: Transition.rightToLeftWithFade,
    ),
    GetPage(
      name: Routes.SHOPPACKAGE,
      page: () => ShopQuotationsPage(),
      transition: Transition.rightToLeftWithFade,
      binding: ShopQuotationsBinding(),
    ),
    GetPage(
      name: Routes.MYPACKAGE,
      page: () => MyPakagePage(),
      transition: Transition.rightToLeftWithFade,
      binding: MyPakageBinding(),
    ),
    GetPage(
      name: Routes.CREDITCARD,
      page: () => CreditcardPage(),
      transition: Transition.zoom,
      binding: CreeditCardBinding(),
    ),
    GetPage(
      name: Routes.HOME,
      page: () => HomePage(),
      transition: Transition.zoom,
      binding: HomeBinding(),
    ),
    GetPage(
      name: Routes.LOGIN,
      page: () => LoginPage(),
      transition: Transition.zoom,
      binding: LoginBinding(),
    ),
  ];
}
