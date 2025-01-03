import 'package:trivia_2/flutter_flow/choice_chips.dart';
import 'package:trivia_2/flutter_flow/icon_button.dart';
import 'package:trivia_2/flutter_flow/model.dart';
import 'package:trivia_2/flutter_flow/theme.dart';
import 'package:trivia_2/flutter_flow/util.dart';
import 'package:trivia_2/flutter_flow/widgets.dart';
import 'package:trivia_2/flutter_flow/controller.dart';
import 'package:barcode_widget/barcode_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'new_party_model.dart';
export 'new_party_model.dart';

class NewPartyWidget extends StatefulWidget {
  const NewPartyWidget({super.key});

  @override
  State<NewPartyWidget> createState() => _NewPartyWidgetState();
}

class _NewPartyWidgetState extends State<NewPartyWidget> {
  late NewPartyModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => NewPartyModel());
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
                      FFButtonWidget(
                        onPressed: () async {
                          context.pushNamed('Profile');
                        },
                        text: 'Profile',
                        options: FFButtonOptions(
                          width: 300.0,
                          height: 40.0,
                          padding: EdgeInsetsDirectional.fromSTEB(
                              16.0, 0.0, 16.0, 0.0),
                          iconPadding: EdgeInsetsDirectional.fromSTEB(
                              0.0, 0.0, 0.0, 0.0),
                          color: Color(0xFF1D5D8A),
                          textStyle:
                          MyAppTheme.of(context).titleSmall.override(
                                    fontFamily: 'Inter',
                                    color: Colors.white,
                                    letterSpacing: 0.0,
                                  ),
                          elevation: 0.0,
                          borderSide: BorderSide(
                            color: Color(0xFF0D5A8E),
                            width: 1.0,
                          ),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      FFButtonWidget(
                        onPressed: () async {
                          context.pushNamed('Quizzes');
                        },
                        text: 'Quizzes',
                        options: FFButtonOptions(
                          width: 300.0,
                          height: 40.0,
                          padding: EdgeInsetsDirectional.fromSTEB(
                              16.0, 0.0, 16.0, 0.0),
                          iconPadding: EdgeInsetsDirectional.fromSTEB(
                              0.0, 0.0, 0.0, 0.0),
                          color: Color(0xFF1D5D8A),
                          textStyle:
                          MyAppTheme.of(context).titleSmall.override(
                                    fontFamily: 'Inter',
                                    color: Colors.white,
                                    letterSpacing: 0.0,
                                  ),
                          elevation: 0.0,
                          borderSide: BorderSide(
                            color: Color(0xFF0D5A8E),
                            width: 1.0,
                          ),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      FFButtonWidget(
                        onPressed: () async {
                          context.pushNamed('PartyPage');
                        },
                        text: 'Party',
                        options: FFButtonOptions(
                          width: 300.0,
                          height: 40.0,
                          padding: EdgeInsetsDirectional.fromSTEB(
                              16.0, 0.0, 16.0, 0.0),
                          iconPadding: EdgeInsetsDirectional.fromSTEB(
                              0.0, 0.0, 0.0, 0.0),
                          color: Color(0xFF1D5D8A),
                          textStyle:
                          MyAppTheme.of(context).titleSmall.override(
                                    fontFamily: 'Inter',
                                    color: Colors.white,
                                    letterSpacing: 0.0,
                                  ),
                          elevation: 0.0,
                          borderSide: BorderSide(
                            color: Color(0xFF0D5A8E),
                            width: 1.0,
                          ),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      FFButtonWidget(
                        onPressed: () async {
                          context.pushNamed('About');
                        },
                        text: 'About',
                        options: FFButtonOptions(
                          width: 300.0,
                          height: 40.0,
                          padding: EdgeInsetsDirectional.fromSTEB(
                              16.0, 0.0, 16.0, 0.0),
                          iconPadding: EdgeInsetsDirectional.fromSTEB(
                              0.0, 0.0, 0.0, 0.0),
                          color: Color(0xFF1D5D8A),
                          textStyle:
                          MyAppTheme.of(context).titleSmall.override(
                                    fontFamily: 'Inter',
                                    color: Colors.white,
                                    letterSpacing: 0.0,
                                  ),
                          elevation: 0.0,
                          borderSide: BorderSide(
                            color: Color(0xFF0D5A8E),
                            width: 1.0,
                          ),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        appBar: AppBar(
          backgroundColor: Color(0xFF1D5D8A),
          automaticallyImplyLeading: false,
          leading: MyAppIconButton(
            borderColor: Colors.transparent,
            borderRadius: 8.0,
            buttonSize: 40.0,
            fillColor: Color(0xFF1D5D8A),
            icon: Icon(
              Icons.home_rounded,
              color: MyAppTheme.of(context).info,
              size: 24.0,
            ),
            onPressed: () async {
              context.pushNamed('HomePage');
            },
          ),
          actions: [
            MyAppIconButton(
              borderColor: Colors.transparent,
              borderRadius: 8.0,
              buttonSize: 40.0,
              fillColor: Color(0xFF1D5D8A),
              icon: Icon(
                Icons.menu_rounded,
                color: MyAppTheme.of(context).info,
                size: 24.0,
              ),
              onPressed: () async {
                scaffoldKey.currentState!.openDrawer();
              },
            ),
          ],
          centerTitle: false,
          elevation: 2.0,
        ),
        body: SafeArea(
          top: true,
          child: Align(
            alignment: AlignmentDirectional(0.0, 0.0),
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Align(
                    alignment: AlignmentDirectional(0.0, 0.0),
                    child: ChoiceChips(
                      options: [ChipData('12'), ChipData('30')],
                      onChanged: (val) => safeSetState(
                          () => _model.choiceChipsValue = val?.firstOrNull),
                      selectedChipStyle: ChipStyle(
                        backgroundColor: Color(0xFF1D5D8A),
                        textStyle:
                        MyAppTheme.of(context).bodyMedium.override(
                                  fontFamily: 'Inter',
                                  color: MyAppTheme.of(context).info,
                                  letterSpacing: 0.0,
                                ),
                        iconColor: MyAppTheme.of(context).info,
                        iconSize: 16.0,
                        elevation: 0.0,
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      unselectedChipStyle: ChipStyle(
                        backgroundColor: Color(0xFFBED5DA),
                        textStyle: MyAppTheme.of(context)
                            .bodyMedium
                            .override(
                              fontFamily: 'Inter',
                              color: MyAppTheme.of(context).secondaryText,
                              letterSpacing: 0.0,
                            ),
                        iconColor: Colors.black,
                        iconSize: 16.0,
                        elevation: 0.0,
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      chipSpacing: 8.0,
                      rowSpacing: 8.0,
                      multiselect: false,
                      alignment: WrapAlignment.start,
                      controller: _model.choiceChipsValueController ??=
                          FormFieldController<List<String>>(
                        [],
                      ),
                      wrapped: true,
                    ),
                  ),
                  Opacity(
                    opacity: 0.0,
                    child: Divider(
                      height: 70.0,
                      thickness: 2.0,
                      color: MyAppTheme.of(context).alternate,
                    ),
                  ),
                  BarcodeWidget(
                    data: 'https://flutterflow.io/',
                    barcode: Barcode.qrCode(),
                    width: 200.0,
                    height: 200.0,
                    color: MyAppTheme.of(context).primaryText,
                    backgroundColor: Colors.transparent,
                    errorBuilder: (_context, _error) => SizedBox(
                      width: 200.0,
                      height: 200.0,
                    ),
                    drawText: true,
                  ),
                  Opacity(
                    opacity: 0.0,
                    child: Divider(
                      height: 70.0,
                      thickness: 2.0,
                      color: MyAppTheme.of(context).alternate,
                    ),
                  ),
                  FFButtonWidget(
                    onPressed: () {
                      print('Button pressed ...');
                    },
                    text: 'Add Friends',
                    icon: Icon(
                      Icons.person_add_alt_1,
                      size: 15.0,
                    ),
                    options: FFButtonOptions(
                      height: 40.0,
                      padding:
                          EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0),
                      iconPadding:
                          EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                      color: Color(0xFFBED5DA),
                      textStyle:
                      MyAppTheme.of(context).titleSmall.override(
                                fontFamily: 'Inter',
                                color: Color(0xFF1D5D8A),
                                letterSpacing: 0.0,
                              ),
                      elevation: 0.0,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  FFButtonWidget(
                    onPressed: () async {
                      context.pushNamed('Party');
                    },
                    text: 'Next step',
                    icon: Icon(
                      Icons.east,
                      size: 15.0,
                    ),
                    options: FFButtonOptions(
                      height: 40.0,
                      padding:
                          EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0),
                      iconPadding:
                          EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                      color: Color(0xFF1D5D8A),
                      textStyle:
                      MyAppTheme.of(context).titleSmall.override(
                                fontFamily: 'Inter',
                                color: Colors.white,
                                letterSpacing: 0.0,
                              ),
                      elevation: 0.0,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                ].divide(SizedBox(height: 12.0)),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
