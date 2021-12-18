import 'package:cotizapack/pages/pdf/pdg_viewer_ctrl.dart';
import 'package:cotizapack/routes/app_pages.dart';
import 'package:cotizapack/styles/colors.dart';
import 'package:cotizapack/styles/typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:get/get.dart';
import 'package:line_icons/line_icons.dart';

class PdfPreviewScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<PDFCtrl>(
      init: PDFCtrl(),
      builder: (_ctrl) => WillPopScope(
        onWillPop: () {
          Get.offAllNamed(Routes.INITIAL);

          return Future.value(true);
        },
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: color500,
            centerTitle: true,
            title: new Text('Ver cotización', style: subtituloblanco),
            leading: new IconButton(
                icon: Icon(Icons.arrow_back_ios),
                onPressed: () => _ctrl.getBack(_ctrl.file!)),
          ),
          floatingActionButton: FloatingActionButton(
            // isExtended: true,
            child: Icon(
              LineIcons.share,
              color: Colors.white,
            ),
            backgroundColor: color500,
            onPressed: () {
              print('Compartir');
              _ctrl.sharePDF(context, _ctrl.file!);
            },
          ),
          body: PDFView(
            filePath: _ctrl.file!.path,
            enableSwipe: true,
            swipeHorizontal: true,
            autoSpacing: false,
            pageFling: false,
            onRender: (_pages) {
              print('renderizdo corretacemnte');
              /* setState(() {
                  pages = _pages;
                  isReady = true;
                });*/
            },
            onError: (error) {
              print('Error on render: $error');
            },
            onPageError: (page, error) {
              print('Error on onPageError: $error');
            },
            onViewCreated: (PDFViewController pdfViewController) {
              print('onViewCreated');
              // _controller.complete(pdfViewController);
            },
            onPageChanged: (int? page, int? total) {
              print('page change: $page/$total');
            },
          ),
        ),
      ),
    );
  }
}
