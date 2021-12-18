import 'package:cotizapack/common/button.dart';
import 'package:cotizapack/common/headerPaint.dart';
import 'package:cotizapack/common/textfields.dart';
import 'package:cotizapack/common/validators.dart';
import 'package:cotizapack/pages/recovery_password/recovery_ctrl.dart';
import 'package:cotizapack/styles/colors.dart';
import 'package:cotizapack/styles/typography.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:im_stepper/stepper.dart';
import 'package:line_icons/line_icons.dart';

class RecoveryPasswordPage extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: GetBuilder<RecoveryCtrl>(
      init: RecoveryCtrl(),
      builder: (_ctrl) {
        return SafeArea(
            child: ListView(children: [
          Header(
            height: 200,
            widgetToShow:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              new Text(
                'Recuperar mi contraseña',
                style: subtituloblanco,
              ),
              SizedBox(height: 20),
              Obx(() => DotStepper(
                    dotCount: _ctrl.dotCount.value,
                    dotRadius: 12,
                    activeStep: _ctrl.activeStep.value,
                    shape: Shape.circle,
                    spacing: 10,
                    indicator: Indicator.jump,
                    tappingEnabled: false,
                    fixedDotDecoration: FixedDotDecoration(
                      color: color50,
                    ),
                    indicatorDecoration: IndicatorDecoration(
                      // style: PaintingStyle.stroke,
                      // strokeWidth: 8,
                      color: Colors.green,
                    ),
                    lineConnectorDecoration: LineConnectorDecoration(
                      color: Colors.red,
                      strokeWidth: 0,
                    ),
                  )),
              SizedBox(height: 70)
            ]),
          ),
          Obx(() => viewToShow(ctrl: _ctrl)),
          SizedBox(height: 20),
          TextButton.icon(
              onPressed: () => _ctrl.backButton(),
              icon: Icon(
                LineIcons.arrowLeft,
                color: color500,
              ),
              label: new Text(
                'Atrás',
                style: body1,
              ))
        ]));
      },
    ));
  }

  Widget viewToShow({required RecoveryCtrl ctrl}) {
    switch (ctrl.activeStep.value) {
      case 0:
        return createPasswordRecovery(ctrl: ctrl);
      case 1:
        return emailSend(ctrl: ctrl);
      // case 1:
      //   return messageContinuePasswordRecovery(ctrl:ctrl);
      // case 2:
      //   return completePasswordRecovery(ctrl: ctrl);
      default:
        return Text('dsadsa');
    }
  }

  Widget createPasswordRecovery({required RecoveryCtrl ctrl}) {
    return Form(
      key: _formKey,
      child:
          Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
        new Text(
          'Ingresa tu correo electrónico',
          style: subtitulo,
        ),
        SizedBox(
          height: 20,
        ),
        InputText(
          name: 'Correo electrónico',
          textInputType: TextInputType.emailAddress,
          validator: Validators.emailValidator,
          autofillHints: [AutofillHints.email],
          prefixIcon: Icon(LineIcons.envelope),
          obscureText: false,
          onChanged: (val) => ctrl.email = val,
        ),
        SizedBox(
          height: 35,
        ),
        Button(
            function: () {
              if (!_formKey.currentState!.validate()) {
                return ctrl.btnController.reset();
              }
              ctrl.sendEmail();
            },
            btnController: ctrl.btnController,
            name: 'Enviar código'),
      ]),
    );
  }

  Widget emailSend({required RecoveryCtrl ctrl}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 18.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          new Text(
            'Revisa tu buzón, te hemos enviado un correo',
            style: subtitulo,
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: 35,
          ),
          new Text(
              'Revise su correo para continuar con el proceso de cambio de contraseña',
              style: body1),
          SizedBox(
            height: 35,
          ),
          SizedBox(
            height: 35,
          ),
          Button(
            function: () {
              Get.back();
            },
            btnController: ctrl.btnController,
            name: 'Iniciar sesión',
          ),
        ],
      ),
    );
  }

  //   Widget messageContinuePasswordRecovery({required RecoveryCtrl ctrl}){
  //   return Form(
  //     key: _formKey,
  //     child: Padding(
  //       padding: const EdgeInsets.symmetric(horizontal:13, vertical:18.0),
  //       child: Column(
  //         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //           children:[
  //             new Text('Revisa tu buzón, te hemos enviado un correo', style: subtitulo, textAlign: TextAlign.center,),
  //             SizedBox(
  //               height: 10,
  //             ),
  //             new Text('copia y pega el contenido después de  &secret= (ejemplo: https://**********?userId=***********&secret="Código a pegar").\n Normalente será un código extenso', style: body1),

  //             SizedBox(
  //               height: 35,
  //             ),
  //                 SizedBox(
  //                   height: 20,
  //                 ),
  //                 InputText(
  //                   name: 'Código secreto',
  //                   textInputType: TextInputType.visiblePassword,
  //                   validator: Validators.nameValidator,
  //                   autofillHints: [AutofillHints.name],
  //                   prefixIcon: Icon(LineIcons.code),
  //                   obscureText: false,
  //                   onChanged: (val)=> ctrl.tokenReset.secret = val,
  //                 ),
  //                 SizedBox(
  //                   height: 35,
  //                 ),
  //                 Button(
  //                   function: (){
  //                     if (!_formKey.currentState!.validate()) {
  //                       return ctrl.btnController.reset();
  //                     }
  //                     ctrl.nextButton();
  //                   },
  //                   btnController: ctrl.btnController,
  //                   name: 'Verificar código'
  //                 ),
  //           ]
  //         ),
  //     ),
  //     );
  // }

  //   Widget completePasswordRecovery({required RecoveryCtrl ctrl}){
  //   return Form(
  //     key: _formKey,
  //     child: Column(
  //       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //         children:[
  //           new Text('Ingresa tu nueva contraseña', style: subtitulo,),

  //               SizedBox(
  //                 height: 20,
  //               ),
  //               InputText(
  //                 name: 'Nueva contraseña',
  //                 textInputType: TextInputType.visiblePassword,
  //                 validator: Validators.passwordValidator,
  //                 autofillHints: [AutofillHints.password],
  //                 prefixIcon: Icon(LineIcons.lock),
  //                 obscureText: false,
  //                 onChanged: (val)=> ctrl.newPassword1 = val,
  //               ),
  //               SizedBox(
  //                 height: 20,
  //               ),
  //               InputText(
  //                 name: 'Verifica la nueva contraseña',
  //                 textInputType: TextInputType.visiblePassword,
  //                 validator: Validators.passwordValidator,
  //                 autofillHints: [AutofillHints.password],
  //                 prefixIcon: Icon(LineIcons.lock),
  //                 obscureText: false,
  //                 onChanged: (val)=> ctrl.newPassword2 = val,
  //               ),
  //               SizedBox(
  //                 height: 35,
  //               ),
  //               Button(
  //                 function: (){
  //                   if (!_formKey.currentState!.validate()) {
  //                     return ctrl.btnController.reset();
  //                   }
  //                   ctrl.setRecoveryCode();
  //                 },
  //                 btnController: ctrl.btnController,
  //                 name: 'Actualizar contraseña'
  //               ),
  //         ]
  //       ),
  //     );
  // }
}
