import 'package:flutter/material.dart';
import 'package:platzi_trips_app/Place/ui/widgets/card_image_with_fab_icon.dart';

class CardImageList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double width = 300.0;
    double height = 350.0;
    double left = 20.0;

    return Container(
      height: 350.0,
      child: ListView(
        padding: EdgeInsets.all(25.0),
        scrollDirection: Axis.horizontal,
        children: <Widget>[
          CardImageWithFabIcon(
            onPressedFabIcon: ()=>{},
            iconData: Icons.favorite_border,
            pathImage: "assets/img/beach_palm.jpeg",
            width: width,
            height: height,
            left: left,
          ),
          CardImageWithFabIcon(
            onPressedFabIcon: ()=>{},
            pathImage: "assets/img/mountain.jpeg",
            iconData: Icons.favorite_border,
            width: width,
            height: height,
            left: left,
          ),
          CardImageWithFabIcon(
            onPressedFabIcon: ()=>{},
            pathImage: "assets/img/mountain_stars.jpeg",
            iconData: Icons.favorite_border,
            width: width,
            height: height,
            left: left,
          ),
          CardImageWithFabIcon(
            onPressedFabIcon: ()=>{},
            pathImage: "assets/img/river.jpeg",
            iconData: Icons.favorite_border,
            width: width,
            height: height,
            left: left,
          ),
          CardImageWithFabIcon(
            onPressedFabIcon: ()=>{},
            pathImage: "assets/img/sunset.jpeg",
            iconData: Icons.favorite_border,
            width: width,
            height: height,
            left: left,
          ),
        ],
      ),
    );
  }
}
