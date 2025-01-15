import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

import 'package:trivia_2/index.dart';
import 'package:trivia_2/theme/util.dart';
import 'package:trivia_2/theme/nav/serialization_util.dart';
import 'package:trivia_2/pages/add_friends_to_party/add_friends_to_party_widget.dart';
import 'package:trivia_2/pages/friend_profile/friend_profile_widget.dart';
import 'package:trivia_2/pages/gameplayparty/gameplay_party_widget.dart';
import 'package:trivia_2/pages/quizResult/quiz_result_widget.dart';
import 'package:trivia_2/pages/scanqrcode/scanQr_code_widget.dart';

import '../../pages/addFriend/add_friend_widget.dart';
import '../../pages/discover/discover_widget.dart';
import '../../pages/history/history_widget.dart';

export 'package:go_router/go_router.dart';

const kTransitionInfoKey = '__transition_info__';

class AppStateNotifier extends ChangeNotifier {
  AppStateNotifier._();

  static AppStateNotifier? _instance;
  static AppStateNotifier get instance => _instance ??= AppStateNotifier._();

  bool showSplashImage = true;

  void stopShowingSplashImage() {
    showSplashImage = false;
    notifyListeners();
  }
}

GoRouter createRouter(AppStateNotifier appStateNotifier) => GoRouter(
      initialLocation: '/',
      debugLogDiagnostics: true,
      refreshListenable: appStateNotifier,
      errorBuilder: (context, state) => StartPageWidget(),
      routes: [
        FFRoute(
          name: '_initialize',
          path: '/',
          builder: (context, _) => StartPageWidget(),
        ),
        FFRoute(
          name: 'StartPage',
          path: '/startPage',
          builder: (context, params) => StartPageWidget(),
        ),
        FFRoute(
          name: 'AddFriendPage',
          path: '/addfriendpage',
          builder: (context, params) => AddFriendWidget( userId: '',),
        ),
        FFRoute(
          name: 'Authenticate',
          path: '/authenticate',
          builder: (context, params) => AuthenticateWidget(),
        ),
        FFRoute(
          name: 'AuthenticateAnimation',
          path: '/authenticateAnimation',
          builder: (context, params) => AuthenticateAnimationWidget(),
        ),
        FFRoute(
          name: 'HomePage',
          path: '/homePage',
          builder: (context, params) => HomePageWidget(),
        ),
        FFRoute(
          name: 'Discover',
          path: '/discover',
          builder: (context, params) => DiscoverWidget(userId: '',),
        ),
        FFRoute(
          name: 'Quizzes',
          path: '/quizzes',
          builder: (context, params) => QuizzesWidget(),
        ),
        FFRoute(
          name: 'History',
          path: '/history',
          builder: (context, params) => HistoryWidget(userId: '',),
        ),
        FFRoute(
          name: 'NewQuiz',
          path: '/newQuiz',
          builder: (context, state){
            final userId=(state.extra as Map<String,dynamic>)['userId'] as String;
            return  NewQuizWidget(userId: userId,);
},
        ),
        FFRoute(
          name: 'GenerateQuiz',
          path: '/generateQuiz',
          builder: (context, state) {
            final quizTitle = (state.extra as Map<String, dynamic>)['quizTitle'] as String;
            final quizId=(state.extra as Map<String,dynamic>)['quizId'] as String;
            final userId=(state.extra as Map<String,dynamic>)['userId'] as String;
            return GenerateQuizWidget(quizTitle: quizTitle, quizId: quizId, userId: userId,);
          },
        ),
        FFRoute(
          name: 'CreateCustomQuiz',
          path: '/createCustomQuiz',
          builder: (context, state) {
            final quizTitle = (state.extra as Map<String, dynamic>)['quizTitle'] as String;
            final quizId=(state.extra as Map<String,dynamic>)['quizId'] as String;
            final userId=(state.extra as Map<String,dynamic>)['userId'] as String;
            return CreateCustomQuizWidget(quizTitle: quizTitle, quizId: quizId, userId: userId,);
          },
        ),
        FFRoute(
          name: 'NewQuestion',
          path: '/newQuestion',
          builder: (context, state) {
            return const NewQuestionWidget(quizId: '',questionId:'');
          },
        ),
        FFRoute(
          name: 'NewAnswer',
          path: '/newAnswer',
          builder: (context, params) => NewAnswerWidget(quizId: '', questionId: '',),
        ),
        FFRoute(
          name:'Startgame',
          path: '/startgame',
          builder: (context, params) => GameplayWidget(quizId: '', quizTitle: '', userId: ''),
        ),
        FFRoute(
          name: 'Gameplay',
          path: '/gameplay',
          builder: (context, params) => StartgameWidget(quizId: '', quizTitle: '', userId: ''),
        ),
        FFRoute(
          name: 'QuizResult',
          path: '/quizresult',
          builder: (context, params) => QuizResultWidget(score: 0, totalQuestions: 0, quizTitle: ''),
        ),
        FFRoute(
          name: 'Profile',
          path: '/profile',
          builder: (context, params) => ProfileWidget(userId:''),
        ),
        FFRoute(
          name: 'UserQuizzes',
          path: '/userQuizzes',
          builder: (context, params) => UserQuizzesWidget(userId:''),
        ),
        FFRoute(
          name: 'FriendProfile',
          path: '/friendprofile',
          builder: (context, params) => FriendProfileWidget(userId:''),
        ),
        FFRoute(
          name: 'UserFriends',
          path: '/userFriends',
          builder: (context, params) => UserFriendsWidget(userId:''),
        ),
        FFRoute(
          name: 'EditProfile',
          path: '/editProfile',
          builder: (context, params) => EditProfileWidget(),
        ),
        FFRoute(
          name: 'PartyPage',
          path: '/partyPage',
          builder: (context, params) => PartyPageWidget(),
        ),
        FFRoute(
          name: 'CreateParty',
          path: '/createParty',
          builder: (context, params) => CreatePartyWidget(userId: '',),
        ),
        FFRoute(
          name: 'GameplayParty',
          path: '/gameplayParty',
          builder: (context, params) => GameplayPartyWidget(quizId: '', userId: '', quizTitle: '', partyId: '',),
        ),
        FFRoute(
          name: 'NewParty',
          path: '/newParty',
          builder: (context, params) => NewPartyWidget(partyId:'',userId:''),
        ),
        FFRoute(
          name: 'AddFriendsToParty',
          path: '/addfriendstoparty',
          builder: (context, params) => AddFriendsToPartyWidget(partyId:''),
        ),
        FFRoute(
          name: 'Party',
          path: '/party',
          builder: (context, params) => PartyWidget(userId: '', partyId: '',),
        ),
        FFRoute(
          name: 'ScanQrCode',
          path: '/scanqrcode',
          builder: (context, params) => ScanQRCodeWidget(userId: ''),
        ),
        FFRoute(
          name: 'About',
          path: '/about',
          builder: (context, params) => AboutWidget(),
        )
      ].map((r) => r.toRoute(appStateNotifier)).toList(),
    );

