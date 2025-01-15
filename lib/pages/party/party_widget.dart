import 'package:cloud_firestore/cloud_firestore.dart';
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
import 'package:trivia_2/index.dart';
import 'package:trivia_2/pages/gameplayparty/gameplay_party_widget.dart';
import '../../model/Quiz.dart';
import '../../reusables/menu.dart';
import '../../reusables/quiz_card.dart';
import '../scanqrcode/scanQr_code_widget.dart';
import 'party_model.dart';
export 'party_model.dart';

class PartyWidget extends StatefulWidget {
  final String userId;
  final String partyId;

  const PartyWidget({super.key, required this.userId, required this.partyId});

  @override
  State<PartyWidget> createState() => _PartyWidgetState();
}

class _PartyWidgetState extends State<PartyWidget> {
  late PartyModel _model;
  int participantsCount = 0;
  int participantLimit = 0;
  List<dynamic> partyUsers = []; // List of users in the party
  bool isLoading = true;
  List<Quiz> _quizzesList = [];
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  Stream<DocumentSnapshot> _partyStream() {
    return FirebaseFirestore.instance
        .collection('parties')
        .doc(widget.partyId)
        .snapshots();
  }


  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => PartyModel());
    _fetchPartyDetails();
  }

  Future<void> _fetchPartyDetails() async {
    try {
      final partyDoc = await FirebaseFirestore.instance
          .collection('parties')
          .doc(widget.partyId)
          .get();

      if (partyDoc.exists) {
        final data = partyDoc.data()!;
        setState(() {
          participantsCount = (data['users'] as List).length;
          participantLimit = data['participants'] ?? 0;
          partyUsers = data['users'] ?? [];
        });

        // Fetch quizzes from all party users
        _fetchQuizzes();
      }
    } catch (e) {
      print('Error fetching party details: $e');
    }
  }

  Future<void> _fetchQuizzes() async {
    try {
      if (partyUsers.isNotEmpty) {
        final quizDocs = await FirebaseFirestore.instance
            .collection('quizzes')
            .where('creatorId', whereIn: partyUsers)
            .get();
        final quizzes = quizDocs.docs.map((doc) => Quiz.fromSnapshot(doc))
            .toList();
        setState(() {
          _quizzesList = quizzes;
          isLoading = false;
        });
      }
    } catch (e) {
      print('Error fetching quizzes: $e');
    }
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
        backgroundColor: MyAppTheme
            .of(context)
            .primaryBackground,
        drawer: CustomDrawer(),
        appBar: AppBar(
          backgroundColor: const Color(0xFF1D5D8A),
          automaticallyImplyLeading: false,
          leading: MyAppIconButton(
            borderColor: Colors.transparent,
            borderRadius: 8.0,
            buttonSize: 40.0,
            fillColor: const Color(0xFF1D5D8A),
            icon: Icon(
              Icons.home_rounded,
              color: MyAppTheme
                  .of(context)
                  .info,
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
              fillColor: const Color(0xFF1D5D8A),
              icon: Icon(
                Icons.menu_rounded,
                color: MyAppTheme
                    .of(context)
                    .info,
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
          child: StreamBuilder<DocumentSnapshot>(
            stream: _partyStream(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (!snapshot.hasData || snapshot.hasError) {
                return const Center(
                    child: Text('Error fetching party details.'));
              }

              final partyData = snapshot.data!.data() as Map<String, dynamic>;
              final participantsList = List<String>.from(
                  partyData['users'] ?? []);
              final participantsCount = participantsList.length;
              final participantLimit = partyData['participants'] ?? 0;

              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Align(
                      alignment: AlignmentDirectional.center,
                      child: Chip(
                        backgroundColor: const Color(0xFF1D5D8A),
                        label: Text(
                          '$participantsCount / $participantLimit',
                          style: MyAppTheme
                              .of(context)
                              .bodyMedium
                              .override(
                            fontFamily: 'Inter',
                            color: Colors.white,
                            letterSpacing: 0.0,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24.0),
                    Text(
                      'Available Quizzes',
                      style: MyAppTheme
                          .of(context)
                          .headlineSmall
                          .override(
                        fontFamily: 'Readex Pro',
                        letterSpacing: 0.0,
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
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => GameplayPartyWidget(
                                    userId: widget.userId.toString(),
                                    quizId: quiz.quizId.toString(),
                                    quizTitle: quiz.title.toString(),
                                    partyId: widget.partyId,),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    FFButtonWidget(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                NewPartyWidget(
                                  partyId: widget.partyId,
                                  userId: widget.userId,
                                ),
                          ),
                        );
                      },
                      text: 'Back to QR Code',
                      icon: const Icon(Icons.qr_code, size: 15.0),
                      options: FFButtonOptions(
                        height: 40.0,
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        color: const Color(0xFF1D5D8A),
                        textStyle: MyAppTheme
                            .of(context)
                            .titleSmall
                            .override(
                          fontFamily: 'Inter',
                          color: Colors.white,
                          letterSpacing: 0.0,
                        ),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),

                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
