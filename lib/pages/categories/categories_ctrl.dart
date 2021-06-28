import 'dart:typed_data';

import 'package:cotizapack/model/Banner_Model.dart';
import 'package:cotizapack/model/user_data.dart';
import 'package:cotizapack/repository/storage.dart';
import 'package:cotizapack/repository/users.dart';
import 'package:flutter_card_swipper/flutter_card_swiper.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

class CategoriesCtrl extends GetxController {
  UsersRepository _usersRepository = UsersRepository();
  UserList userList = UserList();
  List<BannersModel> banners = <BannersModel>[];
  List<Uint8List> bannersImges = <Uint8List>[];
  SwiperController contSwiper = SwiperController();
  bool haveUsers = true;

  @override
  void onInit() {
    loadData();
    super.onInit();
  }

  SwiperController newController() {
    return contSwiper = SwiperController();
  }

  Future loadData() async {
    banners = <BannersModel>[];
    bannersImges = <Uint8List>[];
    _usersRepository.getUsers().then((value) {
      if (value.users!.isEmpty) {
        haveUsers = false;
        return update();
      }
      userList = value;
      getBanners();
      return update();
    });
  }

  Future getBanners() async {
    _usersRepository.getbanner().then((value) async {
      if (value!.isEmpty) {
        return update();
      }
      for (var banner in value) {
        var image = await MyStorage().getFilePreview(
          fileId: banner.image!,
        );
        bannersImges.add(image!);
      }
      banners = value;
      return update();
    });
  }

  @override
  void onClose() {
    contSwiper.dispose();
    super.onClose();
  }
}
