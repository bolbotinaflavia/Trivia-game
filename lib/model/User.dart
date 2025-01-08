import 'package:cloud_firestore/cloud_firestore.dart';

class Users {
  String? userName;
  //saves the ids
  List<String>? friends;
  List<String>? quizzes;
  List<String>? partiesCreated;
  List<String>? partiesJoined;
  String? photoUrl;

  Users({
    this.userName,
    this.friends,
    this.quizzes,
    this.partiesCreated,
    this.partiesJoined,
    this.photoUrl,
  });

  Users.fromSnapshot(DocumentSnapshot snapshot)
      : userName = snapshot['userName'],
        friends = List<String>.from(snapshot['friends'] ?? []),
        quizzes = List<String>.from(snapshot['quizzes'] ?? []),
        partiesCreated = List<String>.from(snapshot['partiesCreated'] ?? []),
        partiesJoined = List<String>.from(snapshot['partiesJoined'] ?? []),
        photoUrl=snapshot['photoUrl'];

  Map<String, dynamic> toFirestore() {
    return {
      if (userName != null) 'userName': userName,
      if (friends != null) 'friends': friends,
      if (quizzes != null) 'quizzes': quizzes,
      if (partiesCreated != null) 'partiesCreated': partiesCreated,
      if (partiesJoined != null) 'partiesJoined': partiesJoined,
      if(photoUrl!=null)'photoUrl':photoUrl,
    };
  }
}
