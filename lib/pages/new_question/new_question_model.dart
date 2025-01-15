import 'package:trivia_2/theme/model.dart';
import 'package:trivia_2/theme/util.dart';
import 'new_question_widget.dart' show NewQuestionWidget;
import 'package:flutter/material.dart';

class NewQuestionModel extends MyAppModel<NewQuestionWidget> {
  ///  State fields for stateful widgets in this page.

  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode;
  TextEditingController? textController;
  String? Function(BuildContext, String?)? textControllerValidator;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    textFieldFocusNode?.dispose();
    textController?.dispose();
  }
}
