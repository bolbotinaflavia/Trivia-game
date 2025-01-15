import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:trivia_2/pages/authenticate/authenticate_widget.dart';
import '../pages/home_page/home_page_widget.dart';

class Authentication {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String? urlPath;
  String? userName;

  getDataImage() {
    final urlPath = this.urlPath;
    if (urlPath != null) {
      return urlPath.trim() ?? "";
    }
  }

  handleAuthState() {
    return StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (BuildContext context, snapshot) {
          if (snapshot.hasData) {
            return const HomePageWidget();
          } else {
            return const AuthenticateWidget();
          }
        });
  }
// StreamBuilder

  //sign in with google method

  Future<String?> getProfileImage() async {
    if (_auth.currentUser?.photoURL != null) {
      urlPath = _auth.currentUser!.photoURL!;
      return urlPath;
    } else {
      var uid = _auth.currentUser?.uid;
      var data =
      await FirebaseFirestore.instance.collection("users").doc(uid).get();
      urlPath = data['uploadedImage'];
      userName = data['userName'];
      print(data['uploadedImage']);
      print(urlPath);
      if (urlPath != null) {
        print("$_auth.currentUser?.email in authentification");
      } else {
        return "assets/homeowner.png";
      }
    }
    return urlPath;
  }

  Future<String?> getUserName() async {
    if (_auth.currentUser?.displayName != null) {
      userName = _auth.currentUser!.displayName!;
    } else {
      var uid = _auth.currentUser?.uid;
      var data =
      await FirebaseFirestore.instance.collection("users").doc(uid).get();
      userName = data['userName'];
      print(data['userName']);
      if (userName != null) {
        return userName;
        print("$_auth.currentUser?.email in authentification");
      } else {
        return "user";
      }
    }
    return "";
  }
}