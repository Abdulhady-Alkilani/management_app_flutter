import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../providers/auth_provider.dart';
import '../../ui/auth/login_screen.dart';
import '../../ui/engineer/engineer_home_screen.dart';
import '../../ui/worker/worker_home_screen.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/',
    redirect: (BuildContext context, GoRouterState state) async {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');
      final roles = prefs.getStringList('user_roles') ?? [];
      
      final bool loggedIn = token != null && token.isNotEmpty;
      final bool isLoginLocation = state.uri.path == '/';

      if (!loggedIn && !isLoginLocation) {
        return '/';
      }

      if (loggedIn && isLoginLocation) {
        if (roles.contains('Worker')) {
           return '/worker_home';
        } else {
           return '/engineer_home'; 
        }
      }

      return null;
    },
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/engineer_home',
        builder: (context, state) => const EngineerHomeScreen(),
      ),
      GoRoute(
        path: '/worker_home',
        builder: (context, state) => const WorkerHomeScreen(),
      ),
    ],
  );
}
