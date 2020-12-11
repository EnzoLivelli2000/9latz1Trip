import 'package:flutter/material.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';
import 'package:trip_app/User/bloc/bloc_user.dart';
//import 'card_image.dart';
import 'package:trip_app/Place/ui/widgets/card_image.dart';
import 'package:trip_app/User/model/user.dart' as userModel;
//import '../../model/place.dart';
import 'package:trip_app/Place/model/place.dart';
import 'package:cached_network_image/cached_network_image.dart';

class CardImageList extends StatefulWidget {

  userModel.User user;

  CardImageList(@required this.user);

  @override
  _CardImageListState createState() => _CardImageListState();
}

class _CardImageListState extends State<CardImageList> {
  UserBloc userBloc;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    userBloc = BlocProvider.of<UserBloc>(context);

    return Container(
        height: 350.0,
        child: StreamBuilder(
            stream: userBloc.placesStream,
            builder: (context, AsyncSnapshot snapshot) {
              switch(snapshot.connectionState){
                case ConnectionState.waiting:
                  return CircularProgressIndicator();
                case ConnectionState.none:
                  return CircularProgressIndicator();
                case ConnectionState.active:
                  print("PLACESLIST: ACTIVE");
                  return listViewPlaces(userBloc.buildPlaces(snapshot.data.docs, widget.user));
                    //listViewPlaces(userBloc.buildPlaces(snapshot.data.docs));
                case ConnectionState.done:
                  print("PLACESLIST: DONE");
                  return listViewPlaces(userBloc.buildPlaces(snapshot.data.docs, widget.user));
                    //listViewPlaces(userBloc.buildPlaces(snapshot.data.docs));
              }
            },
        ),
        );
  }

  Widget listViewPlaces(List<Place> places){
    void setLiked(Place place){
      setState(() {
        place.liked = !place.liked;
        userBloc.likePlace(place, widget.user.uid);
        place.likes = place.liked?place.likes+1:place.likes-1;
        userBloc.placeSelectedSink.add(place);
      });
    }

    IconData iconDataLiked = Icons.favorite;
    IconData iconDataLike = Icons.favorite_border;

    return ListView(
      padding: EdgeInsets.all(25.0),
      scrollDirection: Axis.horizontal,
      children: places.map((place){
        return GestureDetector(
          onTap: (){
            print("CLICK PLACE: ${place.name}");
            userBloc.placeSelectedSink.add(place);
          },
          child: CardImageWithFabIcon(
            pathImage: place.urlImage,
            width: 300.0,
            height: 250.0,
            left: 20.0,
            iconData: place.liked?iconDataLiked:iconDataLike,
            onPressedFabIcon: (){
              setLiked(place);
            },
            internet: true,
          ),
        );
      }).toList(),
    );
  }
}
