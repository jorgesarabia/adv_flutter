import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';
import 'package:platzi_trips_app/User/bloc/bloc_user.dart';
import 'package:platzi_trips_app/widgets/button_green.dart';
import 'package:platzi_trips_app/widgets/gradient_back.dart';

class SignInScreen extends StatefulWidget {
  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {

  UserBloc userBloc;

  @override
  Widget build(BuildContext context) {
    // Se declara desde el provider, ya que es un Singleton:
    userBloc = BlocProvider.of(context); 
    return signInGoogleUI();
  }

  Widget signInGoogleUI() {
    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          GradientBack("", null),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                "Welcome\nThis is your Travel App",
                style: TextStyle(
                  fontSize: 30.0,
                  fontFamily: "Lato",
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              ButtonGreen(
                onPressed: () {
                  userBloc.signIn().then((FirebaseUser user)=>print("El ususario es ${user.displayName}"));
                },
                title: "Login With Gmail",
                height: 50.0,
                width: 300.0,
              )
            ],
          )
        ],
      ),
    );
  }
}
