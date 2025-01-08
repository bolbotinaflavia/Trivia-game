import 'package:flutter/material.dart';
import '../flutter_flow/theme.dart';
import '../model/Quiz.dart';

class QuizCard extends StatelessWidget {
  final Quiz quiz;
  final VoidCallback? onTap;

  const QuizCard({
    Key? key,
    required this.quiz,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8.0),
        decoration: BoxDecoration(
          color: const Color(0xFFBED5DA),
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: ListTile(
          title: Text(
            quiz.title ?? 'Untitled Quiz',
            style: MyAppTheme.of(context).titleSmall.override(
              fontFamily: 'Inter',
              color: Colors.black,
            ),
          ),
          subtitle: Text(
            "Quiz ID: ${quiz.quizId}",
            style: MyAppTheme.of(context).bodySmall.override(
              fontFamily: 'Inter',
              color: Colors.black54,
            ),
          ),
          trailing: const Icon(Icons.arrow_forward_ios),
        ),
      ),
    );
  }
}
