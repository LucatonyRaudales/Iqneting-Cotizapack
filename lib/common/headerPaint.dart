import 'package:flutter/material.dart';

import '../styles/colors.dart';
import 'WaveClippers.dart';

class Header extends StatelessWidget {
  final Widget widgetToShow;
  final double? height;
    Header({
    Key? key,
    required this.widgetToShow,
    this.height
    });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        ClipPath(
          clipper: WaveClipper2(),
          child: Container(
            child: Column(),
            width: double.infinity,
            height: height ?? 300,
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: [color400, color200])),
          ),
        ),
        ClipPath(
          clipper: WaveClipper3(),
          child: Container(
            child: Column(),
            width: double.infinity,
            height: height?? 300,
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: [color500, color300])),
          ),
        ),
        ClipPath(
          clipper: WaveClipper1(),
          child: Container(
            child: widgetToShow,
            width: double.infinity,
            height: height ?? 300,
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: [color700, color500])),
          ),
        ),
      ],
    );
  }
}