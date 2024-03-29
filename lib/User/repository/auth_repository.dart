import 'package:firebase_auth/firebase_auth.dart';
import 'package:trip_app/User/repository/Firebase_auth_api.dart';

class AuthRepository{
  final _firebaseAuthAPI = FirebaseAuthAPI();
  Future<UserCredential> signInFirebase() => _firebaseAuthAPI.signIn();

  signOut() => _firebaseAuthAPI.signOut();
}