import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:trivia_2/flutter_flow/icon_button.dart';
import 'package:trivia_2/flutter_flow/model.dart';
import 'package:trivia_2/flutter_flow/theme.dart';
import 'package:trivia_2/flutter_flow/util.dart';
import 'package:trivia_2/flutter_flow/widgets.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:trivia_2/index.dart';
import 'package:trivia_2/model/Question.dart';
import '../../Services/auth_service.dart';
import '../../model/Quiz.dart';
import '../../reusables/menu.dart';
import 'new_quiz_model.dart';
export 'new_quiz_model.dart';

class NewQuizWidget extends StatefulWidget {
  final String userId;
  const NewQuizWidget({super.key, required this.userId});

  @override
  State<NewQuizWidget> createState() => _NewQuizWidgetState();
}

class _NewQuizWidgetState extends State<NewQuizWidget> {
  late NewQuizModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();
  late User currentUser;
  final FirebaseAuth _auth = FirebaseAuth.instance;


  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => NewQuizModel());

    _model.textController ??= TextEditingController();
    _model.textFieldFocusNode ??= FocusNode();

    _model.switchValue1 = true;
    _model.switchValue2 = true;

    final user = _auth.currentUser;
    if (user == null) {
      return;
    }
    currentUser = user;

  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  Future addUserDetails(String userName) async {
    await FirebaseFirestore.instance.collection('users').add({
      'userName': userName,
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: MyAppTheme.of(context).primaryBackground,
        drawer: const CustomDrawer(),
        appBar: AppBar(
          backgroundColor: Color(0xFF1D5D8A),
          automaticallyImplyLeading: false,
          leading:MyAppIconButton(
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
                  Opacity(
                    opacity: 0.0,
                    child: Divider(
                      height: 70.0,
                      thickness: 2.0,
                      color: MyAppTheme.of(context).alternate,
                    ),
                  ),
                  Text(
                    'Quiz Name',
                    style: MyAppTheme.of(context).headlineSmall.override(
                          fontFamily: 'Readex Pro',
                          letterSpacing: 0.0,
                        ),
                  ),
                  Container(
                    width: 200.0,
                    child: TextFormField(
                      controller: _model.textController,
                      focusNode: _model.textFieldFocusNode,
                      autofocus: false,
                      obscureText: false,
                      decoration: InputDecoration(
                        isDense: true,
                        labelStyle:
                        MyAppTheme.of(context).labelMedium.override(
                                  fontFamily: 'Inter',
                                  letterSpacing: 0.0,
                                ),
                        hintText: 'Write the name',
                        hintStyle:
                        MyAppTheme.of(context).labelMedium.override(
                                  fontFamily: 'Inter',
                                  letterSpacing: 0.0,
                                ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color(0x00000000),
                            width: 1.0,
                          ),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color(0x00000000),
                            width: 1.0,
                          ),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: MyAppTheme.of(context).error,
                            width: 1.0,
                          ),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: MyAppTheme.of(context).error,
                            width: 1.0,
                          ),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        filled: true,
                        fillColor:
                        MyAppTheme.of(context).secondaryBackground,
                      ),
                      style: MyAppTheme.of(context).bodyMedium.override(
                            fontFamily: 'Inter',
                            letterSpacing: 0.0,
                          ),
                      cursorColor: MyAppTheme.of(context).primaryText,
                      validator:
                          _model.textControllerValidator.asValidator(context),
                    ),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Align(
                        alignment: AlignmentDirectional(-1.0, 0.0),
                        child: Switch.adaptive(
                          value: _model.switchValue1!,
                          onChanged: (newValue) async {
                            safeSetState(() => _model.switchValue1 = newValue!);
                          },
                          activeColor: Color(0xFF1D5D8A),
                          activeTrackColor: Color(0xFF1D5D8A),
                          inactiveTrackColor: Color(0xFFBED5DA),
                          inactiveThumbColor:
                          MyAppTheme.of(context).primaryBackground,
                        ),
                      ),
                      Text(
                        'Generate Quiz',
                        style: MyAppTheme.of(context).bodyMedium.override(
                              fontFamily: 'Inter',
                              letterSpacing: 0.0,
                            ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Align(
                        alignment: AlignmentDirectional(-1.0, 0.0),
                        child: Switch.adaptive(
                          value: _model.switchValue2!,
                          onChanged: (newValue) async {
                            safeSetState(() => _model.switchValue2 = newValue!);
                          },
                          activeColor: Color(0xFF1D5D8A),
                          activeTrackColor: Color(0xFF1D5D8A),
                          inactiveTrackColor: Color(0xFFBED5DA),
                          inactiveThumbColor:
                          MyAppTheme.of(context).primaryBackground,
                        ),
                      ),
                      Text(
                        'Custom Quiz',
                        style: MyAppTheme.of(context).bodyMedium.override(
                              fontFamily: 'Inter',
                              letterSpacing: 0.0,
                            ),
                      ),
                    ],
                  ),
                  FFButtonWidget(
                    onPressed: () async {
                      final title = _model.textController.text.trim();
                      if (title.isNotEmpty) {
                        final quizId = FirebaseFirestore.instance
                            .collection('quizzes')
                            .doc()
                            .id;
                        await FirebaseFirestore.instance
                            .collection('quizzes')
                            .doc(quizId)
                            .set({'title': title, 'quizId': quizId,'creatorId':currentUser.uid.toString(),'questions':["",""]});
                        if (_model.switchValue1 == false && _model.switchValue2 == true) {
                          // Navigate to Generate Quiz Page
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => CreateCustomQuizWidget(
                                quizTitle: title,
                                quizId: quizId,
                                userId: currentUser.uid.toString(),
                              ),
                            ),
                          );
                        } else if (_model.switchValue1 == true && _model.switchValue2 == false) {
                          // Navigate to Custom Quiz Page
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => GenerateQuizWidget(
                                quizTitle: title,
                                quizId: quizId,
                                userId:currentUser.uid.toString(),
                              ),
                            ),
                          );
                        } else {
                          // Error: Both or none of the switches are selected
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Please select only one option.'),
                            ),
                          );
                        }
                      } else {
                        // Error: Quiz title is empty
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Please enter a quiz title'),
                          ),
                        );
                      }
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
