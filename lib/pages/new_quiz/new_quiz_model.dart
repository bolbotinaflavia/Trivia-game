import 'package:trivia_2/theme/model.dart';
import 'package:trivia_2/theme/util.dart';
import 'new_quiz_widget.dart' show NewQuizWidget;
import 'package:flutter/material.dart';

class NewQuizModel extends MyAppModel<NewQuizWidget> {
  ///  State fields for stateful widgets in this page.

  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode;
  TextEditingController? textController;
  String? Function(BuildContext, String?)? textControllerValidator;
  // State field(s) for Switch widget.
  bool? switchValue1;
  // State field(s) for Switch widget.
  bool? switchValue2;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    textFieldFocusNode?.dispose();
    textController?.dispose();
  }
}
