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
import 'discover_model.dart';
export 'discover_model.dart';

class DiscoverWidget extends StatefulWidget {
  final String userId;
  const DiscoverWidget({super.key, required this.userId});

  @override
  State<DiscoverWidget> createState() => _DiscoverWidgetState();
}

class _DiscoverWidgetState extends State<DiscoverWidget> {
  late DiscoverModel _model;
  bool isLoading = true;
  List<Quiz> _quizzesList = [];
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  late final User currentUser;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> fetchFriendsQuizzes() async {
    try {
      setState(() {
        isLoading = true;
      });

      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.userId)
          .get();

      final List<dynamic> friendsIds = userDoc['friends'] ?? [];

      if (friendsIds.isEmpty) {
        setState(() {
          _quizzesList = [];
          isLoading = false;
        });
        return;
      }

      final data = await FirebaseFirestore.instance
          .collection("quizzes")
          .where('creatorId', whereIn: friendsIds)
          .orderBy('title', descending: true)
          .get();

      final quizzes = data.docs.map((doc) => Quiz.fromSnapshot(doc)).toList();

      setState(() {
        _quizzesList = quizzes;
        isLoading = false;
      });
    } catch (e) {
      print('Error fetching friends quizzes: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => DiscoverModel());
    fetchFriendsQuizzes();
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
