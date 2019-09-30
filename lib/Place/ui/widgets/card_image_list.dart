import 'package:flutter/material.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';
import 'package:platzi_trips_app/Place/model/place.dart';
import 'package:platzi_trips_app/Place/ui/widgets/card_image_with_fab_icon.dart';
import 'package:platzi_trips_app/User/bloc/bloc_user.dart';
import 'package:platzi_trips_app/User/model/user.dart';

class CardImageList extends StatefulWidget {
  User user;
  CardImageList(@required this.user);

  @override
  _CardImageListState createState() => _CardImageListState();
}

class _CardImageListState extends State<CardImageList> {
  UserBloc userBloc;

  @override
  Widget build(BuildContext context) {
    userBloc = BlocProvider.of<UserBloc>(context);

    return Container(
      height: 350.0,
      child: StreamBuilder(
        stream: userBloc.placesStream,
        builder: (context, AsyncSnapshot snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
              return CircularProgressIndicator();
            case ConnectionState.waiting:
              return CircularProgressIndicator();
            case ConnectionState.active:
              return listViewPlaces(
                  userBloc.buildPlaces(snapshot.data.documents, widget.user));
            case ConnectionState.done:
              return listViewPlaces(
                  userBloc.buildPlaces(snapshot.data.documents, widget.user));
          }
        },
      ),
    );
  }

  Widget listViewPlaces(List<Place> places) {
    return ListView(
      padding: EdgeInsets.all(25.0),
      scrollDirection: Axis.horizontal,
      children: places.map((place) {
        return GestureDetector(
          onTap: () {
            print("Place ${place.name}");
            userBloc.placeSelectedSink.add(place);
          },
          child: CardImageWithFabIcon(
            pathImage: place.urlImage,
            width: 300.0,
            height: 250.0,
            left: 20.0,
            iconData: place.liked ? Icons.favorite : Icons.favorite_border,
            onPressedFabIcon: () {
              setLiked(place);
            },
            internet: true,
          ),
        );
      }).toList(),
    );
  }

  void setLiked(Place place) {
    setState(() {
      place.liked = !place.liked;
      userBloc.likePlace(place, widget.user.uid);
      place.likes = place.liked ? place.likes + 1 : place.likes - 1;
      userBloc.placeSelectedSink.add(place);
    });
  }
}
