import 'package:cloud_firestore/cloud_firestore.dart';

class Historyquiz {
  Timestamp date;
  String? quizId;
  String? quizTitle;
  int score;
  int totalQuestions;
  String? userId;


  Historyquiz({
    required this.date,
    this.quizId,
    this.quizTitle,
    required this.score,
    required this.totalQuestions,
    this.userId,
  });

  Historyquiz.fromSnapshot(DocumentSnapshot snapshot)
      : quizId = snapshot.id,
        userId = snapshot['userId'],
        score= snapshot['score'],
       date=snapshot['date'],
        totalQuestions=snapshot['totalQuestions'],
        quizTitle=snapshot['quizTitle'];

  Map<String, dynamic> toFirestore() {
    return {
      'date': date,
      'quizId': quizId,
      'quizTitle': quizTitle,
      'score':score,
      'totalQuestions':totalQuestions,
      'userId':userId,
    };
  }
}
