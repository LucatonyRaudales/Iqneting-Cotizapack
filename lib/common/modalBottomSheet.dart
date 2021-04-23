import 'package:cotizapack/styles/colors.dart';
import 'package:flutter/material.dart';

class MyBottomSheet{
  void show(BuildContext ctx, double height, Widget content) {
      showModalBottomSheet(
        isScrollControlled: true,
        context: ctx,
        builder: (context) {
          return Container(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            height: height,
              child:content,
              decoration: BoxDecoration(
                color: color100,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(10),
                  topRight: const Radius.circular(10),
                ),
              ),
          );
        });
    /*showCupertinoModalPopup(
        context: ctx,
        builder: (_) => Container(
              width: Get.width,
              height: 250,
              child: CupertinoPicker(
                backgroundColor: CupertinoColors.white,
                itemExtent: 30,
                scrollController: FixedExtentScrollController(initialItem: 1),
                children: [
                  userCategories.categories!.isNotEmpty ?
                  ListView.builder(
                    itemCount: 2,
                    itemBuilder: (ctx, index){
                      return new Text(userCategories.categories![0].name, style: subtitulo,);
                    })
                    : new Center(
                      child: new Text('Cargando')
                    )
                ],
                onSelectedItemChanged: (value) {
                  print('categoría seleccionado: $value');
                },
              ),
            ));*/
  }
}