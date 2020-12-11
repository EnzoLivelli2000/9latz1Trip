import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';
import 'package:trip_app/User/bloc/bloc_user.dart';
import 'package:trip_app/widgets/button_green.dart';
import 'package:trip_app/widgets/gradient_back.dart';
import 'package:trip_app/platzi_trips_cupertino.dart';
import 'package:trip_app/User/model/user.dart' as userModel;

class SingInScreen extends StatefulWidget {
  @override
  _SingInScreenState createState() => _SingInScreenState();
}

class _SingInScreenState extends State<SingInScreen> {

  UserBloc userBloc;
  double screenWidth;

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    userBloc = BlocProvider.of(context);// con esto hacemos que esta variable sea accesible para toda la aplicación
    return _handleCurrentSession();
  }

  Widget _handleCurrentSession(){
    return StreamBuilder(
        stream: userBloc.authStatus,
        builder: (BuildContext context, AsyncSnapshot snapshot){
          if(!snapshot.hasData || snapshot.hasError){
            return singInGoogleUI();
          }else{
            return PlatziTripsCupertino();
          }
        },
    );
  }

  Widget singInGoogleUI(){
    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          GradientBack(height: null,),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Flexible(
                child: Container(
                  width: screenWidth,
                  child: Text(
                    " Bienvenido \n Esta es tu App de viajes ",
                    style: TextStyle(
                        fontSize: 37.0,
                        fontFamily: 'Lato',
                        color: Colors.white,
                        fontWeight: FontWeight.bold
                    ),
                  ),
                )
              ),
              ButtonGreen(
                text: 'Login With Gmail',
                onPressed: (){
                  //userBloc.signOut();
                  userBloc.signIn().then((UserCredential userC) => userBloc.updateUserData(userModel.User(
                    uid: userC.user.uid,
                    name: userC.user.displayName,
                    email: userC.user.email,
                    photoURL: userC.user.photoURL,
                  ))
                  ).catchError((e) => print('El error es -> ${e.toString()}'));
                },
                width: 300.0,
                height: 50.0,)
            ],
          )
        ],
      ),
    );
  }
}
