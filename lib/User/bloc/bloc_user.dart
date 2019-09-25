import 'package:firebase_auth/firebase_auth.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';
import 'package:platzi_trips_app/User/repository/auth_repository.dart';

class UserBloc implements Bloc{
  final _auth_repository = AuthRepository();

  // Flujo de datos - Streams
  // Streams - Firebase
  // StreamController
   Stream<FirebaseUser> streamFirebase = FirebaseAuth.instance.onAuthStateChanged;
   Stream<FirebaseUser> get authStatus => streamFirebase;

  // Casos de uso del objeto User:
  // 1. Sign In a la aplicación:
  Future<FirebaseUser> signIn() => _auth_repository.signInFirebase();

  // Otro caso de uso es LogOut:
  signOut() => _auth_repository.signOut();

  @override
  void dispose() {
  }
}

