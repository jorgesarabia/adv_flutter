import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:platzi_trips_app/Place/model/place.dart';
import 'package:platzi_trips_app/Place/ui/widgets/card_image_with_fab_icon.dart';
import 'package:platzi_trips_app/User/model/user.dart';
import 'package:platzi_trips_app/User/ui/widgets/profile_place.dart';

class CloudFirestoreAPI {
  // La parte mas alta de la colección:
  final String USERS = "users";
  final String PLACES = "places";

  final Firestore _db = Firestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  void updateUserData(User user) async {
    DocumentReference ref = _db.collection(USERS).document(user.uid);
    return ref.setData({
      'uid': user.uid,
      'name': user.name,
      'email': user.email,
      'photoURL': user.photoURL,
      'myPlaces': user.myPlaces,
      'myFavoritePlaces': user.myFavoritePlaces,
      'lastSignIn': DateTime.now(),
    }, merge: true);
  }

  Future<void> updatePlace(Place place) async {
    CollectionReference refPlace = _db.collection(PLACES);

    await _auth.currentUser().then((FirebaseUser user) {
      refPlace.add({
        'name': place.name,
        'description': place.description,
        'urlImage': place.urlImage,
        'likes': place.likes,
        'userOwner': _db.document("$USERS/${user.uid}"), //reference
      }).then((DocumentReference dr) {
        dr.get().then((DocumentSnapshot snapshot) {
          var referencia = _db.document("$PLACES/${snapshot.documentID}");
          DocumentReference refUser = _db.collection(USERS).document(user.uid);
          refUser.updateData({
            'myPlaces': FieldValue.arrayUnion([referencia]),
          });
        });
      });
    });
  }

  List<ProfilePlace> buildMyPlaces(List<DocumentSnapshot> placesListSnapshot) {
    List<ProfilePlace> profilePlaces = List<ProfilePlace>();

    placesListSnapshot.forEach((p) {
      profilePlaces.add(ProfilePlace(Place(
        name: p.data['name'],
        description: p.data['description'],
        urlImage: p.data['urlImage'],
        likes: p.data['likes'],
      )));
    });

    return profilePlaces;
  }

  List<Place> buildPlaces(List placesListSnapshot, User user) {
    List<Place> places = List<Place>();

    placesListSnapshot.forEach((p)  {
      Place place = Place(id: p.documentID, name: p.data["name"], description: p.data["description"],
          urlImage: p.data["urlImage"],likes: p.data["likes"]
      );
      List usersLikedRefs =  p.data["usersLiked"];
      place.liked = false;
      usersLikedRefs?.forEach((drUL){
        if(user.uid == drUL.documentID){
          place.liked = true;
        }
      });
      places.add(place);
    });
    return places;
  }

  Future likePlace(Place place, String uid) async {
    await _db
        .collection(PLACES)
        .document(place.id)
        .get()
        .then((DocumentSnapshot ds) {
      int likes = ds.data["likes"];
      _db.collection(PLACES).document(place.id).updateData({
        'likes': place.liked ? likes + 1 : likes - 1,
        'usersLiked': place.liked
            ? FieldValue.arrayUnion([_db.document("${USERS}/${uid}")])
            : FieldValue.arrayRemove([_db.document("${USERS}/${uid}")])
      });
    });
  }
}
