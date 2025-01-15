import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:trivia_2/theme/icon_button.dart';
import 'package:trivia_2/theme/model.dart';
import 'package:trivia_2/theme/theme.dart';
import 'package:trivia_2/theme/util.dart';
import 'package:trivia_2/theme/widgets.dart';
import 'package:flutter/material.dart';
import 'package:trivia_2/index.dart';
import '../../reusables/menu.dart';
import '../addFriend/add_friend_widget.dart';
import 'profile_model.dart';
export 'profile_model.dart';

class ProfileWidget extends StatefulWidget {
  final String userId;
  const ProfileWidget({super.key, required this.userId});

  @override
  State<ProfileWidget> createState() => _ProfileWidgetState();
}

class _ProfileWidgetState extends State<ProfileWidget> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController nameController = TextEditingController();
  String? profileImageUrl;
  late ProfileModel _model;
  bool isLoading = true;
  User? currentUser;

  Future<void> _loadUserProfile() async {
    try {
      setState(() {
        isLoading = true;
      });

      // Get the current authenticated user
      currentUser = FirebaseAuth.instance.currentUser;

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
          profileImageUrl = data['uploadedImage'] ?? '';
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
  void initState() {
    super.initState();
    _model = createModel(context, () => ProfileModel());
    _loadUserProfile();
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
                        profileImageUrl?.isNotEmpty == true
                            ? profileImageUrl!
                            : 'assets/images/pin6.jpg',
                        //'$currentUser.uploadedImage',
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
                    nameController.text.isNotEmpty
                        ? nameController.text
                        : "Unknown User",
                    //'$currentUser.userName',
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
                Padding(
                  padding:
                      EdgeInsetsDirectional.fromSTEB(16.0, 12.0, 16.0, 0.0),
                  child: InkWell(
                    splashColor: Colors.transparent,
                    focusColor: Colors.transparent,
                    hoverColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    onTap: () async {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => UserQuizzesWidget(
                            userId: widget.userId,
                          ),
                        ),
                      );
                    },
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: MyAppTheme.of(context).secondaryBackground,
                        borderRadius: BorderRadius.circular(12.0),
                        border: Border.all(
                          color: MyAppTheme.of(context).alternate,
                          width: 2.0,
                        ),
                      ),
                      child: Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(
                            8.0, 12.0, 8.0, 12.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  8.0, 0.0, 0.0, 0.0),
                              child: Icon(
                                Icons.quiz_rounded,
                                color: Color(0xFF1D5D8A),
                                size: 24.0,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  12.0, 0.0, 0.0, 0.0),
                              child: Text(
                                'Quizzes',
                                style:
                                    MyAppTheme.of(context).bodyMedium.override(
                                          fontFamily: 'Inter',
                                          letterSpacing: 0.0,
                                        ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding:
                      EdgeInsetsDirectional.fromSTEB(16.0, 12.0, 16.0, 0.0),
                  child: InkWell(
                    splashColor: Colors.transparent,
                    focusColor: Colors.transparent,
                    hoverColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    onTap: () async {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => UserFriendsWidget(
                            userId: widget.userId,
                          ),
                        ),
                      );
                    },
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: MyAppTheme.of(context).secondaryBackground,
                        borderRadius: BorderRadius.circular(12.0),
                        border: Border.all(
                          color: MyAppTheme.of(context).alternate,
                          width: 2.0,
                        ),
                      ),
                      child: Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(
                            8.0, 12.0, 8.0, 12.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  8.0, 0.0, 0.0, 0.0),
                              child: Icon(
                                Icons.people_sharp,
                                color: Color(0xFF1D5D8A),
                                size: 24.0,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  12.0, 0.0, 0.0, 0.0),
                              child: Text(
                                'Friends',
                                style:
                                    MyAppTheme.of(context).bodyMedium.override(
                                          fontFamily: 'Inter',
                                          letterSpacing: 0.0,
                                        ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding:
                      EdgeInsetsDirectional.fromSTEB(16.0, 12.0, 16.0, 0.0),
                  child: InkWell(
                    splashColor: Colors.transparent,
                    focusColor: Colors.transparent,
                    hoverColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    onTap: () async {
                      context.pushNamed('EditProfile');
                    },
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: MyAppTheme.of(context).secondaryBackground,
                        borderRadius: BorderRadius.circular(12.0),
                        border: Border.all(
                          color: MyAppTheme.of(context).alternate,
                          width: 2.0,
                        ),
                      ),
                      child: Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(
                            8.0, 12.0, 8.0, 12.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  8.0, 0.0, 0.0, 0.0),
                              child: Icon(
                                Icons.settings_outlined,
                                color: Color(0xFF1D5D8A),
                                size: 24.0,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  12.0, 0.0, 0.0, 0.0),
                              child: Text(
                                'Account Settings',
                                style:
                                    MyAppTheme.of(context).bodyMedium.override(
                                          fontFamily: 'Inter',
                                          letterSpacing: 0.0,
                                        ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0.0, 16.0, 0.0, 0.0),
                  child: FFButtonWidget(
                    onPressed: () async {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => AddFriendWidget(
                            userId: widget.userId,
                          ),
                        ),
                      );
                    },
                    text: 'Add Friend',
                    icon: Icon(
                      Icons.add,
                      size: 15.0,
                    ),
                    options: FFButtonOptions(
                      width: 300.0,
                      height: 44.0,
                      padding:
                          EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                      iconPadding:
                          EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                      color: Color(0xFFBED5DA),
                      textStyle: MyAppTheme.of(context).bodyLarge.override(
                            fontFamily: 'Inter',
                            letterSpacing: 0.0,
                          ),
                      elevation: 0.0,
                      borderSide: BorderSide(
                        color: MyAppTheme.of(context).alternate,
                        width: 1.0,
                      ),
                      borderRadius: BorderRadius.circular(38.0),
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
