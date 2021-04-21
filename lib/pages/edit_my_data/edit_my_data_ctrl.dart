import 'package:cotizapack/common/categories.dart';
import 'package:cotizapack/repository/categories.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

class EditMyDataCtrl extends GetxController{
  final RoundedLoadingButtonController btnController = new RoundedLoadingButtonController();
  UserCategoryList userCategories = UserCategoryList();
  CategoriesRepository _categoriesRepository = CategoriesRepository();
  String info = 'edit my data';

  @override
  void onInit() {
    getUserCategories();
    print('Edit my data');
    super.onInit();
  }

  void editMyData()async{

  }

  void getUserCategories()async{
    try {
      _categoriesRepository.getCategories()
      .then((UserCategoryList value){
        userCategories = value;
        update();
      });
    } catch (e) {
    print('Error get Categories]: $e');
    }
  }

    void showPicker(BuildContext ctx) {
    showCupertinoModalPopup(
        context: ctx,
        builder: (_) => Container(
              width: 300,
              height: 250,
              child: CupertinoPicker(
                backgroundColor: CupertinoColors.white,
                itemExtent: 30,
                scrollController: FixedExtentScrollController(initialItem: 1),
                children: [
                  Text('0'),
                  Text('1'),
                  Text('2'),
                ],
                onSelectedItemChanged: (value) {
                  print('categoría seleccionado: $value');
                },
              ),
            ));
  }
}