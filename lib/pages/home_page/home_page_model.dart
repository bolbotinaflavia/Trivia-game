import 'package:trivia_2/flutter_flow/model.dart';

import 'package:trivia_2/flutter_flow/icon_button.dart';
import 'package:trivia_2/flutter_flow/theme.dart';
import 'package:trivia_2/flutter_flow/util.dart';
import 'package:trivia_2/flutter_flow/widgets.dart';
import 'home_page_widget.dart' show HomePageWidget;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

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
