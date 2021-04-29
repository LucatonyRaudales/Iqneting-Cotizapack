import 'package:animate_do/animate_do.dart';
import 'package:cotizapack/common/modalBottomSheet.dart';
import 'package:cotizapack/model/customers.dart';
import 'package:cotizapack/pages/customer/customers/customers_ctrl.dart';
import 'package:cotizapack/pages/customer/new_customers/new_customer_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:line_icons/line_icons.dart';
import 'package:transparent_image/transparent_image.dart';
import '../../../styles/colors.dart';
import '../../../styles/typography.dart';

class CustomerPage extends StatelessWidget {

void showProductDetail(BuildContext context, CustomerModel customer){
    MyBottomSheet().show(context, Get.height/1.09, 
    ListView(
        children: <Widget>[
          InkWell(
            onTap: (){
              Navigator.pop(context);
            },
                      child: Padding(
              padding: EdgeInsets.only(left: 20),
                        child: Align(
                alignment: Alignment.centerLeft,
                child: Icon(Icons.arrow_back_ios)),
            ),
          ),
          Hero(
            tag: 'widget.id.toString()',
                      child: Container(
            width: Get.width,
            height: 250,
            decoration: BoxDecoration(
              image: DecorationImage(image: AssetImage('assets/images/logo_colors.png'),fit: BoxFit.fitHeight)
            ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 25),
            child:Column(children: [
          new Text(customer.name!, style: subtitulo),
          SizedBox(height: 10,),
          new Text(customer.notes!, style: body1),
            ],)
          ),
          InkWell(
            onTap: (){
              // your add cart function here
            },
              child: Padding(padding: EdgeInsets.only(left: 20,right: 20),
            child: Container(
              height: 50,
              width: double.infinity,
              decoration: BoxDecoration(
                color: primary,
                borderRadius: BorderRadius.circular(30)
              ),
              child: Center(
                child: Text("ADD TO CART",style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,

                ),),
              ),
            ),),
          )
        ],
      ),
    );
}

  @override
  Widget build(BuildContext context) {
  final spinkit = SpinKitPulse(
  color: color500,
  size: 50.0,
);
    return GetBuilder<CustomersCtrl>(
      init: CustomersCtrl(),
      builder: (_ctrl) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: color500,
            centerTitle: true,
            title: new Text('Mis clientes', style: subtituloblanco,),
          ),
          floatingActionButton: FloatingActionButton(
        // isExtended: true,
        child: Icon(Icons.add),
        backgroundColor: color500,
        onPressed: () {
          Get.to(NewCustomerPage(), transition: Transition.rightToLeftWithFade);
        },
      ),
          body: SafeArea(
            child: _ctrl.haveProducts == false ?
              Center(
                child:new Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children:[
                  new Icon(LineIcons.hushedFace, size: 50, color: color500),
                  SizedBox(height: 20,),
                  Text(
                  'No hay clientes para mostrar',
                  style: subtitulo,
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 12,),
                TextButton(
                  child: Text("Intentar de nuevo?", style: body1,),
                  onPressed:()=> _ctrl.getCustomers(),
                ),
                ])
              ) : 
              (_ctrl.customerList.customers == null || _ctrl.customerList.customers!.isEmpty) ?
              Center(
                child: spinkit 
              ) : RefreshIndicator(
              color: color700,
              onRefresh:_ctrl.getCustomers,
              child:  ListView.builder(
                itemCount:  _ctrl.customerList.customers!.length,
                itemBuilder: (context, index){
                  return myCards(customer: _ctrl.customerList.customers![index], index: index, context:context, ctrl:_ctrl);
                }),
            )),
        );
      },
    );
  }

  Widget myCards({required CustomerModel customer, required int index, required BuildContext context, required CustomersCtrl ctrl}){
    return FadeInLeft(
      delay: Duration(milliseconds: 200 * index),
      child: Slidable(
      actionPane: SlidableDrawerActionPane(),
      actionExtentRatio: 0.25,
      child: Container(
        child: Card(
          color: Colors.white,
          elevation: 4,
          child: InkWell(
          onTap: ()=> showProductDetail(context, customer),//Get.to(ProductDetail(), arguments: product),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: color200,
                child: FadeInImage.memoryNetwork(
                  fit: BoxFit.fill,
                  placeholder: kTransparentImage,
                  image: 'https://external-content.duckduckgo.com/iu/?u=http%3A%2F%2Fimg.bleacherreport.net%2Fimg%2Fimages%2Fphotos%2F002%2F197%2F187%2Frey_mysterio_wallpaper_by_regioart2012-d4xo2r3_crop_exact.jpg%3Fw%3D1200%26h%3D1200%26q%3D75&f=1&nofb=1',
                  ),
                foregroundColor: Colors.white,
              ),
              title: Text(customer.name.toString(), style: subtitulo, overflow: TextOverflow.ellipsis),
              subtitle: Text(customer.notes.toString(), style: body1, overflow: TextOverflow.ellipsis,),
              trailing: new Icon(Icons.arrow_forward_ios, size: 15),
            ),
          ),
        ),
      ),
      actions: <Widget>[
        IconSlideAction(
          caption: 'Editar',
          color: color500,
          icon: LineIcons.edit,
          onTap: () => print('Editar'),
        ),
      ],
      secondaryActions: <Widget>[
        IconSlideAction(
          caption: 'Eliminar',
          color: Colors.red,
          icon: Icons.delete,
          onTap: () => ctrl.deleteCustomer(customerID: customer.id!),
        ),
      ],
    )
    );
  }
}