import 'package:cloud_firestore/cloud_firestore.dart';

class Party {
  String? partyId;
  String? name;
  int? participants;//it saves the maximum number of participants
  //ids
  List<String>? users;
  String? photoUrl;
  bool remember;//if the party is saved by the user

  Party({
    this.partyId,
    this.name,
    this.participants,
    this.users,
    this.photoUrl,
    required this.remember
  });

  Party.fromSnapshot(DocumentSnapshot snapshot)
      : partyId=snapshot['partyId'],
        name = snapshot['name'],
        participants = snapshot['participants'],
        users = List<String>.from(snapshot['users'] ?? []),
        photoUrl=snapshot['photoUrl'],
        remember=snapshot['remember'];

  Map<String, dynamic> toFirestore() {
    return {
      if(partyId!=null) 'partyId':partyId,
      if (name != null) 'name': name,
      if (participants != null) 'participants': participants,
      if (users != null) 'users': users,
      if(photoUrl!=null)'photoUrl':photoUrl,
      if(remember!=null)'remember':remember
    };
  }
}
