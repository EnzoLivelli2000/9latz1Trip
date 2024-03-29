import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';
import 'package:trip_app/Place/ui/widgets/card_image.dart';
import 'package:trip_app/Place/ui/widgets/title_input_location.dart';
import 'package:trip_app/User/bloc/bloc_user.dart';
import 'package:trip_app/widgets/button_purple.dart';
import 'package:trip_app/widgets/gradient_back.dart';
import 'package:trip_app/widgets/text_input.dart';
import 'package:trip_app/widgets/title_header.dart';

import '../../model/place.dart';

class AddPlaceScreen extends StatefulWidget {
  File image;

  AddPlaceScreen({Key key, this.image});

  @override
  _AddPlaceScreenState createState() => _AddPlaceScreenState();
}

class _AddPlaceScreenState extends State<AddPlaceScreen> {
  @override
  Widget build(BuildContext context) {

    UserBloc userBloc = BlocProvider.of<UserBloc>(context);
    final _controllerTitlePlace = TextEditingController();
    final _controllerDescriptionPlace = TextEditingController();

    return Scaffold(
      body: Stack(
        children: <Widget>[
          GradientBack(height: 300.0),
          Row(
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(top: 25, left: 5),
                child: SizedBox(
                  height: 45.0,
                  width: 45.0,
                  child: IconButton(
                    icon: Icon(
                      Icons.keyboard_arrow_left,
                      color: Colors.white,
                      size: 45,
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ),
              ),
              Flexible(
                  child: Container(
                      padding: EdgeInsets.only(top: 35, left: 20, right: 10),
                      child: TitleHeader(
                        title: 'Agrega un nuevo lugar',
                      ))),
            ],
          ),
          Container(
            margin: EdgeInsets.only(top: 120, bottom: 20),
            child: ListView(
              children: <Widget>[
                Container(
                  alignment: Alignment.center,
                  child: CardImageWithFabIcon(
                    pathImage: widget.image.path,
                    iconData: Icons.camera_alt,
                    width: 350.0,
                    height: 250.0,
                    left: 0,
                    internet: false,
                  ),
                ), // FOTO
                Container(  // TEXTFIELD TITLE
                  margin: EdgeInsets.only(top: 20.0, bottom: 20.0),
                  child: TextInput(
                    hintText: 'Title',
                    inputType: null,
                    maxLines: 1,
                    controller: _controllerTitlePlace,
                  )
                ),
                TextInput( //DESCRIPTION
                  hintText: 'Description',
                  inputType: TextInputType.multiline,
                  maxLines: 4,
                  controller: _controllerDescriptionPlace,
                ),
                Container(
                  margin: EdgeInsets.only(top: 20.0),
                  child: TextInputLocation(
                    hintText: 'Añade la localización',
                    iconData: Icons.location_on,
                  ),
                ),
                Container(
                  width: 70,
                  child: ButtonPurple(
                    buttonText:"Subir Lugar",
                    onPressed: (){
                      // ID del usuario actualmente
                      String uid;
                      String path;
                      userBloc.currentUser().then((User user) => {
                        if(user != null){
                          uid = user.uid,
                          path = "${uid}/${DateTime.now().toString()}.jpg",
                          //1. Firebase Storage
                          //   url
                          userBloc.uploadFile(path, widget.image).then((StorageUploadTask storageUploadTask){
                            storageUploadTask.onComplete.then((StorageTaskSnapshot snapshot){
                              snapshot.ref.getDownloadURL().then((urlImage){
                                  print('URL_IMAGE: ${urlImage}');

                                  //2. Cloud Firestore
                                  //   Place - title, description, url, userOwner, likes
                                  userBloc.updatePlaceData(Place(
                                    name: _controllerTitlePlace.text,
                                    description: _controllerDescriptionPlace.text,
                                    likes: 0,
                                    urlImage : urlImage,
                                  )).whenComplete(() {
                                    print('Proceso terminado');
                                    Navigator.pop(context);
                                  });

                              });
                            });
                          })
                        }
                      });
                    },
                  ),
                )
              ],
            )
          )
        ],
      ),
    );
  }
}
