import 'package:cotizapack/pages/product/products/products_ctrl.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../styles/colors.dart';
import '../../../styles/typography.dart';

class ProductsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProductsCtrl>(
      init: ProductsCtrl(),
      builder: (_ctrl) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: color500,
            centerTitle: true,
            title: new Text('Mis productos y servicios', style: subtituloblanco,),
          ),
          body: SafeArea(
            child: ListView.builder(
              itemCount: 10,
              itemBuilder: (context, index){
                return myCards;
              })),
        );
      },
    );
  }

  Widget myCards(){
    return Slidable(
      actionPane: SlidableDrawerActionPane(),
      actionExtentRatio: 0.25,
      child: Container(
        color: Colors.white,
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: Colors.indigoAccent,
            child: Text('$3'),
            foregroundColor: Colors.white,
          ),
          title: Text('Tile n°$3'),
          subtitle: Text('SlidableDrawerDelegate'),
        ),
      ),
      actions: <Widget>[
        IconSlideAction(
          caption: 'Archive',
          color: Colors.blue,
          icon: Icons.archive,
          onTap: () => _showSnackBar('Archive'),
        ),
        IconSlideAction(
          caption: 'Share',
          color: Colors.indigo,
          icon: Icons.share,
          onTap: () => _showSnackBar('Share'),
        ),
      ],
      secondaryActions: <Widget>[
        IconSlideAction(
          caption: 'More',
          color: Colors.black45,
          icon: Icons.more_horiz,
          onTap: () => _showSnackBar('More'),
        ),
        IconSlideAction(
          caption: 'Delete',
          color: Colors.red,
          icon: Icons.delete,
          onTap: () => _showSnackBar('Delete'),
        ),
      ],
    );
  }
}