extension NavParamExtensions on Map<String, String?> {
  Map<String, String> get withoutNulls => Map.fromEntries(
        entries
            .where((e) => e.value != null)
            .map((e) => MapEntry(e.key, e.value!)),
      );
}

extension NavigationExtensions on BuildContext {
  void safePop() {
    // If there is only one route on the stack, navigate to the initial
    // page instead of popping.
    if (canPop()) {
      pop();
    } else {
      go('/');
    }
  }
}

extension _GoRouterStateExtensions on GoRouterState {
  Map<String, dynamic> get extraMap =>
      extra != null ? extra as Map<String, dynamic> : {};
  Map<String, dynamic> get allParams => <String, dynamic>{}
    ..addAll(pathParameters)
    ..addAll(uri.queryParameters)
    ..addAll(extraMap);
  TransitionInfo get transitionInfo => extraMap.containsKey(kTransitionInfoKey)
      ? extraMap[kTransitionInfoKey] as TransitionInfo
      : TransitionInfo.appDefault();
}

class FFParameters {
  FFParameters(this.state, [this.asyncParams = const {}]);

  final GoRouterState state;
  final Map<String, Future<dynamic> Function(String)> asyncParams;

  Map<String, dynamic> futureParamValues = {};

  var params;

  // Parameters are empty if the params map is empty or if the only parameter
  // present is the special extra parameter reserved for the transition info.
  bool get isEmpty =>
      state.allParams.isEmpty ||
      (state.allParams.length == 1 &&
          state.extraMap.containsKey(kTransitionInfoKey));
  bool isAsyncParam(MapEntry<String, dynamic> param) =>
      asyncParams.containsKey(param.key) && param.value is String;
  bool get hasFutures => state.allParams.entries.any(isAsyncParam);

