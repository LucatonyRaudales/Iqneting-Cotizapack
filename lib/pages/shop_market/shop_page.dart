import 'package:cotizapack/pages/shop_market/shop_ctrl.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ShopQuotationsPage extends GetView<ShopQuotationsCtrl> {
  final List<Mycard> mycard = [
    Mycard(Icons.shopping_cart, 'Buying', true),
    Mycard(Icons.shop, 'Selling', false),
    Mycard(Icons.account_balance, 'Trades', true),
    Mycard(Icons.play_circle_outline, 'Videos', false),
    Mycard(Icons.people_outline, 'Deal', false),
    Mycard(Icons.bookmark_border, 'Case Study', false),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfff6f7f9),
      appBar: AppBar(
        title: Text('Vestimate'),
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Comprar un paquete',
              style: TextStyle(
                fontSize: 30,
                color: Colors.black54,
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                children: mycard.map((e) => myCard(e)).toList(),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget myCard(Mycard e) {
    return InkWell(
      onTap: () => print('holas'),
      child: Card(
        color: null,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              e.icon,
              size: 50,
              color: Colors.grey,
            ),
            SizedBox(height: 10),
            Text(
              "${e.title}",
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}

class Mycard {
  final icon;
  final title;
  bool isActive = false;

  Mycard(this.icon, this.title, this.isActive);
}
