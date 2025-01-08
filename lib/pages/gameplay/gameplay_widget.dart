import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:trivia_2/flutter_flow/choice_chips.dart';
import 'package:trivia_2/flutter_flow/icon_button.dart';
import 'package:trivia_2/flutter_flow/model.dart';
import 'package:trivia_2/flutter_flow/theme.dart';
import 'package:trivia_2/flutter_flow/util.dart';
import 'package:trivia_2/flutter_flow/widgets.dart';
import 'package:trivia_2/flutter_flow/controller.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../quizResult/quiz_result_widget.dart';
import 'gameplay_model.dart';
export 'gameplay_model.dart';

class GameplayWidget extends StatefulWidget {
  final String quizId;
  final String userId;
  final String quizTitle;
  const GameplayWidget(
      {super.key,
      required this.quizId,
      required this.userId,
      required this.quizTitle});

  @override
  State<GameplayWidget> createState() => _GameplayWidgetState();
}

class _GameplayWidgetState extends State<GameplayWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _offsetAnimation;
  late GameplayModel _model;

  int currentQuestionIndex = 0;
  int score = 0;
  List<QueryDocumentSnapshot> questions = [];
  bool isLoading = true;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => GameplayModel());
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

  void _nextQuestion(String selectedAnswer, String correctAnswer) {
    if (selectedAnswer == correctAnswer) {
      score++;
    }

    if (currentQuestionIndex < questions.length - 1) {
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
            floatingActionButton: FloatingActionButton(
              onPressed: () async {
                scaffoldKey.currentState!.openDrawer();
              },
              backgroundColor: Color(0xFF1D5D8A),
              elevation: 8.0,
              child: Icon(
                Icons.star,
                color: MyAppTheme.of(context).info,
                size: 24.0,
              ),
            ),
            drawer: Container(
              width: 300.0,
              child: Drawer(
                elevation: 16.0,
                child: Align(
                  alignment: AlignmentDirectional(-1.0, -1.0),
                  child: Container(
                    height: 876.0,
                    decoration: BoxDecoration(
                      color: Color(0xFF1D5D8A),
                    ),
                    child: Align(
                      alignment: AlignmentDirectional(0.0, 0.0),
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Opacity(
                              opacity: 0.0,
                              child: Divider(
                                height: 50.0,
                                thickness: 2.0,
                                color: MyAppTheme.of(context).alternate,
                              ),
                            ),
                            Text(
                              'Need help?',
                              style: MyAppTheme.of(context)
                                  .headlineMedium
                                  .override(
                                    fontFamily: 'Readex Pro',
                                    color: Color(0xFFBED5DA),
                                    letterSpacing: 0.0,
                                  ),
                            ),
                            Opacity(
                              opacity: 0.0,
                              child: Divider(
                                height: 50.0,
                                thickness: 2.0,
                                color: MyAppTheme.of(context).alternate,
                              ),
                            ),
                            FFButtonWidget(
                              onPressed: () {
                                print('Button pressed ...');
                              },
                              text: 'Half the answer(-20p)',
                              options: FFButtonOptions(
                                width: 300.0,
                                height: 40.0,
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    16.0, 0.0, 16.0, 0.0),
                                iconPadding: EdgeInsetsDirectional.fromSTEB(
                                    0.0, 0.0, 0.0, 0.0),
                                color: Color(0xFF1D5D8A),
                                textStyle:
                                    MyAppTheme.of(context).titleSmall.override(
                                          fontFamily: 'Inter',
                                          color: Colors.white,
                                          letterSpacing: 0.0,
                                        ),
                                elevation: 0.0,
                                borderSide: BorderSide(
                                  color: Color(0xFFBED5DA),
                                  width: 1.0,
                                ),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                            FFButtonWidget(
                              onPressed: () {
                                print('Button pressed ...');
                              },
                              text: 'Hint',
                              options: FFButtonOptions(
                                width: 300.0,
                                height: 40.0,
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    16.0, 0.0, 16.0, 0.0),
                                iconPadding: EdgeInsetsDirectional.fromSTEB(
                                    0.0, 0.0, 0.0, 0.0),
                                color: Color(0xFF1D5D8A),
                                textStyle:
                                    MyAppTheme.of(context).titleSmall.override(
                                          fontFamily: 'Inter',
                                          color: Colors.white,
                                          letterSpacing: 0.0,
                                        ),
                                elevation: 0.0,
                                borderSide: BorderSide(
                                  color: Color(0xFFBED5DA),
                                  width: 1.0,
                                ),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                          ].divide(SizedBox(height: 12.0)),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            body: SafeArea(
              top: true,
              child: Padding(
                padding: EdgeInsets.all(12.0),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Align(
                      alignment: AlignmentDirectional(1.0, -1.0),
                      child: MyAppIconButton(
                        borderRadius: 8.0,
                        borderWidth: 0.0,
                        buttonSize: 60.0,
                        fillColor: MyAppTheme.of(context).primaryBackground,
                        icon: Icon(
                          Icons.exit_to_app,
                          color: Colors.black,
                          size: 40.0,
                        ),
                        onPressed: () async {
                          context.pushNamed('Quizzes');
                        },
                      ),
                    ),
                    Divider(
                      height: 30.0,
                      thickness: 2.0,
                      color: MyAppTheme.of(context).primaryBackground,
                    ),
                    Align(
                      alignment: AlignmentDirectional(0.0, -1.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SlideTransition(
                            position: _offsetAnimation,
                            child: Text(
                              questionText,
                              style: const TextStyle(
                                  fontSize: 24.0, fontWeight: FontWeight.bold),
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
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const CircularProgressIndicator();
                                }

                                if (!snapshot.hasData ||
                                    snapshot.data!.docs.isEmpty) {
                                  return const Text('No answers available.');
                                }

                                final answers = snapshot.data!.docs;

                                return Column(
                                  children: answers.map((answerDoc) {
                                    final answerData = answerDoc.data() as Map<
                                        String,
                                        dynamic>;
                                    final answerText = answerData['text'] ??
                                        'No answer text';
                                    final isCorrect = answerData['isCorrect'] ??
                                        false;

                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 8.0),
                                      child: ElevatedButton(
                                        onPressed: () {
                                          _nextQuestion(answerText,
                                              isCorrect ? answerText : '');
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: const Color(
                                              0xFF1D5D8A),
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
                  ],
                ),
              ),
            )));
  }
}