  get extra => null;
  Future<bool> completeFutures() => Future.wait(
        state.allParams.entries.where(isAsyncParam).map(
          (param) async {
            final doc = await asyncParams[param.key]!(param.value)
                .onError((_, __) => null);
            if (doc != null) {
              futureParamValues[param.key] = doc;
              return true;
            }
            return false;
          },
        ),
      ).onError((_, __) => [false]).then((v) => v.every((e) => e));

  dynamic getParam<T>(
    String paramName,
    ParamType type, {
    bool isList = false,
  }) {
    if (futureParamValues.containsKey(paramName)) {
      return futureParamValues[paramName];
    }
    if (!state.allParams.containsKey(paramName)) {
      return null;
    }
    final param = state.allParams[paramName];
    // Got parameter from `extras`, so just directly return it.
    if (param is! String) {
      return param;
    }
    // Return serialized value.
    return deserializeParam<T>(
      param,
      type,
      isList,
    );
  }
}

class FFRoute {
  const FFRoute({
    required this.name,
    required this.path,
    required this.builder,
    this.requireAuth = false,
    this.asyncParams = const {},
    this.routes = const [],
  });

  final String name;
  final String path;
  final bool requireAuth;
  final Map<String, Future<dynamic> Function(String)> asyncParams;
  final Widget Function(BuildContext, FFParameters) builder;
  final List<GoRoute> routes;

  GoRoute toRoute(AppStateNotifier appStateNotifier) => GoRoute(
        name: name,
        path: path,
        pageBuilder: (context, state) {
          fixStatusBarOniOS16AndBelow(context);
          final ffParams = FFParameters(state, asyncParams);
          final page = ffParams.hasFutures
              ? FutureBuilder(
                  future: ffParams.completeFutures(),
                  builder: (context, _) => builder(context, ffParams),
                )
              : builder(context, ffParams);
          final child = page;

          final transitionInfo = state.transitionInfo;
          return transitionInfo.hasTransition
              ? CustomTransitionPage(
                  key: state.pageKey,
                  child: child,
                  transitionDuration: transitionInfo.duration,
                  transitionsBuilder:
                      (context, animation, secondaryAnimation, child) =>
                          PageTransition(
                    type: transitionInfo.transitionType,
                    duration: transitionInfo.duration,
                    reverseDuration: transitionInfo.duration,
                    alignment: transitionInfo.alignment,
                    child: child,
                  ).buildTransitions(
                    context,
                    animation,
                    secondaryAnimation,
                    child,
                  ),
                )
              : MaterialPage(key: state.pageKey, child: child);
        },
        routes: routes,
      );
}

class TransitionInfo {
  const TransitionInfo({
    required this.hasTransition,
    this.transitionType = PageTransitionType.fade,
    this.duration = const Duration(milliseconds: 300),
    this.alignment,
  });

  final bool hasTransition;
  final PageTransitionType transitionType;
  final Duration duration;
  final Alignment? alignment;

  static TransitionInfo appDefault() => TransitionInfo(hasTransition: false);
}

class RootPageContext {
  const RootPageContext(this.isRootPage, [this.errorRoute]);
  final bool isRootPage;
  final String? errorRoute;

  static bool isInactiveRootPage(BuildContext context) {
    final rootPageContext = context.read<RootPageContext?>();
    final isRootPage = rootPageContext?.isRootPage ?? false;
    final location = GoRouterState.of(context).uri.toString();
    return isRootPage &&
        location != '/' &&
        location != rootPageContext?.errorRoute;
  }

  static Widget wrap(Widget child, {String? errorRoute}) => Provider.value(
        value: RootPageContext(true, errorRoute),
        child: child,
      );
}

extension GoRouterLocationExtension on GoRouter {
  String getCurrentLocation() {
    final RouteMatch lastMatch = routerDelegate.currentConfiguration.last;
    final RouteMatchList matchList = lastMatch is ImperativeRouteMatch
        ? lastMatch.matches
        : routerDelegate.currentConfiguration;
    return matchList.uri.toString();
  }
}
