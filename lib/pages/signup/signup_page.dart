import 'package:animate_do/animate_do.dart';
import 'package:cotizapack/common/button.dart';
import 'package:cotizapack/common/headerPaint.dart';
import 'package:cotizapack/common/socials.dart';
// import 'package:cotizapack/common/socials.dart';
import 'package:cotizapack/common/textfields.dart';
import 'package:cotizapack/common/validators.dart';
import 'package:cotizapack/pages/signup/signup_ctrl.dart';
import 'package:cotizapack/styles/colors.dart';
import 'package:cotizapack/styles/typography.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:line_icons/line_icons.dart';
import '../../styles/typography.dart';

class SignUpPage extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return GetBuilder<SignUpCtrl>(
      init: SignUpCtrl(),
      builder: (ctrl) {
        return Scaffold(
          backgroundColor: Colors.white,
          body: Form(
            key: _formKey,
            child: ListView(
              children: <Widget>[
                Header(
                    widgetToShow: Padding(
                        padding: EdgeInsets.only(top: 50, bottom: 140),
                        child: FadeInDown(
                            child:
                                Image.asset('assets/images/logo_white.png')))),
                SizedBox(
                  height: 10,
                ),
                new Text('Registrarme',
                    style: subtitulo, textAlign: TextAlign.center),
                SizedBox(
                  height: 15,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 32),
                  child: Column(
                    children: [
                      InputText(
                        name: 'Usuario',
                        textInputType: TextInputType.name,
                        validator: Validators.nameValidator,
                        prefixIcon: Icon(LineIcons.userPlus),
                        onChanged: (val) => ctrl.user.nickname = val,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      InputText(
                        name: 'Correo electrónico',
                        textInputType: TextInputType.emailAddress,
                        validator: Validators.emailValidator,
                        prefixIcon: Icon(LineIcons.envelope),
                        onChanged: (val) => ctrl.user.email = val,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Obx(() => InputText(
                            name: 'Contraseña',
                            textInputType: TextInputType.visiblePassword,
                            validator: Validators.passwordValidator,
                            autofillHints: [AutofillHints.password],
                            prefixIcon: Icon(LineIcons.lock),
                            suffixIcon: Material(
                              borderRadius: BorderRadius.circular(50),
                              child: IconButton(
                                splashRadius: 15,
                                icon: ctrl.viewPass.value
                                    ? Icon(LineIcons.eye)
                                    : Icon(LineIcons.eyeSlash),
                                onPressed: ctrl.viewPass.toggle,
                              ),
                            ),
                            maxLines: 1,
                            obscureText: ctrl.viewPass.value,
                            onChanged: (val) {
                              ctrl.user.password = val;
                              _formKey.currentState!.validate();
                            },
                          )),
                      SizedBox(
                        height: 25,
                      ),
                      Button(
                          function: () {
                            if (!_formKey.currentState!.validate()) {
                              return ctrl.btnController.reset();
                            }
                            ctrl.signup();
                          },
                          btnController: ctrl.btnController,
                          name: 'Registrarme'),
                      SizedBox(
                        height: 30,
                      ),
                      FadeInUp(
                        child: Column(
                          children: [
                            Text(
                              "- o registrate con - ",
                              style: body1,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            SocialNetwork(
                              facebookFunction: () => ctrl.loginWithFacebook(),
                              googleFunction: () => ctrl.loginWithGoogle(),
                            ),
                            SizedBox(
                              height: 30,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  "Ya tengo una cuenta ",
                                  style: body1,
                                ),
                                InkWell(
                                  onTap: () => Get.back(),
                                  child: Text("Iniciar sesión",
                                      style: TextStyle(
                                          color: color500,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 12,
                                          decoration:
                                              TextDecoration.underline)),
                                )
                              ],
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
