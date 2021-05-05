import 'package:animate_do/animate_do.dart';
import 'package:cotizapack/common/button.dart';
import 'package:cotizapack/common/headerPaint.dart';
import 'package:cotizapack/common/socials.dart';
import 'package:cotizapack/common/textfields.dart';
import 'package:cotizapack/common/validators.dart';
import 'package:cotizapack/pages/recovery_password/recovery_page.dart';
import 'package:cotizapack/pages/signup/signup_page.dart';
import 'package:cotizapack/styles/colors.dart';
import 'package:cotizapack/styles/typography.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:line_icons/line_icons.dart';
import 'login_ctrl.dart';

class LoginPage extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
 @override
  Widget build(BuildContext context) {
    return GetBuilder<LoginCtrl>(
      init: LoginCtrl(),
      builder: (_ctrl){
        return Scaffold(
          backgroundColor: Colors.white,
          body: Form(
            key: _formKey,
            child: ListView(
              children: <Widget>[
                Header(
                  widgetToShow: Padding(
                    padding: EdgeInsets.only(top: 50, bottom: 140),
                    child:FadeInDown(
                      child:Image.asset('assets/images/logo_white.png')
                    )
                  )
                ),
                SizedBox(
                  height: 10,
                ),
                new Text('Iniciar sesión', style: subtitulo, textAlign: TextAlign.center),
                SizedBox(
                  height: 15,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 32),
                  child: Column(
                    children:[

                    InputText(
                      name: 'Correo electrónico',
                      textInputType: TextInputType.emailAddress,
                      validator: Validators.emailValidator,
                      autofillHints: [AutofillHints.email],
                      prefixIcon: Icon(LineIcons.user),
                      onChanged: (val)=> _ctrl.user.email = val,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    InputText(
                      name: 'Contraseña',
                      textInputType: TextInputType.visiblePassword,
                      validator: Validators.passwordValidator,
                      autofillHints: [AutofillHints.password],
                      prefixIcon: Icon(LineIcons.lock),
                      obscureText: false,
                      onChanged: (val)=> _ctrl.user.password = val,
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    Button(
                      function: (){
                        if (!_formKey.currentState!.validate()) {
                          return _ctrl.btnController.reset();
                        }
                        _ctrl.signIn();
                      },
                      btnController: _ctrl.btnController,
                      name: 'Iniciar sesión'),
                        SizedBox(height: 20,),
                        FadeInUp(
                          child: Column(
                            children:[
                              Center(
                                child: TextButton(
                                  onPressed: ()=> Get.to(RecoveryPasswordPage(), transition: Transition.rightToLeftWithFade),
                                  child: Text("Olvidaste tu contraseña?", style: TextStyle(color:color300,fontSize: 12 ,fontWeight: FontWeight.w700),),
                                ),
                              ),
                              SizedBox(height: 20,),
                              SocialNetwork(),
                              SizedBox(height: 30,),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text("No tienes una cuenta? ", style: body1,),
                                  InkWell(
                                    onTap: ()=> Get.to(SignUpPage(), transition: Transition.rightToLeftWithFade),
                                    child: Text("Regístrate", style: TextStyle(color:color500, fontWeight: FontWeight.w500,fontSize: 12, decoration: TextDecoration.underline )),
                                  )
                                ],
                              ),
                            ]
                          ),
                        )
                  ]),
                ),
                SizedBox(height: 20,),
              ],
            ),
          ),
        );
      }
    );
  }
}
