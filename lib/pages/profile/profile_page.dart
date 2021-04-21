import 'package:cotizapack/common/headerPaint.dart';
import 'package:cotizapack/pages/edit_my_data/edit_my_data_page.dart';
import 'package:cotizapack/pages/profile/profile_ctrl.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:line_icons/line_icons.dart';
import '../../styles/colors.dart';
import '../../styles/typography.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProfileCtrl>(
      init: ProfileCtrl(),
      builder:(_ctrl)=> Scaffold(
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
                      child:  Image.network(
                          "https://images.unsplash.com/photo-1502164980785-f8aa41d53611?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=500&q=60",
                          fit: BoxFit.fill,
                        ),
                    ),),
                    )),
                    Align(
                      alignment: Alignment(1.5,1.5),
                      child: MaterialButton(
                        minWidth: 0,
                        child: Icon(Icons.camera_alt),
                        onPressed: (){},
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
                "Mi cuenta (Premium)",
                style: subtitulo,
              ),
              subtitle: Column(children: [
              ListTile(
                title: Text(
                "tonyraudalesdev@iqneting.com.mx",
                style: body1,
              ),
            ),
            ListTile(
              title: Text(
                "Cambiar mi constraseña",
                style: body1,
              ),
              trailing: InkWell(
                onTap: ()=> print('cambiar mi constraseña'),
                child: Icon(LineIcons.cog, color: color700),
              )
            ),
              ],),
              leading: Icon(LineIcons.envelope, color: color700),
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
            ListTile(
              title: Text(
                "Mi información",
                style: subtitulo,
              ),
              leading: Icon(LineIcons.userCheck, color: color700),
              trailing: InkWell(
                onTap: ()=> Get.to(EditMyDataPage(), transition: Transition.rightToLeftWithFade),
                child: Icon(LineIcons.cog, color: color700),
              ),
              subtitle: Column(
                children:[
                  ListTile(
                    title: Text("Tony Roney", style: body1),
                    leading:  Text("Nombre(s):", style: body2),
                  ),
                  ListTile(
                    title: Text("34 años", style: body1),
                    leading: Text("Apellido(s):", style: body2),
                  ),
                  ListTile(
                    title: Text("34 años", style: body1),
                    leading: Text("Edad:", style: body2),
                  ),
                  ListTile(
                    title: Text("Tony es un golden boy", style: body1),
                    leading: Text("Descripción:", style: body2),
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
}