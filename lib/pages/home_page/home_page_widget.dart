import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:trivia_2/theme/icon_button.dart';
import 'package:trivia_2/theme/model.dart';
import 'package:trivia_2/theme/theme.dart';
import 'package:trivia_2/theme/util.dart';
import 'package:flutter/material.dart';
import 'package:trivia_2/pages/history/history_widget.dart';
import '../../reusables/menu.dart';
import '../discover/discover_widget.dart';
import 'home_page_model.dart';
export 'home_page_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomePageWidget extends StatefulWidget {
  const HomePageWidget({super.key});

  @override
  State<HomePageWidget> createState() => _HomePageWidgetState();
}

class _HomePageWidgetState extends State<HomePageWidget> {
  late HomePageModel _model;
  final TextEditingController nameController = TextEditingController();
  bool isLoading = true;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  late User currentUser;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => HomePageModel());
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  Future<void> _loadUserProfile() async {
    try {
      setState(() {
        isLoading = true;
      });

      // Get the current authenticated user
      currentUser = FirebaseAuth.instance.currentUser!;

      if (currentUser == null) {
        throw Exception('No authenticated user found');
      }

      // Fetch user data from Firestore using the UID
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser!.uid)
          .get();

      final data = userDoc.data();

      if (data != null) {
        setState(() {
          nameController.text = data['userName'] ?? '';
        });
      }

      setState(() {
        isLoading = false;
      });
    } catch (e) {
      print('Error loading user profile: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = _auth.currentUser;
    currentUser = user!;
    _loadUserProfile();

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: MyAppTheme.of(context).primaryBackground,
        drawer: const CustomDrawer(), // Reusable menu
        appBar: AppBar(
          backgroundColor: Color(0xFF1D5D8A),
          automaticallyImplyLeading: false,
          leading: MyAppIconButton(
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
          child: Stack(
            children: [
              Align(
                alignment: AlignmentDirectional(0.0, 0.0),
                child: Stack(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(12.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Align(
                            alignment: AlignmentDirectional(-1.0, -1.0),
                            child: Padding(
                              padding: EdgeInsets.all(12.0),
                              child: Text(
                                nameController.text.isNotEmpty
                                    ? nameController.text
                                    : "Unknown User",
                                textAlign: TextAlign.start,
                                style: MyAppTheme.of(context)
                                    .displaySmall
                                    .override(
                                      fontFamily: 'Readex Pro',
                                      letterSpacing: 0.0,
                                    ),
                              ),
                            ),
                          ),
                          Opacity(
                            opacity: 0.0,
                            child: Divider(
                              height: 60.0,
                              thickness: 2.0,
                              color: MyAppTheme.of(context).alternate,
                            ),
                          ),
                          Expanded(
                            child: Align(
                              alignment: AlignmentDirectional(0.0, 0.0),
                              child: GridView(
                                padding: EdgeInsets.zero,
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  mainAxisSpacing: 10.0,
                                  childAspectRatio: 1.0,
                                ),
                                scrollDirection: Axis.vertical,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.all(12.0),
                                    child: InkWell(
                                      splashColor: Colors.transparent,
                                      focusColor: Colors.transparent,
                                      hoverColor: Colors.transparent,
                                      highlightColor: Colors.transparent,
                                      onTap: () async {
                                        context.pushNamed('Quizzes');
                                      },
                                      child: Container(
                                        width: 50.0,
                                        height: 50.0,
                                        decoration: BoxDecoration(
                                          color: Color(0xFFBED5DA),
                                          borderRadius:
                                              BorderRadius.circular(18.0),
                                          shape: BoxShape.rectangle,
                                        ),
                                        child: Align(
                                          alignment:
                                              AlignmentDirectional(0.0, 0.0),
                                          child: Text(
                                            'Quizzes',
                                            style: MyAppTheme.of(context)
                                                .bodyMedium
                                                .override(
                                                  fontFamily: 'Roboto',
                                                  fontSize: 20.0,
                                                  letterSpacing: 0.0,
                                                ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(12.0),
                                    child: InkWell(
                                      splashColor: Colors.transparent,
                                      focusColor: Colors.transparent,
                                      hoverColor: Colors.transparent,
                                      highlightColor: Colors.transparent,
                                      onTap: () async {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) => DiscoverWidget(
                                              userId:
                                                  currentUser.uid.toString(),
                                            ),
                                          ),
                                        );
                                      },
                                      child: Container(
                                        width: 50.0,
                                        height: 50.0,
                                        decoration: BoxDecoration(
                                          color: Color(0xFFBED5DA),
                                          borderRadius:
                                              BorderRadius.circular(18.0),
                                          shape: BoxShape.rectangle,
                                        ),
                                        child: Align(
                                          alignment:
                                              AlignmentDirectional(0.0, 0.0),
                                          child: Text(
                                            'Discover',
                                            style: MyAppTheme.of(context)
                                                .bodyMedium
                                                .override(
                                                  fontFamily: 'Roboto',
                                                  fontSize: 20.0,
                                                  letterSpacing: 0.0,
                                                ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(12.0),
                                    child: InkWell(
                                      splashColor: Colors.transparent,
                                      focusColor: Colors.transparent,
                                      hoverColor: Colors.transparent,
                                      highlightColor: Colors.transparent,
                                      onTap: () async {
                                        context.pushNamed('PartyPage');
                                      },
                                      child: Container(
                                        width: 50.0,
                                        height: 50.0,
                                        decoration: BoxDecoration(
                                          color: Color(0xFFBED5DA),
                                          borderRadius:
                                              BorderRadius.circular(18.0),
                                          shape: BoxShape.rectangle,
                                        ),
                                        child: Align(
                                          alignment:
                                              AlignmentDirectional(0.0, 0.0),
                                          child: Text(
                                            'Party',
                                            style: MyAppTheme.of(context)
                                                .bodyMedium
                                                .override(
                                                  fontFamily: 'Roboto',
                                                  fontSize: 20.0,
                                                  letterSpacing: 0.0,
                                                ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(12.0),
                                    child: InkWell(
                                      splashColor: Colors.transparent,
                                      focusColor: Colors.transparent,
                                      hoverColor: Colors.transparent,
                                      highlightColor: Colors.transparent,
                                      onTap: () async {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) => HistoryWidget(
                                              userId:
                                                  currentUser.uid.toString(),
                                            ),
                                          ),
                                        );
                                      },
                                      child: Container(
                                        width: 50.0,
                                        height: 50.0,
                                        decoration: BoxDecoration(
                                          color: Color(0xFFBED5DA),
                                          borderRadius:
                                              BorderRadius.circular(18.0),
                                          shape: BoxShape.rectangle,
                                        ),
                                        child: Align(
                                          alignment:
                                              AlignmentDirectional(0.0, 0.0),
                                          child: Text(
                                            'History',
                                            style: MyAppTheme.of(context)
                                                .bodyMedium
                                                .override(
                                                  fontFamily: 'Roboto',
                                                  fontSize: 20.0,
                                                  letterSpacing: 0.0,
                                                ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ].divide(SizedBox(height: 12.0)),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
