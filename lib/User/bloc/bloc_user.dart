import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';
import 'package:trip_app/Place/repository/firebase_storage_repository.dart';
import 'package:trip_app/Place/ui/widgets/card_image.dart';
import 'package:trip_app/User/repository/auth_repository.dart';
import 'package:trip_app/User/repository/cloud_firestore_api.dart';
import 'package:trip_app/User/repository/cloud_firestore_repository.dart';
import 'package:trip_app/User/model/user.dart' as userModel;
import 'package:trip_app/User/ui/widgets/profile_place.dart';

import '../../Place/model/place.dart';

class UserBloc implements Bloc{

  final _auth_repository = AuthRepository();

  //Flujo de datos - Streams
  //Stream - Firebase
  //StreamController
  Stream<User> streamFirebase = FirebaseAuth.instance.authStateChanges();
  Stream<User> get authStatus => streamFirebase;
  //Future<User> get currentUser => FirebaseAuth.instance.currentUser;
  Future<User> currentUser() async {
    User user = FirebaseAuth.instance.currentUser;
    return user;
  }

  //Casos de uso
  //1. SignIn a la aplicación con Google
  Future<UserCredential> signIn(){
    return _auth_repository.signInFirebase();
  }

  //2. Registrar usuario en base de datos
  /*final _cloudFirestoreRepository = CloudFirestoreRepository();

  void updateUserData(userModel.User user) => _cloudFirestoreRepository.updateUserDataFirestore(user);

  Future<void> updatePlaceData(Place place) => _cloudFirestoreRepository.updatePlaceData(place);

  Stream<QuerySnapshot> placesListStream = FirebaseFirestore.instance.collection(CloudFirestoreAPI().PLACES).snapshots();

  Stream<QuerySnapshot> get placesStream => placesListStream;

  List<Place> buildPlaces(List<DocumentSnapshot> placesListSnapshot, userModel.User user) => _cloudFirestoreRepository.buildPlaces(placesListSnapshot,user);

  Stream<QuerySnapshot> myPlacesListStream(String uid) => FirebaseFirestore.instance.collection(CloudFirestoreAPI().PLACES).
    where('userOwner', isEqualTo: FirebaseFirestore.instance.document("${CloudFirestoreAPI().USERS}/${uid}")).snapshots();

  List<ProfilePlace> buildMyPlaces(List<DocumentSnapshot> placesListSnapshot) => _cloudFirestoreRepository.buildMyPlaces(placesListSnapshot);

  final _firebaseStorageRepository = FirebaseStorageRepository();

  Future<StorageUploadTask> uploadFile(String path, File image) => _firebaseStorageRepository.uploadFile(path, image);

  Future likePlace(Place place, String uid) => _cloudFirestoreRepository.likePlace(place,uid);

  StreamController<Place> placeSelectedStreamController =  StreamController<Place>();

  Stream<Place> get placeSelectedStream => placeSelectedStreamController.stream;

  StreamSink<Place> get placeSelectedSink =>  placeSelectedStreamController.sink;

  signOut(){
     _auth_repository.signOut();
  }*/






  final _cloudFirestoreRepository = CloudFirestoreRepository();
  void updateUserData(userModel.User user) => _cloudFirestoreRepository.updateUserDataFirestore(user);
  Future<void> updatePlaceData(Place place) => _cloudFirestoreRepository.updatePlaceData(place);
  Stream<QuerySnapshot> placesListStream = Firestore.instance.collection(CloudFirestoreAPI().PLACES).snapshots();
  Stream<QuerySnapshot> get placesStream => placesListStream;
  //List<CardImageWithFabIcon> buildPlaces(List<DocumentSnapshot> placesListSnapshot) => _cloudFirestoreRepository.buildPlaces(placesListSnapshot);
  List<Place> buildPlaces(List<DocumentSnapshot> placesListSnapshot, userModel.User user) => _cloudFirestoreRepository.buildPlaces(placesListSnapshot, user);
  Future likePlace(Place place, String uid) => _cloudFirestoreRepository.likePlace(place,uid);

  Stream<QuerySnapshot> myPlacesListStream(String uid) =>
      Firestore.instance.collection(CloudFirestoreAPI().PLACES)
          .where("userOwner", isEqualTo: Firestore.instance.document("${CloudFirestoreAPI().USERS}/${uid}"))
          .snapshots();
  List<ProfilePlace> buildMyPlaces(List<DocumentSnapshot> placesListSnapshot) => _cloudFirestoreRepository.buildMyPlaces(placesListSnapshot);

  StreamController<Place> placeSelectedStreamController =  StreamController<Place>();
  Stream<Place> get placeSelectedStream => placeSelectedStreamController.stream;
  StreamSink<Place> get placeSelectedSink =>  placeSelectedStreamController.sink;


  final _firebaseStorageRepository = FirebaseStorageRepository();
  Future<StorageUploadTask> uploadFile(String path, File image) => _firebaseStorageRepository.uploadFile(path, image);


  signOut() {
    _auth_repository.signOut();
  }

  @override
  void dispose() {
    // TODO: implement dispose
  }
}