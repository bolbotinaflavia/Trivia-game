import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:trivia_2/model/Party.dart';

class PartyService {
  final CollectionReference partyCollection =
  FirebaseFirestore.instance.collection('parties');

  // Add a Party
  Future<void> addParty(String partyId, Party party) async {
    await partyCollection.doc(partyId).set(party.toFirestore());
  }

  // Join a Party
  Future<void> joinParty(String partyId, String userId) async {
    await partyCollection.doc(partyId).update({
      'participants': FieldValue.arrayUnion([userId]),
    });
  }

  // Leave a Party
  Future<void> leaveParty(String partyId, String userId) async {
    await partyCollection.doc(partyId).update({
      'participants': FieldValue.arrayRemove([userId]),
    });
  }
}
