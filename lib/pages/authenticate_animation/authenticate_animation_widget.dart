import 'package:trivia_2/theme/model.dart';
import 'package:trivia_2/theme/theme.dart';
import 'package:trivia_2/theme/util.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'authenticate_animation_model.dart';
export 'authenticate_animation_model.dart';

class AuthenticateAnimationWidget extends StatefulWidget {
  const AuthenticateAnimationWidget({super.key});

  @override
  State<AuthenticateAnimationWidget> createState() =>
      _AuthenticateAnimationWidgetState();
}

class _AuthenticateAnimationWidgetState
    extends State<AuthenticateAnimationWidget> {
  late AuthenticateAnimationModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => AuthenticateAnimationModel());
    Future.delayed(Duration(seconds: 3), () {
      context.pushNamed(
        'HomePage',
        extra: <String, dynamic>{
          kTransitionInfoKey: TransitionInfo(
            hasTransition: true,
            transitionType: PageTransitionType.topToBottom,
            duration: Duration(milliseconds: 2000),
          ),
        },
      );
    });
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
        body: SafeArea(
          top: true,
          child: Align(
            alignment: AlignmentDirectional(0.0, 0.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Lottie.asset(
                  'assets/jsons/Animation_-_1733008258783.json',
                  width: 200.0,
                  height: 200.0,
                  fit: BoxFit.contain,
                  animate: true,
                ),
                Text(
                  'Welcome',
                  style: MyAppTheme.of(context).displayMedium.override(
                        fontFamily: 'Readex Pro',
                        letterSpacing: 0.0,
                      ),
                ),
              ].divide(SizedBox(height: 100.0)),
            ),
          ),
        ),
      ),
    );
  }
}
