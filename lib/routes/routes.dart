import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:namer_app/auth/login_page.dart';
import 'package:namer_app/auth/register_page.dart';
import 'package:namer_app/pages/home_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    notifyListeners();
    _subscription = stream.asBroadcastStream().listen((_) => notifyListeners());
  }

  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}

class Routes {
  static final router = GoRouter(
    refreshListenable: GoRouterRefreshStream(
      Supabase.instance.client.auth.onAuthStateChange,
    ),
    routes: [
      GoRoute(
          path: '/',
          builder: (context, state) => MyHomePage(),
          routes: [],
          redirect: (BuildContext context, GoRouterState state) {
            if (Supabase.instance.client.auth.currentSession == null) {
              return '/signin';
            } else {
              return null;
            }
          }),
      GoRoute(path: '/signin', builder: (context, state) => LoginPage()),
      GoRoute(path: '/signup', builder: (context, state) => RegisterPage()),
    ],
  );
}
