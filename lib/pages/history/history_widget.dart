import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:go_router/go_router.dart';
import '../../theme/icon_button.dart';
import '../../theme/model.dart';
import '../../theme/theme.dart';
import '../../reusables/menu.dart';
import 'history_model.dart';

class HistoryWidget extends StatefulWidget {
  final String userId;
  const HistoryWidget({Key? key, required this.userId}) : super(key: key);

  @override
  State<HistoryWidget> createState() => _HistoryWidgetState();
}

class _HistoryWidgetState extends State<HistoryWidget> {
  late HistoryModel _model;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => HistoryModel());
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
                child: const Text('Quiz History'),
              ),
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('quizHistory')
                      .where('userId', isEqualTo: widget.userId)
                      .orderBy('date', descending: true)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return const Center(
                          child: Text('No quiz history found.'));
                    }

                    final history = snapshot.data!.docs;

                    return ListView.builder(
                      itemCount: history.length,
                      itemBuilder: (context, index) {
                        final quizHistory =
                            history[index].data() as Map<String, dynamic>;

                        return ListTile(
                          title:
                              Text(quizHistory['quizTitle'] ?? 'Unknown Quiz'),
                          subtitle: Text(
                            'Score: ${quizHistory['score']} / ${quizHistory['totalQuestions']}',
                          ),
                          trailing: Text(
                            quizHistory['date'].toDate().toString(),
                            style: const TextStyle(fontSize: 12.0),
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
    );
  }
}
