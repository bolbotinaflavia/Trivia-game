import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:go_router/go_router.dart';
import 'package:trivia_2/index.dart';
import '../../Services/auth_service.dart';
import '../../flutter_flow/icon_button.dart';
import '../../flutter_flow/model.dart';
import '../../flutter_flow/theme.dart';
import '../../flutter_flow/widgets.dart';
import '../../model/Quiz.dart';
import '../../reusables/menu.dart';
import '../../reusables/quiz_card.dart';
import 'quizzes_model.dart';

class QuizzesWidget extends StatefulWidget {
  const QuizzesWidget({Key? key}) : super(key: key);

  @override
  State<QuizzesWidget> createState() => _QuizzesWidgetState();
}

class _QuizzesWidgetState extends State<QuizzesWidget> {
  late QuizzesModel _model;
  bool isLoading = true;
  List<Quiz> _quizzesList = [];
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  late User currentUser;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => QuizzesModel());
    fetchQuizzes();
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  Future<void> fetchQuizzes() async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        setState(() {
          isLoading = false;
        });
        return;
      }
      currentUser = user;

      final data = await FirebaseFirestore.instance
          .collection("quizzes")
          .where('creatorId', isEqualTo: currentUser.uid)
          .orderBy('title', descending: true)
          .get();

      final quizzes = data.docs.map((doc) => Quiz.fromSnapshot(doc)).toList();
      setState(() {
        _quizzesList = quizzes;
        isLoading = false;
      });
    } catch (e) {
      print('Error fetching quizzes: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: scaffoldKey, // Set the key here
        backgroundColor: MyAppTheme.of(context).primaryBackground,
        drawer: const CustomDrawer(), // Reusable menu
        appBar: AppBar(
          backgroundColor: const Color(0xFF1D5D8A),
          automaticallyImplyLeading: false,
          leading: MyAppIconButton(
            borderRadius: 8.0,
            buttonSize: 40.0,
            fillColor: const Color(0xFF1D5D8A),
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
              borderRadius: 8.0,
              buttonSize: 40.0,
              fillColor: const Color(0xFF1D5D8A),
              icon: Icon(
                Icons.menu_rounded,
                color: MyAppTheme.of(context).info,
                size: 24.0,
              ),
              onPressed: () async {
                scaffoldKey.currentState!.openDrawer(); // Corrected access
              },
            ),
          ],
          centerTitle: false,
          elevation: 2.0,
        ),
        body: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: FFButtonWidget(
                  onPressed: () async=> {
                  Navigator.push(
                  context,
                  MaterialPageRoute(
                  builder: (_) => NewQuizWidget(userId:currentUser.uid.toString())
                  ),
                  ),
                },
                  text: 'New Quiz',
                  icon: const Icon(Icons.add_box, size: 15.0),
                  options: FFButtonOptions(
                    width: double.infinity,
                    height: 50.0,
                    color: const Color(0xFF1D5D8A),
                    textStyle: MyAppTheme.of(context).titleSmall.override(
                      fontFamily: 'Inter',
                      color: Colors.white,
                    ),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),
              Expanded(
                child: isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : _quizzesList.isEmpty
                    ? const Center(child: Text('No quizzes found.'))
                    : ListView.builder(
                  padding: const EdgeInsets.all(12.0),
                  itemCount: _quizzesList.length,
                  itemBuilder: (context, index) {
                    final quiz = _quizzesList[index];
                    return QuizCard(
                      quiz: quiz,
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          'Startgame',
                          arguments: quiz.quizId, // Pass a String instead of Map
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
    );
  }
}
