import 'package:cloud_firestore/cloud_firestore.dart';

class Quiz {
  String? quizId;
  String? creatorId;
  String? title;
  List<String>? questions; // List of question IDs

  Quiz({
    this.quizId,
    this.creatorId,
    this.title,
    this.questions,
  });

  Quiz.fromSnapshot(DocumentSnapshot snapshot)
      : quizId = snapshot.id,
        creatorId = snapshot['creatorId'],
        title = snapshot['title'],
        questions = List<String>.from(snapshot['questions'] ?? []);

  Map<String, dynamic> toFirestore() {
    return {
      'creatorId': creatorId,
      'title': title,
      'questions': questions,
    };
  }
}
