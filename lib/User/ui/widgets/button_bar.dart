import 'dart:io';

import 'package:flutter/material.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:platzi_trips_app/Place/ui/screens/add_place_screen.dart';
import 'package:platzi_trips_app/User/bloc/bloc_user.dart';
import 'package:platzi_trips_app/User/ui/widgets/circle_button.dart';

class ButtonsBar extends StatelessWidget {
  UserBloc userBloc;

  @override
  Widget build(BuildContext context) {
    userBloc = BlocProvider.of(context);

    return Padding(
        padding: EdgeInsets.symmetric(horizontal: 0.0, vertical: 10.0),
        child: Row(
          children: <Widget>[
            // Cambiar contraseña:
            CircleButton(
              () => {},
              true,
              Icons.vpn_key,
              20.0,
              Color.fromRGBO(255, 255, 255, 0.6),
            ),
            //Añadir nuevo lugar:
            CircleButton(
              () {
                ImagePicker.pickImage(source: ImageSource.camera)
                    .then((File image) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) =>
                            AddPlaceScreen(image: image)),
                  );
                }).catchError((onError) => print(onError));
              },
              false,
              Icons.add,
              40.0,
              Color.fromRGBO(255, 255, 255, 1),
            ),
            //Cerrar sesion
            CircleButton(
              () => userBloc.signOut(),
              true,
              Icons.exit_to_app,
              20.0,
              Color.fromRGBO(255, 255, 255, 0.6),
            ),
          ],
        ));
  }
}
