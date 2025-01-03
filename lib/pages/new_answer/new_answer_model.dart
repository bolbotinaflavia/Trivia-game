import 'package:trivia_2/flutter_flow/model.dart';

import 'package:trivia_2/flutter_flow/count_controller.dart';
import 'package:trivia_2/flutter_flow/icon_button.dart';
import 'package:trivia_2/flutter_flow/theme.dart';
import 'package:trivia_2/flutter_flow/util.dart';
import 'package:trivia_2/flutter_flow/widgets.dart';
import 'new_answer_widget.dart' show NewAnswerWidget;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

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
