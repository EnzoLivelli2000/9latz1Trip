import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:trip_app/Place/ui/widgets/card_image.dart';
import 'package:trip_app/User/model/user.dart' as ModelUser;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:trip_app/User/ui/widgets/profile_place.dart';

import '../../Place/model/place.dart';

class CloudFirestoreAPI{
  final String USERS = 'users';
  final String PLACES = 'places';

  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  void updateUserData(ModelUser.User user) async{
    DocumentReference ref = _db.collection(USERS).doc(user.uid);
    return await ref.set({
      'uid' : user.uid,
      'name' : user.name,
      'email' : user.email,
      'photoURL' : user.photoURL,
      'myPlaces' : user.myPlaces,
      'myFavoritePlaces' : user.myFavoritePlaces,
      'lastSignIn' : DateTime.now()
    });
  }

  Future<void> updatePlaceData(Place place) async {
    CollectionReference refPlaces = _db.collection(PLACES);

    String uid = await _auth.currentUser.uid;

     await refPlaces.add({
       'name' : place.name,
       'description': place.description,
       'likes': place.likes,
       'urlImage': place.urlImage,
       'userOwner' : _db.doc('${USERS}/${uid}'),
     }).then((DocumentReference dr){
       dr.get().then((DocumentSnapshot snapshot){
         //snapshot.id; //ID place REFERENCIA ARRAY
         DocumentReference refUsers = _db.collection(USERS).doc(uid);
         refUsers.updateData({
           'myPlaces' : FieldValue.arrayUnion([_db.doc('${USERS}/${snapshot.id}')]),
         });
       });
     });
  }

  List<ProfilePlace> buildMyPlaces(List<DocumentSnapshot> placesListSnapshot){
    List<ProfilePlace> profilePlaces = List<ProfilePlace>();
    placesListSnapshot.forEach((p) {
      profilePlaces.add(ProfilePlace(
        Place(
          name: p.data()['name'],
          description: p.data()['description'],
          urlImage: p.data()['urlImage'],
          likes: p.data()['likes'],
        )
      ));
    });
    return profilePlaces;
  }

  List<Place> buildPlaces(List<DocumentSnapshot> placesListSnapshot, ModelUser.User user) {
    List<Place> places = List<Place>();

    placesListSnapshot.forEach((p)  {
      Place place = Place(id: p.documentID, name: p.data()["name"], description: p.data()["description"],
          urlImage: p.data()["urlImage"],likes: p.data()["likes"]
      );
      List usersLikedRefs =  p.data()["usersLiked"];
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
    await _db.collection(PLACES).document(place.id).get()
        .then((DocumentSnapshot ds){
      int likes = ds.data()["likes"];

      _db.collection(PLACES).document(place.id)
          .updateData({
        'likes': place.liked != null?likes+1:likes-1,
        'usersLiked':
        place.liked != null?
        FieldValue.arrayUnion([_db.document("${USERS}/${uid}")]):
        FieldValue.arrayRemove([_db.document("${USERS}/${uid}")])
      });


    });
  }
}