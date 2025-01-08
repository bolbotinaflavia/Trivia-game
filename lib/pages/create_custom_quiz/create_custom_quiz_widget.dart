import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:trivia_2/flutter_flow/drop_down.dart';
import 'package:trivia_2/flutter_flow/icon_button.dart';
import 'package:trivia_2/flutter_flow/model.dart';
import 'package:trivia_2/flutter_flow/theme.dart';
import 'package:trivia_2/flutter_flow/util.dart';
import 'package:trivia_2/flutter_flow/widgets.dart';
import 'package:trivia_2/flutter_flow/controller.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:trivia_2/pages/new_question/new_question_widget.dart';
import 'package:trivia_2/reusables/menu.dart';
import 'create_custom_quiz_model.dart';
export 'create_custom_quiz_model.dart';
import 'package:trivia_2/model/Question.dart';

class CreateCustomQuizWidget extends StatefulWidget {
  final String userId;
  final String quizTitle;
  final String quizId;
  const CreateCustomQuizWidget({Key? key, required this.quizTitle,required this.quizId, required this.userId}) : super(key: key);


  @override
  State<CreateCustomQuizWidget> createState() => _CreateCustomQuizWidgetState();
}

class _CreateCustomQuizWidgetState extends State<CreateCustomQuizWidget> {
  late CreateCustomQuizModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => CreateCustomQuizModel());
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: MyAppTheme
            .of(context)
            .primaryBackground,
        drawer: CustomDrawer(),
        appBar: AppBar(
          backgroundColor: Color(0xFF1D5D8A),
          automaticallyImplyLeading: false,
          leading: MyAppIconButton(
            borderColor: Colors.transparent,
            borderRadius: 8.0,
            buttonSize: 40.0,
            fillColor: Color(0xFF1D5D8A),
            icon: Icon(
              Icons.home_rounded,
              color: MyAppTheme
                  .of(context)
                  .info,
              size: 24.0,
            ),
            onPressed: () async {
              context.pushNamed('HomePage');
            },
          ),
          actions: [
            MyAppIconButton(
              borderColor: Colors.transparent,
              borderRadius: 8.0,
              buttonSize: 40.0,
              fillColor: Color(0xFF1D5D8A),
              icon: Icon(
                Icons.menu_rounded,
                color: MyAppTheme
                    .of(context)
                    .info,
                size: 24.0,
              ),
              onPressed: () async {
                scaffoldKey.currentState!.openDrawer();
              },
            ),
          ],
          centerTitle: false,
          elevation: 2.0,
        ),
        body: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.all(12.0),
                child: FFButtonWidget(
                  onPressed: () async {
                    final String questionId = FirebaseFirestore.instance
                        .collection('quizzes')
                        .doc()
                        .id; // Generate a unique ID
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            NewQuestionWidget(
                              quizId: widget.quizId, questionId: questionId,),
                      ),
                    );
                  },
                  text: 'New Question',
                  icon: const Icon(Icons.add_box, size: 15.0),
                  options: FFButtonOptions(
                    width: double.infinity,
                    height: 50.0,
                    color: const Color(0xFF1D5D8A),
                    textStyle: MyAppTheme
                        .of(context)
                        .titleSmall
                        .override(
                      fontFamily: 'Inter',
                      color: Colors.white,
                    ),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('questions')
                      .where('quizId', isEqualTo: widget.quizId)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    final questions = snapshot.data!.docs;

                    return ListView.builder(
                      padding: const EdgeInsets.all(12.0),
                      itemCount: questions.length,
                      itemBuilder: (context, index) {
                        final question = questions[index];
                        final questionData = question.data() as Map<String, dynamic>?;
                        final questionText = questionData?['text'] ?? 'No text available';

                        return ListTile(
                          title: Text(questionText),
                          trailing: StreamBuilder<QuerySnapshot>(
                            stream: FirebaseFirestore.instance
                                .collection('answers')
                                .where('questionId', isEqualTo: question.id)
                                .snapshots(),
                            builder: (context, answerSnapshot) {
                              if (!answerSnapshot.hasData) {
                                return const CircularProgressIndicator();
                              }

                              final answers = answerSnapshot.data!.docs;

                              if (answers.isEmpty) {
                                return const Text("No answers available");
                              }

                              return DropdownButton<String>(
                                items: answers.map<DropdownMenuItem<String>>((answerDoc) {
                                  final answerData = answerDoc.data() as Map<String, dynamic>;
                                  final answerText = answerData['text'] ?? 'No text';
                                  return DropdownMenuItem<String>(
                                    value: answerText,
                                    child: Text(answerText),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  print('Selected answer: $value');
                                },
                                hint: const Text("Select an answer"),
                              );
                            },
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
              FFButtonWidget(
                onPressed: () async {
                  context.pushNamed('Quizzes');
                },
                text: 'Next step',
                icon: Icon(
                  Icons.east,
                  size: 15.0,
                ),
                options: FFButtonOptions(
                  height: 40.0,
                  padding: EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0),
                  iconPadding: EdgeInsetsDirectional.fromSTEB(
                      0.0, 0.0, 0.0, 0.0),
                  color: Color(0xFF1D5D8A),
                  textStyle:
                  MyAppTheme
                      .of(context)
                      .titleSmall
                      .override(
                    fontFamily: 'Inter',
                    color: Colors.white,
                    letterSpacing: 0.0,
                  ),
                  elevation: 0.0,
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ].divide(SizedBox(height: 10.0)),
          ),
        ),
      ),
    );
  }
}