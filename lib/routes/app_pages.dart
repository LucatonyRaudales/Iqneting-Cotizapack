import 'package:cotizapack/bindings/duotations_binding.dart';
import 'package:cotizapack/bindings/products_search_binding.dart';
import 'package:cotizapack/pages/customer/customers/customers_page.dart';
import 'package:cotizapack/bindings/dashboard_binding.dart';
import 'package:cotizapack/bindings/duotations_binding.dart';
import 'package:cotizapack/bindings/products_search_binding.dart';
import 'package:cotizapack/bindings/shopquotations_binding.dart';
import 'package:cotizapack/common/location_picker.dart';
import 'package:cotizapack/pages/customer/customers/customers_page.dart';
import 'package:cotizapack/pages/login/login_page.dart';
import 'package:cotizapack/pages/product/new_product/new_product_page.dart';
import 'package:cotizapack/pages/product/product_category/product_categories_page.dart';
import 'package:cotizapack/pages/product/products/products_page.dart';
import 'package:cotizapack/pages/product/productssearch/products_search_page.dart';
import 'package:cotizapack/pages/quotation/new_quotation/new_quotation_page.dart';
import 'package:cotizapack/pages/quotation/quotations/quotations_page.dart';

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
      name: Routes.SHOPQUOTATIONS,
      page: () => ShopQuotationsPage(),
      transition: Transition.rightToLeftWithFade,
      binding: ShopQuotationsBinding(),
    ),
    GetPage(
      name: Routes.HOME,
      page: () => HomePage(),
      transition: Transition.rightToLeftWithFade,
      binding: DashboardBinding(),
    ),
    GetPage(
      name: Routes.LOGIN,
      page: () => LoginPage(),
      transition: Transition.rightToLeftWithFade,
      binding: DashboardBinding(),
    ),
  ];
}
