import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:trivia_2/model/Quiz.dart';

class QuizService {
  final CollectionReference quizCollection =
  FirebaseFirestore.instance.collection('quizzes');

  // Add a Quiz
  Future<void> addQuiz(String quizId, Quiz quiz) async {
    await quizCollection.doc(quizId).set(quiz.toFirestore());
  }

  // Get Quiz by ID
  Future<Quiz?> getQuiz(String quizId) async {
    DocumentSnapshot snapshot = await quizCollection.doc(quizId).get();
    if (snapshot.exists) {
      return Quiz.fromSnapshot(snapshot);
    }
    return null;
  }

  // Add Question to Quiz
  Future<void> addQuestion(String quizId, String questionId) async {
    await quizCollection.doc(quizId).update({
      'questions': FieldValue.arrayUnion([questionId]),
    });
  }

  // Remove Question from Quiz
  Future<void> removeQuestion(String quizId, String questionId) async {
    await quizCollection.doc(quizId).update({
      'questions': FieldValue.arrayRemove([questionId]),
    });
  }
}
