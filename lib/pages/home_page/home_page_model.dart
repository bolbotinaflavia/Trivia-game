import 'package:trivia_2/theme/model.dart';
import 'package:trivia_2/theme/util.dart';
import 'home_page_widget.dart' show HomePageWidget;
import 'package:flutter/material.dart';

class HomePageModel extends MyAppModel<HomePageWidget> {
  ///  Local state fields for this page.

  bool? isDrawerOpen = false;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}

  /// Action blocks.
  Future openMenu(BuildContext context) async {
    await openMenu(context);
  }
}
