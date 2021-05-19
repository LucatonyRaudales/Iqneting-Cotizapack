import 'dart:typed_data';

import 'package:cotizapack/common/headerPaint.dart';
import 'package:cotizapack/pages/edit_my_data/edit_my_data_page.dart';
import 'package:cotizapack/pages/profile/profile_ctrl.dart';
import 'package:cotizapack/pages/shop_market/shop_page.dart';
import 'package:cotizapack/repository/storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:line_icons/line_icons.dart';
import '../../styles/colors.dart';
import '../../styles/typography.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return GetBuilder<ProfileCtrl>(
      init: ProfileCtrl(),
      builder:(_ctrl)=> Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        body: ListView(
          children: [
            Header(
              widgetToShow: Column(children: [
            const SizedBox(height: 30.0),
            Text('Mi perfil', style: tituloblanco,),
            const SizedBox(height: 20.0),
            Center(
              child: SizedBox(
                width: 100,
                height: 100,
                child: Stack(
                  children: [
                    Align(
                    alignment: Alignment.center,
                    child: CircleAvatar(
                      radius: 80,
                      backgroundColor: color300,
    //                backgroundColor: Color(0xff476cfb),
                      child: ClipOval(
                        child: new SizedBox(
                          width: 140.0,
                          height: 140.0,
                          child: _ctrl.userData.logo == null || _ctrl.userData.logo == '' ? 
                          Center(
                            child: Icon(LineIcons.plus)
                          ) : 
                          FutureBuilder<Uint8List>(
                            future: MyStorage().getFilePreview(
                              fileId: _ctrl.userData.logo.toString(),
                            ), //works for both public file and private file, for private files you need to be logged in
                            builder: (context, snapshot) {
                              return snapshot.hasError ?
                              Icon(LineIcons.exclamationCircle, color: Colors.red) : snapshot.hasData && snapshot.data != null
                                ? Image.memory(snapshot.data!
                                  )
                                : CircularProgressIndicator();
                            },
                          ),
                        ),
                      ),
                    )),
                    Align(
                      alignment: Alignment(1.5,1.5),
                      child: MaterialButton(
                        minWidth: 0,
                        child: Icon(Icons.camera_alt),
                        onPressed: ()=> _ctrl.updateImageProfile(),
                        textColor: Colors.white,
                        color: color400,
                        elevation: 0,
                        shape: CircleBorder(),
                      ),
                    )
                  ],
                ),
              ),
            ),
              ],),
            ),
            SizedBox(height: 30,),
            ListTile(
              title: Text(
                "Mi cuenta",
                style: subtitulo,
              ),
              subtitle: Column(
                children: [
                _ctrl.myAccount.email == null ?
                Padding(
                  padding: const EdgeInsets.symmetric(vertical:18.0),
                  child: SpinKitThreeBounce(
                    color: color500,
                    size: 20.0,
                  ),
                )
                :
              ListTile(
                title: Text(
                _ctrl.myAccount.email.toString(),
                style: body1,
              ),
            ),
            ListTile(
              title: Text(
                "Cambiar mi constraseña",
                style: body1,
              ),
              trailing: InkWell(
                onTap: ()=> _ctrl.updatePassword(context),
                child: Icon(LineIcons.cog, color: color700),
              )
            ),
              ],),
              leading: Icon(LineIcons.envelope, color: color700),
            ),
            _buildDivider(),
            SizedBox(height: 10,),
             ListTile(
              title: Text(
                "Cotizaciones",
                style: subtitulo,
              ),
              subtitle: InkWell(
                  onTap: ()=> Get.to(()=> ShopQuotationsPage(), transition: Transition.rightToLeftWithFade),
                  child: ListTile(
                title: Text(
                  "Comprar cotizaciones",
                  style: body1,
                ),
                trailing: Icon(LineIcons.arrowRight, color: color700),
                )
              ),
              leading: Icon(LineIcons.list, color: color700),
            ),
            /*SwitchListTile(
              value: true,
              title: Text("email notifications"),
              onChanged: (value) {},
              secondary: SizedBox(
                width: 10,
              ),
            ),
            SwitchListTile(
              value: false,
              title: Text("push notifications"),
              onChanged: (value) {},
              secondary: SizedBox(
                width: 10,
              ),
            ),*/
            _buildDivider(),
            _ctrl.updating ?
            Padding(
              padding: const EdgeInsets.symmetric(vertical:70.0),
              child: SpinKitThreeBounce(
                color: color500,
                size: 30.0,
              ),
            ) :
            _ctrl.userData.userID == "" ?
            Center(
              child: Column(children: [
                SizedBox(height: 25),
                new Text('Datos vacíos', style: subtitulo,),
                SizedBox(height: 15),
                ElevatedButton(
                  style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(color500)),
                  child: Text("Agregar mis datos", style: subtituloblanco),
                  onPressed:()=> Get.to(EditMyDataPage(), transition: Transition.rightToLeftWithFade, arguments: {"editData":false, "data": null}),
                ),
                SizedBox(height: 25),
              ],)
            ) :
            ListTile(
              title: Text(
                "Mi información",
                style: subtitulo,
              ),
              leading: Icon(LineIcons.userCheck, color: color700),
              trailing: InkWell(
                onTap: ()=> Get.to(EditMyDataPage(), transition: Transition.rightToLeftWithFade, arguments: {"editData":true, "data": _ctrl.userData}),
                child: Icon(LineIcons.cog, color: color700),
              ),
              subtitle: Column(
                children:[
                  ListTile(
                    title: Text(_ctrl.userData.ceoName!, style: body1),
                    leading:  Text("Nombre:", style: body2),
                  ),
                  ListTile(
                    title: Text(_ctrl.userData.businessName!, style: body1),
                    leading: Text("R. Social:", style: body2),
                  ),
                  ListTile(
                    title: Text(_ctrl.userData.address!, style: body1),
                    leading: Text("Dirección:", style: body2),
                  ),
                  ListTile(
                    title: Text(_ctrl.userData.phone!, style: body1),
                    leading: Text("Teléfono:", style: body2),
                  ),
                  ListTile(
                    title: Text(_ctrl.userData.category.name, style: body1),
                    leading: Text("Categoría:", style: body2),
                  ),
                  ListTile(
                    title: Text(_ctrl.userData.nickname!, style: body1),
                    leading: Text("Nick name:", style: body2),
                  ),
                ]
              ),
            ),
            /*RadioListTile(
              value: true,
              groupValue: true,
              title: Text("private"),
              onChanged: (value) {},
              secondary: SizedBox(
                width: 10,
              ),
              controlAffinity: ListTileControlAffinity.trailing,
            ),
            RadioListTile(
              value: false,
              groupValue: true,
              controlAffinity: ListTileControlAffinity.trailing,
              title: Text("public"),
              onChanged: (value) {},
              secondary: SizedBox(
                width: 10,
              ),
            ),*/
            _buildDivider(),
            ListTile(
              title: Text("Quejas o sugerencias", style: subtitulo),
              subtitle: Text(
                "Nos gustaría  saber tu opinión sobre COTIZA PACK para poder mejorar y ofrecerte un mejor servicio",
                style: body1
                ),
              leading: Icon(LineIcons.comment, color: color700,),
            ),
            ListTile(
              title: Text("Términos y condiciones", style: subtitulo),
              subtitle: Text("ver términos y condiciones de COTIZA PACK", style: body1, overflow: TextOverflow.ellipsis,),
              leading: Icon(LineIcons.fileContract, color: color700),
            ),
            InkWell(
              onTap: ()=> _ctrl.logout(),
              child: ListTile(
                title: Text("Salir", style: subtitulo,),
                subtitle: Text("presiona para cerrar sesión", style: body1,),
                leading: Icon(Icons.exit_to_app, color: color700),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Padding _buildDivider() {
    return Padding(
      padding: const EdgeInsets.only(left: 70),
      child: Divider(
        color: Colors.black,
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}