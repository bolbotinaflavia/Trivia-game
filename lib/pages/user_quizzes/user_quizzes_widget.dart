import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:trivia_2/theme/icon_button.dart';
import 'package:trivia_2/theme/model.dart';
import 'package:trivia_2/theme/theme.dart';
import 'package:trivia_2/theme/util.dart';
import 'package:flutter/material.dart';
import '../../model/Quiz.dart';
import '../../reusables/menu.dart';
import '../../reusables/quiz_card.dart';
import '../startgame/startgame_widget.dart';
import 'user_quizzes_model.dart';
export 'user_quizzes_model.dart';

class UserQuizzesWidget extends StatefulWidget {
  final String userId;
  const UserQuizzesWidget({super.key, required this.userId});

  @override
  State<UserQuizzesWidget> createState() => _UserQuizzesWidgetState();
}

class _UserQuizzesWidgetState extends State<UserQuizzesWidget> {
  late UserQuizzesModel _model;
  bool isLoading = true;
  List<Quiz> _quizzesList = [];
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  late final User currentUser;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> fetchQuizzes() async {
    final data = await FirebaseFirestore.instance
        .collection("quizzes")
        .where('creatorId', isEqualTo: widget.userId)
        .orderBy('title', descending: true)
        .get();

    final quizzes = data.docs.map((doc) => Quiz.fromSnapshot(doc)).toList();
    setState(() {
      _quizzesList = quizzes;
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => UserQuizzesModel());
    fetchQuizzes();
    currentUser = _auth.currentUser!;
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
        backgroundColor: MyAppTheme.of(context).secondaryBackground,
        drawer: CustomDrawer(),
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
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Card(
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  color: Color(0xFF1D5D8A),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50.0),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(2.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(60.0),
                      child: Image.asset(
                        'assets/images/pin6.jpg',
                        width: 100.0,
                        height: 100.0,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0.0, 12.0, 0.0, 0.0),
                  child: Text(
                    'Username',
                    style: MyAppTheme.of(context).headlineSmall.override(
                          fontFamily: 'Readex Pro',
                          letterSpacing: 0.0,
                        ),
                  ),
                ),
                Divider(
                  height: 44.0,
                  thickness: 1.0,
                  indent: 24.0,
                  endIndent: 24.0,
                  color: MyAppTheme.of(context).alternate,
                ),
                // Replace Expanded with Flexible or remove SingleChildScrollView
                isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : _quizzesList.isEmpty
                        ? const Center(child: Text('No quizzes found.'))
                        : Expanded(
                            child: ListView.builder(
                              padding: const EdgeInsets.all(12.0),
                              itemCount: _quizzesList.length,
                              itemBuilder: (context, index) {
                                final quiz = _quizzesList[index];
                                return QuizCard(
                                  quiz: quiz,
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => StartgameWidget(
                                          userId: currentUser.uid.toString(),
                                          quizId: quiz.quizId.toString(),
                                          quizTitle: quiz.title.toString(),
                                        ),
                                      ),
                                    );
                                  },
                                );
                              },
                            ),
                          ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
