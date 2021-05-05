import 'package:cotizapack/pages/pdf/pdg_viewer_ctrl.dart';
import 'package:cotizapack/pages/splash/splash_screen.dart';
import 'package:cotizapack/styles/colors.dart';
import 'package:cotizapack/styles/typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:get/get.dart';
import 'package:line_icons/line_icons.dart';

class PdfPreviewScreen extends StatelessWidget {
  final String path;

  PdfPreviewScreen({required this.path});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PDFCtrl>(
      init: PDFCtrl(),
      builder:(_ctrl)=> Scaffold(
        appBar: AppBar(
          backgroundColor: color500,
          centerTitle: true,
          title: new Text('Ver cotización', style: subtituloblanco),
          leading: new IconButton(icon: Icon(Icons.arrow_back_ios), onPressed: ()=> Get.off(SplashPage(), transition: Transition.rightToLeftWithFade)),
        ),
        floatingActionButton: FloatingActionButton(
          // isExtended: true,
          child: Icon(LineIcons.share, color: Colors.white,),
          backgroundColor: color500,
          onPressed: () {
            print('Compartir');
            _ctrl.sharePDF(context, path);
          },
        ),
        body: PDFView(
          filePath: path,
          enableSwipe: true,
          swipeHorizontal: true,
          autoSpacing: false,
          pageFling: false,
          onRender: (_pages) {
            /* setState(() {
                pages = _pages;
                isReady = true;
              });*/
          },
          onError: (error) {
              print(error.toString());
          },
          onPageError: (page, error) {
              print('$page: ${error.toString()}');
          },
          onViewCreated: (PDFViewController pdfViewController) {
             // _controller.complete(pdfViewController);
          },
          onPageChanged: (int? page, int? total) {
              print('page change: $page/$total');
          },
        ),
      ),
    );
  }
}