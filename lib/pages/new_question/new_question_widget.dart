import 'package:trivia_2/flutter_flow/icon_button.dart';
import 'package:trivia_2/flutter_flow/model.dart';
import 'package:trivia_2/flutter_flow/theme.dart';
import 'package:trivia_2/flutter_flow/util.dart';
import 'package:trivia_2/flutter_flow/widgets.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:trivia_2/reusables/menu.dart';
import '../new_answer/new_answer_widget.dart';
import 'new_question_model.dart';
export 'new_question_model.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class NewQuestionWidget extends StatefulWidget {
  final String quizId;
  final String questionId;

  const NewQuestionWidget(
      {Key? key, required this.quizId, required this.questionId})
      : super(key: key);

  @override
  State<NewQuestionWidget> createState() => _NewQuestionWidgetState();
}

class _NewQuestionWidgetState extends State<NewQuestionWidget> {
  final TextEditingController questionTextController = TextEditingController();

  get scaffoldKey => GlobalKey<ScaffoldState>();
  @override
  void initState() {
    super.initState();
    _loadQuestionText();
  }

  Future<void> _loadQuestionText() async {
    try {
      final questionDoc = await FirebaseFirestore.instance
          .collection('questions')
          .doc(widget.questionId)
          .get();

      if (questionDoc.exists) {
        final data = questionDoc.data();
        questionTextController.text = data?['text'] ?? '';
      }
    } catch (e) {
      print('Error loading question text: $e');
    }
  }

  Future<void> _saveQuestionText() async {
    final text = questionTextController.text.trim();
    if (text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Question text cannot be empty')),
      );
      return;
    }

    try {
      final questionRef = FirebaseFirestore.instance
          .collection('questions')
          .doc(widget.questionId);

      await questionRef.set({
        'text': text,
        'quizId': widget.quizId, // Link the question to the quiz
      }, SetOptions(merge: true));

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Question saved successfully')),
      );
    } catch (e) {
      print('Error saving question text: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: MyAppTheme.of(context).primaryBackground,
        drawer: CustomDrawer(),
        appBar: AppBar(
          title: const Text('Edit Question'),
          backgroundColor: const Color(0xFF1D5D8A),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Text Field for Question
              TextField(
                controller: questionTextController,
                decoration: const InputDecoration(
                  labelText: 'Question Text',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 20),

              // Save Question Button
              ElevatedButton(
                onPressed: () async =>
                    {await _saveQuestionText(),
                      Navigator.pop(context)},
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1D5D8A),
                ),
                child: const Text('Save Question'),
              ),
              const SizedBox(height: 20),

              // Add New Answer Button
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => NewAnswerWidget(
                        quizId: widget.quizId,
                        questionId: widget.questionId,
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1D5D8A),
                ),
                child: const Text('Add New Answer'),
              ),
              const SizedBox(height: 20),
              // List of Answers
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('answers')
                      .where('questionId', isEqualTo: widget.questionId)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return const Center(child: Text('No answers found.'));
                    }

                    final answers = snapshot.data!.docs;

                    return ListView.builder(
                      itemCount: answers.length,
                      itemBuilder: (context, index) {
                        final answer = answers[index];
                        return Card(
                          child: ListTile(
                            title: Text(answer['text'] ?? 'No text'),
                            subtitle: Text(
                                'Priority: ${answer['priority']} | Correct: ${answer['isCorrect']}'),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
