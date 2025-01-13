import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:trivia_2/flutter_flow/theme.dart';
import 'package:trivia_2/flutter_flow/widgets.dart';
import '../quizResult/quiz_result_widget.dart';
import 'gameplay_party_model.dart';

class GameplayPartyWidget extends StatefulWidget {
  final String quizId;
  final String partyId;
  final String userId;
  final String quizTitle;

  const GameplayPartyWidget({
    super.key,
    required this.quizId,
    required this.userId,
    required this.quizTitle,
    required this.partyId,
  });

  @override
  State<GameplayPartyWidget> createState() => _GameplayPartyWidgetState();
}

class _GameplayPartyWidgetState extends State<GameplayPartyWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _offsetAnimation;
  late GameplayPartyModel _model;

  int currentQuestionIndex = 0;
  int score = 0;
  List<QueryDocumentSnapshot> questions = [];
  bool isLoading = true;

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = GameplayPartyModel();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _offsetAnimation =
        Tween<Offset>(begin: const Offset(1.0, 0.0), end: Offset.zero)
            .animate(_controller);

    _loadQuestions();
  }

  Future<void> _loadQuestions() async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('questions')
        .where('quizId', isEqualTo: widget.quizId)
        .get();

    setState(() {
      questions = querySnapshot.docs;
      isLoading = false;
    });

    _controller.forward(); // Start animation for the first question.
  }

  void _nextQuestion(String selectedAnswer, String correctAnswer) async {
    if (selectedAnswer == correctAnswer) {
      score++;
    }

    if (currentQuestionIndex < questions.length - 1) {
      // Show scoreboard before moving to the next question.
      await _showScoreboard();

      setState(() {
        _controller.reset();
        currentQuestionIndex++;
        _controller.forward();
      });
    } else {
      _saveQuizResult();
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => QuizResultWidget(
              score: score,
              totalQuestions: questions.length,
              quizTitle: widget.quizTitle),
        ),
      );
    }
  }

  Future<void> _showScoreboard() async {
    try {
      // Fetch party document
      final partyDoc = await FirebaseFirestore.instance
          .collection('parties')
          .doc(widget.partyId)
          .get();

      final users = partyDoc['users'] ?? [];

      // Map user IDs to Future and wait for all to resolve
      final scores = await Future.wait(users.map((userId) async {
        // Fetch quiz history for this user and quiz
        final historyQuery = await FirebaseFirestore.instance
            .collection('quizHistory')
            .where('userId', isEqualTo: userId)
            .where('quizId', isEqualTo: widget.quizId)
            .get();

        final userScore = historyQuery.docs.isNotEmpty
            ? historyQuery.docs.first['score']
            : 0;

        // Fetch user name
        final userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .get();

        final userName = userDoc['userName'] ?? 'Unknown';

        return {'name': userName, 'score': userScore};
      }));

      // Show scoreboard dialog
      await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Scoreboard"),
            content: SizedBox(
              width: double.maxFinite,
              child: ListView(
                shrinkWrap: true,
                children: scores.map((entry) {
                  return ListTile(
                    title: Text(entry['name']),
                    trailing: Text('${entry['score']}'),
                  );
                }).toList(),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text("Next Question"),
              ),
            ],
          );
        },
      );
    } catch (e) {
      print('Error in showing scoreboard: $e');
    }
  }

  Future<void> _saveQuizResult() async {
    final historyRef = FirebaseFirestore.instance.collection('quizHistory');

    await historyRef.add({
      'userId': widget.userId,
      'quizId': widget.quizId,
      'quizTitle': widget.quizTitle,
      'score': score,
      'totalQuestions': questions.length,
      'date': DateTime.now(),
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _model.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final question = questions[currentQuestionIndex];
    final questionData = question.data() as Map<String, dynamic>;
    final questionText = questionData['text'] ?? 'No question text available';

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: MyAppTheme.of(context).primaryBackground,
        body: SafeArea(
          top: true,
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SlideTransition(
                  position: _offsetAnimation,
                  child: Text(
                    questionText,
                    style: const TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 20),
                StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('answers')
                      .where('questionId', isEqualTo: question.id)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    }

                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return const Text('No answers available.');
                    }

                    final answers = snapshot.data!.docs;

                    return Column(
                      children: answers.map((answerDoc) {
                        final answerData =
                        answerDoc.data() as Map<String, dynamic>;
                        final answerText = answerData['text'] ?? 'No answer text';
                        final isCorrect = answerData['isCorrect'] ?? false;

                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: ElevatedButton(
                            onPressed: () {
                              _nextQuestion(answerText,
                                  isCorrect ? answerText : '');
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF1D5D8A),
                            ),
                            child: Text(answerText),
                          ),
                        );
                      }).toList(),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
