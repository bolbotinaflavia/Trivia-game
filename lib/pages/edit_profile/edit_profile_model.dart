import 'package:trivia_2/theme/model.dart';
import 'package:trivia_2/theme/util.dart';
import 'edit_profile_widget.dart' show EditProfileWidget;
import 'package:flutter/material.dart';

class EditProfileModel extends MyAppModel<EditProfileWidget> {
  ///  State fields for stateful widgets in this page.

  // State field(s) for yourName widget.
  FocusNode? yourNameFocusNode1;
  TextEditingController? yourNameTextController1;
  String? Function(BuildContext, String?)? yourNameTextController1Validator;
  // State field(s) for myBio widget.
  FocusNode? myBioFocusNode;
  TextEditingController? myBioTextController;
  String? Function(BuildContext, String?)? myBioTextControllerValidator;
  // State field(s) for city widget.
  FocusNode? cityFocusNode;
  TextEditingController? cityTextController;
  String? Function(BuildContext, String?)? cityTextControllerValidator;
  // State field(s) for yourName widget.
  FocusNode? yourNameFocusNode2;
  TextEditingController? yourNameTextController2;
  String? Function(BuildContext, String?)? yourNameTextController2Validator;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    yourNameFocusNode1?.dispose();
    yourNameTextController1?.dispose();

    myBioFocusNode?.dispose();
    myBioTextController?.dispose();

    cityFocusNode?.dispose();
    cityTextController?.dispose();

    yourNameFocusNode2?.dispose();
    yourNameTextController2?.dispose();
  }
}
