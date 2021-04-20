import 'package:flutter/material.dart';

class SocialNetwork extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: RaisedButton(
            child: Text("Facebook"),
            textColor: Colors.white,
            color: Colors.indigo,
            shape: RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.all(Radius.circular(40)),
            ),
            onPressed: () {},
          ),
        ),
        SizedBox(
          width: 10.0,
        ),
        Expanded(
          child: RaisedButton(
            child: Text("Google +"),
            textColor: Colors.white,
            color: Colors.red,
            shape: RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.all(Radius.circular(40)),
            ),
            onPressed: () {},
          ),
        ),
      ],
    );
  }
}