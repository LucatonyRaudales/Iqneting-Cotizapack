import 'package:flutter/material.dart';

class SocialNetwork extends StatelessWidget {
  final void Function() facebookFunction;

  final void Function() googleFunction;
  SocialNetwork(
      {Key? key, required this.facebookFunction, required this.googleFunction});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          // ignore: deprecated_member_use
          child: RaisedButton(
            child: Text("Facebook"),
            textColor: Colors.white,
            color: Colors.indigo,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(40)),
            ),
            onPressed: facebookFunction,
          ),
        ),
        SizedBox(
          width: 10.0,
        ),
        Expanded(
          // ignore: deprecated_member_use
          child: RaisedButton(
            child: Text("Google +"),
            textColor: Colors.white,
            color: Colors.red,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(40)),
            ),
            onPressed: googleFunction,
          ),
        ),
      ],
    );
  }
}
