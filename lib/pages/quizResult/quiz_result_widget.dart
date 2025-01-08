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
import 'package:trivia_2/pages/quizResult/quiz_result_model.dart';

class QuizResultWidget extends StatefulWidget {
  final int score;
  final int totalQuestions;
  final String quizTitle;

  const QuizResultWidget(
      {Key? key, required this.score, required this.totalQuestions, required this.quizTitle})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _QuizResultWidgetState();
}
  class _QuizResultWidgetState extends State<QuizResultWidget>{
    late QuizResultModel _model;
    late final int score=widget.score;
    late final int nrq=widget.totalQuestions;


    @override
    void initState() {
      super.initState();
      _model = createModel(context, () => QuizResultModel());
    }

    @override
    void dispose() {
      _model.dispose();
      super.dispose();
    }
    @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Results'),
          backgroundColor: const Color(0xFF1D5D8A),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                widget.quizTitle.toString(),
                style: const TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20.0),
              Text(
                'Score: $score / $nrq',
                style: const TextStyle(fontSize: 20.0),
              ),
              const SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: () {
                  context.pushNamed('Quizzes');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1D5D8A),
                ),
                child: const Text('Back to Quizzes'),
              ),
            ],
          ),
        ),
      );
    }
  }