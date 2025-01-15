import 'package:trivia_2/theme/model.dart';
import 'package:trivia_2/theme/util.dart';
import 'new_answer_widget.dart' show NewAnswerWidget;
import 'package:flutter/material.dart';

class NewAnswerModel extends MyAppModel<NewAnswerWidget> {
  ///  State fields for stateful widgets in this page.

  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode;
  TextEditingController? textController;
  String? Function(BuildContext, String?)? textControllerValidator;
  // State field(s) for CountController widget.
  int? countControllerValue;
  // State field(s) for Switch widget.
  bool? switchValue;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    textFieldFocusNode?.dispose();
    textController?.dispose();
  }
}
