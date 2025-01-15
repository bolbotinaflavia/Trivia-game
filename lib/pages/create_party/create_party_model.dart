import 'package:trivia_2/theme/model.dart';
import 'package:trivia_2/theme/util.dart';
import 'create_party_widget.dart' show CreatePartyWidget;
import 'package:flutter/material.dart';

class CreatePartyModel extends MyAppModel<CreatePartyWidget> {
  ///  State fields for stateful widgets in this page.

  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode;
  TextEditingController? textController;
  String? Function(BuildContext, String?)? textControllerValidator;
  // State field(s) for Slider widget.
  double? sliderValue;
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
