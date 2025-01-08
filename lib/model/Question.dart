import 'package:cloud_firestore/cloud_firestore.dart';

import 'Answer.dart';

class Question {
  String? questionId;
  String? quizId; // ID of the associated quiz
  String? questionText;
  List<Answer>? answers; // List of Answer objects

  Question({
    this.questionId,
    this.quizId,
    this.questionText,
    this.answers,
  });

  Question.fromSnapshot(DocumentSnapshot snapshot)
      : questionId=snapshot['questionId'],
        quizId=snapshot['quizId'],
        questionText=snapshot['questionText'],
        answers = List<Answer>.from(snapshot['answers'] ?? []);

  Map<String, dynamic> toFirestore() {
    return {
      if(quizId!=null)'quizId':quizId,
      if(questionId!=null)'questionId':questionId,
      if (questionText != null) 'questionText': questionText,
      if (answers != null) 'answers': answers
    };
  }
}
