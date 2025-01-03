import 'package:trivia_2/flutter_flow/choice_chips.dart';
import 'package:trivia_2/flutter_flow/icon_button.dart';
import 'package:trivia_2/flutter_flow/model.dart';
import 'package:trivia_2/flutter_flow/theme.dart';
import 'package:trivia_2/flutter_flow/util.dart';
import 'package:trivia_2/flutter_flow/widgets.dart';
import 'package:trivia_2/flutter_flow/controller.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'gameplay_model.dart';
export 'gameplay_model.dart';

class GameplayWidget extends StatefulWidget {
  const GameplayWidget({super.key});

  @override
  State<GameplayWidget> createState() => _GameplayWidgetState();
}

class _GameplayWidgetState extends State<GameplayWidget> {
  late GameplayModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => GameplayModel());
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: MyAppTheme.of(context).primaryBackground,
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            scaffoldKey.currentState!.openDrawer();
          },
          backgroundColor: Color(0xFF1D5D8A),
          elevation: 8.0,
          child: Icon(
            Icons.star,
            color: MyAppTheme.of(context).info,
            size: 24.0,
          ),
        ),
        drawer: Container(
          width: 300.0,
          child: Drawer(
            elevation: 16.0,
            child: Align(
              alignment: AlignmentDirectional(-1.0, -1.0),
              child: Container(
                height: 876.0,
                decoration: BoxDecoration(
                  color: Color(0xFF1D5D8A),
                ),
                child: Align(
                  alignment: AlignmentDirectional(0.0, 0.0),
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Opacity(
                          opacity: 0.0,
                          child: Divider(
                            height: 50.0,
                            thickness: 2.0,
                            color: MyAppTheme.of(context).alternate,
                          ),
                        ),
                        Text(
                          'Need help?',
                          style: MyAppTheme.of(context)
                              .headlineMedium
                              .override(
                                fontFamily: 'Readex Pro',
                                color: Color(0xFFBED5DA),
                                letterSpacing: 0.0,
                              ),
                        ),
                        Opacity(
                          opacity: 0.0,
                          child: Divider(
                            height: 50.0,
                            thickness: 2.0,
                            color: MyAppTheme.of(context).alternate,
                          ),
                        ),
                        FFButtonWidget(
                          onPressed: () {
                            print('Button pressed ...');
                          },
                          text: 'Half the answer(-20p)',
                          options: FFButtonOptions(
                            width: 300.0,
                            height: 40.0,
                            padding: EdgeInsetsDirectional.fromSTEB(
                                16.0, 0.0, 16.0, 0.0),
                            iconPadding: EdgeInsetsDirectional.fromSTEB(
                                0.0, 0.0, 0.0, 0.0),
                            color: Color(0xFF1D5D8A),
                            textStyle: MyAppTheme.of(context)
                                .titleSmall
                                .override(
                                  fontFamily: 'Inter',
                                  color: Colors.white,
                                  letterSpacing: 0.0,
                                ),
                            elevation: 0.0,
                            borderSide: BorderSide(
                              color: Color(0xFFBED5DA),
                              width: 1.0,
                            ),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                        FFButtonWidget(
                          onPressed: () {
                            print('Button pressed ...');
                          },
                          text: 'Hint',
                          options: FFButtonOptions(
                            width: 300.0,
                            height: 40.0,
                            padding: EdgeInsetsDirectional.fromSTEB(
                                16.0, 0.0, 16.0, 0.0),
                            iconPadding: EdgeInsetsDirectional.fromSTEB(
                                0.0, 0.0, 0.0, 0.0),
                            color: Color(0xFF1D5D8A),
                            textStyle: MyAppTheme.of(context)
                                .titleSmall
                                .override(
                                  fontFamily: 'Inter',
                                  color: Colors.white,
                                  letterSpacing: 0.0,
                                ),
                            elevation: 0.0,
                            borderSide: BorderSide(
                              color: Color(0xFFBED5DA),
                              width: 1.0,
                            ),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                      ].divide(SizedBox(height: 12.0)),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        body: SafeArea(
          top: true,
          child: Padding(
            padding: EdgeInsets.all(12.0),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Align(
                  alignment: AlignmentDirectional(1.0, -1.0),
                  child: MyAppIconButton(
                    borderRadius: 8.0,
                    borderWidth: 0.0,
                    buttonSize: 60.0,
                    fillColor: MyAppTheme.of(context).primaryBackground,
                    icon: Icon(
                      Icons.exit_to_app,
                      color: Colors.black,
                      size: 40.0,
                    ),
                    onPressed: () async {
                      context.pushNamed('Quizzes');
                    },
                  ),
                ),
                Divider(
                  height: 30.0,
                  thickness: 2.0,
                  color: MyAppTheme.of(context).primaryBackground,
                ),
                Align(
                  alignment: AlignmentDirectional(0.0, -1.0),
                  child: Container(
                    width: 355.0,
                    height: 40.0,
                    decoration: BoxDecoration(
                      color: Color(0xFFBED5DA),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Align(
                      alignment: AlignmentDirectional(0.0, 0.0),
                      child: Text(
                        'Question 1',
                        style: MyAppTheme.of(context).titleSmall.override(
                              fontFamily: 'Inter',
                              color: Colors.black,
                              letterSpacing: 0.0,
                            ),
                      ),
                    ),
                  ),
                ),
                Divider(
                  height: 30.0,
                  thickness: 2.0,
                  color: MyAppTheme.of(context).primaryBackground,
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Container(
                    width: 365.0,
                    height: 400.0,
                    decoration: BoxDecoration(
                      color: MyAppTheme.of(context).primaryBackground,
                    ),
                    child: Align(
                      alignment: AlignmentDirectional(0.0, -1.0),
                      child: ChoiceChips(
                        options: [
                          ChipData('A. Answer 1'),
                          ChipData('B. Answer 2'),
                          ChipData('C. Answer 3'),
                          ChipData('D. Answer 4')
                        ],
                        onChanged: (val) => safeSetState(
                            () => _model.choiceChipsValue = val?.firstOrNull),
                        selectedChipStyle: ChipStyle(
                          backgroundColor: Color(0xFF1D5D8A),
                          textStyle:
                          MyAppTheme.of(context).bodyMedium.override(
                                    fontFamily: 'Inter',
                                    color: MyAppTheme.of(context).info,
                                    fontSize: 16.0,
                                    letterSpacing: 0.0,
                                  ),
                          iconColor: MyAppTheme.of(context).info,
                          iconSize: 0.0,
                          labelPadding: EdgeInsets.all(10.0),
                          elevation: 0.0,
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        unselectedChipStyle: ChipStyle(
                          backgroundColor:
                          MyAppTheme.of(context).secondaryBackground,
                          textStyle: MyAppTheme.of(context)
                              .bodyMedium
                              .override(
                                fontFamily: 'Inter',
                                color:
                                MyAppTheme.of(context).secondaryText,
                                fontSize: 16.0,
                                letterSpacing: 0.0,
                              ),
                          iconColor: MyAppTheme.of(context).secondaryText,
                          iconSize: 0.0,
                          labelPadding: EdgeInsets.all(10.0),
                          elevation: 0.0,
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        chipSpacing: 100.0,
                        rowSpacing: 10.0,
                        multiselect: false,
                        alignment: WrapAlignment.center,
                        controller: _model.choiceChipsValueController ??=
                            FormFieldController<List<String>>(
                          [],
                        ),
                        wrapped: true,
                      ),
                    ),
                  ),
                ),
              ].divide(SizedBox(height: 12.0)),
            ),
          ),
        ),
      ),
    );
  }
}
