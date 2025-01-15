import 'package:trivia_2/theme/model.dart';
import 'package:trivia_2/theme/util.dart';
import 'package:trivia_2/theme/controller.dart';
import 'party_widget.dart' show PartyWidget;
import 'package:flutter/material.dart';

class PartyModel extends MyAppModel<PartyWidget> {
  ///  State fields for stateful widgets in this page.

  // State field(s) for ChoiceChips widget.
  FormFieldController<List<String>>? choiceChipsValueController;
  String? get choiceChipsValue =>
      choiceChipsValueController?.value?.firstOrNull;
  set choiceChipsValue(String? val) =>
      choiceChipsValueController?.value = val != null ? [val] : [];

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
