import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:platzi_trips_app/Place/model/place.dart';
import 'package:platzi_trips_app/User/model/user.dart';

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
        'likes': place.likes,
        'userOwner': _db.document("$USERS/${user.uid}"), //reference
      }).then((DocumentReference dr){
        dr.get().then((DocumentSnapshot snapshot){
          var referencia = _db.document("$PLACES/${snapshot.documentID}");
          DocumentReference refUser = _db.collection(USERS).document(user.uid);
          refUser.updateData({
            'myPlaces': FieldValue.arrayUnion([referencia]),
          });
        });
      });
    });
  }
}
