import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:trivia_2/model/User.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class UserService {
  final Users _user;
  UserService(this._user,this.userName);

  final FirebaseAuth _auth = FirebaseAuth.instance;
  late User currentUser;

  late final String userName;

  void getCurrentUser() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        currentUser = user;
        print(currentUser.email);
      }
    } catch (e) {
      print(e);
    }
  }

  final CollectionReference userCollection =
  FirebaseFirestore.instance.collection('users');

  Future getUserData() async {
    QuerySnapshot snapshot = await userCollection.where('uid', isEqualTo: currentUser.uid).get();
    return snapshot;
  }

  Future<String?> getUserField(String s)
  async {
    QuerySnapshot snapshot = await userCollection.where('uid', isEqualTo: currentUser.uid).get();
    Users.fromSnapshot(snapshot as DocumentSnapshot<Object?>);
    userName = _user.userName!;
    return null;
  }

  String getUserName()
  {
    return userName;
  }

  // Add Friend
  Future<void> addFriend(String userId, String friendId) async {
    await userCollection.doc(userId).update({
      'friends': FieldValue.arrayUnion([friendId]),
    });
  }

  // Remove Friend
  Future<void> removeFriend(String userId, String friendId) async {
    await userCollection.doc(userId).update({
      'friends': FieldValue.arrayRemove([friendId]),
    });
  }
}