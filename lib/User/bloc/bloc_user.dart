import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';
import 'package:platzi_trips_app/Place/model/place.dart';
import 'package:platzi_trips_app/Place/repository/firebase_storage_repository.dart';
import 'package:platzi_trips_app/Place/ui/widgets/card_image_with_fab_icon.dart';
import 'package:platzi_trips_app/User/model/user.dart';
import 'package:platzi_trips_app/User/repository/auth_repository.dart';
import 'package:platzi_trips_app/User/repository/cloud_firestore_api.dart';
import 'package:platzi_trips_app/User/repository/cloud_firestore_repository.dart';
import 'package:platzi_trips_app/User/ui/widgets/profile_place.dart';

class UserBloc implements Bloc {
  final _auth_repository = AuthRepository();

  // Flujo de datos - Streams
  // Streams - Firebase
  // StreamController
  Stream<FirebaseUser> streamFirebase =
      FirebaseAuth.instance.onAuthStateChanged;
  Stream<FirebaseUser> get authStatus => streamFirebase;
  Future<FirebaseUser> get currentUser => FirebaseAuth.instance.currentUser();

  // Casos de uso del objeto User:
  // 1. Sign In a la aplicación:
  Future<FirebaseUser> signIn() => _auth_repository.signInFirebase();
  signOut() => _auth_repository.signOut();

  // 2. Registrar usuario en base de datos:
  final _cloudFirestoreRepository = CloudFirestoreRepository();
  void updateUserData(User user) =>
      _cloudFirestoreRepository.updateUserDataFirestore(user);
  Future<void> updatePlaceData(Place place) =>
      _cloudFirestoreRepository.updatePlaceData(place);
  Stream<QuerySnapshot> placesListStream =
      Firestore.instance.collection(CloudFirestoreAPI().PLACES).snapshots();
  Stream<QuerySnapshot> get placesStream => placesListStream;
  List<Place> buildPlaces(List placesListSnapshot, User user) =>
      _cloudFirestoreRepository.buildPlaces(placesListSnapshot, user);
  Future likePlace(Place place, String uid) =>
      _cloudFirestoreRepository.likePlace(place, uid);

  Stream<QuerySnapshot> myPlacesListStream(String uid) => Firestore.instance
      .collection(CloudFirestoreAPI().PLACES)
      .where("userOwner",
          isEqualTo: Firestore.instance
              .document("${CloudFirestoreAPI().USERS}/${uid}"))
      .snapshots();
  List<ProfilePlace> buildMyPlaces(List<DocumentSnapshot> placesListSnapshot) =>
      _cloudFirestoreRepository.buildMyPlaces(placesListSnapshot);

  // 3. Cuando el usuario levanta un place:
  final FirebaseStorageRepository _firebaseStorageRepository =
      FirebaseStorageRepository();
  Future<StorageUploadTask> uploadFile(String path, File image) =>
      _firebaseStorageRepository.uploadFile(path, image);

  StreamController placeSelectedStreamController = StreamController();
  Stream get placeSelectedStream => placeSelectedStreamController.stream;
  StreamSink get placeSelectedSink => placeSelectedStreamController.sink;

  @override
  void dispose() {}
}
