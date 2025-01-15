import 'package:trivia_2/theme/model.dart';
import 'package:trivia_2/theme/util.dart';
import 'package:trivia_2/theme/controller.dart';
import 'create_custom_quiz_widget.dart' show CreateCustomQuizWidget;
import 'package:flutter/material.dart';

class CreateCustomQuizModel extends MyAppModel<CreateCustomQuizWidget> {
  ///  State fields for stateful widgets in this page.

  // State field(s) for DropDown widget.
  String? dropDownValue1;
  FormFieldController<String>? dropDownValueController1;
  // State field(s) for DropDown widget.
  String? dropDownValue2;
  FormFieldController<String>? dropDownValueController2;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
