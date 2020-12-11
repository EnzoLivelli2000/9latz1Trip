import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../../Place/model/place.dart';
//import 'file:///C:/Users/Lenovo/AndroidStudioProjects/Flutter%20avanzado%20Platzi/trip_app/lib/Place/model/place.dart';
import 'profile_place_info.dart';
//import '../../../profile_place.dart'file_place.dart';
class ProfilePlace extends StatelessWidget {

  Place place;

  ProfilePlace(this.place);

  @override
  Widget build(BuildContext context) {

    final photoCard = Container(
      margin: EdgeInsets.only(
          top: 10.0,
          bottom: 70.0
      ),
      height: 220.0,
      decoration: BoxDecoration(
          image: DecorationImage(
              fit: BoxFit.cover,
              image: CachedNetworkImageProvider(place.urlImage),
          ),
          borderRadius: BorderRadius.all(Radius.circular(20.0)),
          color: Colors.red,
          boxShadow: <BoxShadow>[
            BoxShadow(
                color: Colors.black38,
                blurRadius: 10.0,
                offset: Offset(0.0, 5.0)
            )
          ]
      ),
    );

    return Stack(
      alignment: Alignment(0.0, 0.8),
      children: <Widget>[
        photoCard,
        ProfilePlaceInfo(place)
      ],
    );
  }

}
