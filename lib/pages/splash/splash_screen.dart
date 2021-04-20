import 'package:animate_do/animate_do.dart';
import 'package:cotizapack/pages/splash/splash_ctrl.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

class SplashPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: SplashCtrl(),
      builder: (ctrl){
        return  Scaffold(
          body: new SafeArea(
            child: new Center(
              child: ZoomIn(
                child: Image.asset(
                  'assets/images/logo_colors.png',
                  width: 200,
                )
              ),
            )
          ),
        );
      });
  }
}