import 'package:trivia_2/theme/count_controller.dart';
import 'package:trivia_2/theme/model.dart';
import 'package:trivia_2/theme/theme.dart';
import 'package:trivia_2/theme/util.dart';
import 'package:flutter/material.dart';
import '../../reusables/menu.dart';
import 'new_answer_model.dart';
export 'new_answer_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NewAnswerWidget extends StatefulWidget {
  final String quizId;
  final String questionId;

  const NewAnswerWidget(
      {Key? key, required this.quizId, required this.questionId})
      : super(key: key);

  @override
  State<NewAnswerWidget> createState() => _NewAnswerWidgetState();
}

class _NewAnswerWidgetState extends State<NewAnswerWidget> {
  late NewAnswerModel _model;
  final TextEditingController answerController = TextEditingController();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  int priority = 0;
  bool isCorrect = false;

  @override
  void dispose() {
    answerController.dispose();
    super.dispose();
  }

  Future<void> _saveAnswer() async {
    final answerText = answerController.text.trim();

    if (answerText.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Answer text cannot be empty')),
      );
      return;
    }

    try {
      final answerCollection = FirebaseFirestore.instance.collection('answers');

      await answerCollection.add({
        'text': answerText,
        'priority': priority,
        'isCorrect': isCorrect,
        'questionId': widget.questionId,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Answer saved successfully')),
      );

      Navigator.pop(context); // Navigate back to the previous page
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error saving answer: $e')),
      );
    }
  }

  void initState() {
    super.initState();
    _model = createModel(context, () => NewAnswerModel());

    _model.textController ??= TextEditingController();
    _model.textFieldFocusNode ??= FocusNode();

    _model.switchValue = true;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: scaffoldKey, // Set the key here
        backgroundColor: MyAppTheme.of(context).primaryBackground,
        drawer: const CustomDrawer(), // Reusable menu
        appBar: AppBar(
          title: const Text('New Answer'),
          backgroundColor: const Color(0xFF1D5D8A),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Answer Text Field
              TextField(
                controller: answerController,
                decoration: const InputDecoration(
                  labelText: 'Answer Text',
                  border: OutlineInputBorder(),
                ),
                maxLines: 2,
              ),
              const SizedBox(height: 20),

              // Priority Counter
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    'Priority',
                    style: MyAppTheme.of(context).headlineSmall.override(
                          fontFamily: 'Readex Pro',
                          letterSpacing: 0.0,
                        ),
                  ),
                  Container(
                    width: 120.0,
                    height: 40.0,
                    decoration: BoxDecoration(
                      color: Color(0xFF1D5D8A),
                      borderRadius: BorderRadius.circular(8.0),
                      shape: BoxShape.rectangle,
                    ),
                    child: CountController(
                      decrementIconBuilder: (enabled) => Icon(
                        Icons.remove_rounded,
                        color: enabled
                            ? MyAppTheme.of(context).primaryBackground
                            : MyAppTheme.of(context).alternate,
                        size: 24.0,
                      ),
                      incrementIconBuilder: (enabled) => Icon(
                        Icons.add_rounded,
                        color: enabled
                            ? MyAppTheme.of(context).primaryBackground
                            : MyAppTheme.of(context).alternate,
                        size: 24.0,
                      ),
                      countBuilder: (count) => Text(
                        count.toString(),
                        style: MyAppTheme.of(context).titleLarge.override(
                              fontFamily: 'Readex Pro',
                              color: MyAppTheme.of(context).primaryBackground,
                              letterSpacing: 0.0,
                            ),
                      ),
                      count: _model.countControllerValue ??= 0,
                      updateCount: (count) => safeSetState(
                          () => _model.countControllerValue = count),
                      stepSize: 1,
                      contentPadding:
                          EdgeInsetsDirectional.fromSTEB(12.0, 0.0, 12.0, 0.0),
                      minValue: 2,
                      maxValue: 4,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Is Correct Switch
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Correct:'),
                  Switch(
                    value: isCorrect,
                    onChanged: (value) => setState(() => isCorrect = value),
                    activeColor: const Color(0xFF1D5D8A),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Save Button
              ElevatedButton(
                onPressed: _saveAnswer,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1D5D8A),
                  padding: const EdgeInsets.symmetric(
                      vertical: 12.0, horizontal: 20.0),
                  textStyle: const TextStyle(fontSize: 16.0),
                ),
                child: const Text('Save Answer'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
