import 'package:trivia_2/flutter_flow/model.dart';
import 'package:trivia_2/flutter_flow/theme.dart';
import 'package:trivia_2/flutter_flow/util.dart';
import 'package:trivia_2/flutter_flow/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'start_page_model.dart';
export 'start_page_model.dart';

class StartPageWidget extends StatefulWidget {
  const StartPageWidget({super.key});

  @override
  State<StartPageWidget> createState() => _StartPageWidgetState();
}

class _StartPageWidgetState extends State<StartPageWidget> {
  late StartPageModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => StartPageModel());

    // On page load action with a delay.
    Future.delayed(Duration(seconds: 5), () {
      context.pushNamed(
        'Authenticate',
        extra: <String, dynamic>{
          kTransitionInfoKey: TransitionInfo(
            hasTransition: true,
            transitionType: PageTransitionType.topToBottom,
            duration: Duration(milliseconds: 1000),
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
            alignment: AlignmentDirectional(0.0, 1.0),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Spacer(),
                Align(
                  alignment: AlignmentDirectional(0.0, 0.0),
                  child: Lottie.asset(
                    'assets/jsons/Animation_-_1733004836388.json',
                    width: 400.0,
                    height: 400.0,
                    fit: BoxFit.contain,
                    animate: true,
                  ),
                ),
                Flexible(
                  child: Align(
                    alignment: AlignmentDirectional(0.0, -1.0),
                    child: Text(
                      'Welcome to Trivia Planet',
                      style: MyAppTheme.of(context).headlineMedium.override(
                        fontFamily: 'Roboto Mono',
                        color: Color(0xFF1D5D8A),
                        fontSize: 26.0,
                        letterSpacing: 0.0,
                        fontWeight: FontWeight.w800,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                ),
              ].divide(SizedBox(height: 5.0)),
            ),
          ),
        ),
      ),
    );
  }
}
