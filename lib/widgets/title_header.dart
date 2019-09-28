import 'package:flutter/material.dart';

class TitleHeader extends StatelessWidget {
  String title;

  TitleHeader({
    Key key,
    @required this.title,
  });

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Flexible(
      child: Container(
        padding: EdgeInsets.only(top: 45,left: 20, right: 10),
        width: screenWidth,
        child: Text(
          title,
          style: TextStyle(
            color: Colors.white,
            fontFamily: "Lato",
            fontSize: 30.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
