import 'package:animate_do/animate_do.dart';
import 'package:cotizapack/pages/splash/splash_ctrl.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

class SplashPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetBuilder(
        init: SplashCtrl(),
        builder: (ctrl) {
          return Scaffold(
            backgroundColor: Colors.white,
            body: new SafeArea(
                child: new Center(
              child: ZoomIn(
                  //duration: Duration(milliseconds: 1000),
                  child: Image.asset('assets/gifs/cotizapackgif.gif')
                  //     Image.asset(
                  //   'assets/images/logo_colors.png',
                  //   width: 200,
                  // )
                  ),
            )),
          );
        });
  }
}
