import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';
import 'package:trivia_2/index.dart';
import '../theme/theme.dart';
import '../theme/widgets.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    late User currentUser;
    final user = _auth.currentUser;
    currentUser = user!;

    return Container(
      width: 300.0,
      child: Drawer(
        elevation: 16.0,
        child: Container(
          color: const Color(0xFF1D5D8A),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 50), // Top padding
              FFButtonWidget(
                onPressed: () async {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ProfileWidget(
                        userId: currentUser.uid.toString(),
                      ),
                    ),
                  );
                },
                text: 'Profile',
                options: _drawerButtonOptions(context),
              ),
              FFButtonWidget(
                onPressed: () => context.pushNamed('Quizzes'),
                text: 'Quizzes',
                options: _drawerButtonOptions(context),
              ),
              FFButtonWidget(
                onPressed: () => context.pushNamed('PartyPage'),
                text: 'Party',
                options: _drawerButtonOptions(context),
              ),
              FFButtonWidget(
                onPressed: () => context.pushNamed('About'),
                text: 'About',
                options: _drawerButtonOptions(context),
              ),
              FFButtonWidget(
                onPressed: () async {
                  await FirebaseAuth.instance.signOut();
                  context.pushNamed('StartPage');
                },
                text: 'Log out',
                options: _drawerButtonOptions(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  FFButtonOptions _drawerButtonOptions(BuildContext context) {
    return FFButtonOptions(
      width: 300.0,
      height: 40.0,
      padding: const EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0),
      color: const Color(0xFF1D5D8A),
      textStyle: MyAppTheme.of(context).titleSmall.override(
            fontFamily: 'Inter',
            color: Colors.white,
          ),
      elevation: 0.0,
      borderSide: const BorderSide(
        color: Color(0xFF0D5A8E),
        width: 1.0,
      ),
      borderRadius: BorderRadius.circular(8.0),
    );
  }
}
