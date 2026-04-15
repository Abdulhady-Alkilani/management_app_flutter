import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../providers/auth_provider.dart';
import '../../ui/splash/splash_screen.dart';
import '../../ui/auth/login_screen.dart';
import '../../ui/engineer/engineer_home_screen.dart';
import '../../ui/worker/worker_home_screen.dart';

// Engineer Screens
import '../../ui/engineer/engineer_tasks_screen.dart';
import '../../ui/engineer/engineer_projects_screen.dart';
import '../../ui/engineer/engineer_reports_screen.dart';
import '../../ui/engineer/engineer_cv_screen.dart';
import '../../ui/engineer/engineer_task_details_screen.dart';
import '../../ui/engineer/report_details_screen.dart';

// Worker Screens
import '../../ui/worker/worker_tasks_screen.dart';
import '../../ui/worker/worker_workshops_screen.dart';
import '../../ui/worker/worker_cv_screen.dart';
import '../../ui/worker/worker_task_details_screen.dart';

class AppRouter {
  static GoRouter createRouter(AuthProvider authProvider) {
    return GoRouter(
      initialLocation: '/splash',
      refreshListenable: authProvider,
      redirect: (BuildContext context, GoRouterState state) {
        final isInitialized = authProvider.isInitialized;
        final isAuthenticated = authProvider.isAuthenticated;
        final currentPath = state.uri.path;

        if (!isInitialized) {
          if (currentPath != '/splash') return '/splash';
          return null;
        }

        if (!isAuthenticated) {
          if (currentPath != '/login') return '/login';
          return null;
        }

        if (currentPath == '/splash' || currentPath == '/login') {
          if (authProvider.hasRole('Worker')) {
            return '/worker_home';
          }
          return '/engineer_home';
        }

        return null;
      },
      routes: [
        GoRoute(
          path: '/splash',
          builder: (context, state) => const SplashScreen(),
        ),
        GoRoute(
          path: '/login',
          builder: (context, state) => const LoginScreen(),
        ),
        // ── Engineer Routes ─────────────────────────────────
        GoRoute(
          path: '/engineer_home',
          builder: (context, state) => const EngineerHomeScreen(),
        ),
        GoRoute(
          path: '/engineer/tasks',
          builder: (context, state) => const EngineerTasksScreen(),
        ),
        GoRoute(
          path: '/engineer/tasks/:id',
          builder: (context, state) {
            final id = int.parse(state.pathParameters['id']!);
            return EngineerTaskDetailsScreen(taskId: id);
          },
        ),
        GoRoute(
          path: '/engineer/projects',
          builder: (context, state) => const EngineerProjectsScreen(),
        ),
        GoRoute(
          path: '/engineer/reports',
          builder: (context, state) => const EngineerReportsScreen(),
        ),
        GoRoute(
          path: '/engineer/reports/:id',
          builder: (context, state) {
            final id = int.parse(state.pathParameters['id']!);
            return ReportDetailsScreen(reportId: id);
          },
        ),
        GoRoute(
          path: '/engineer/cv',
          builder: (context, state) => const EngineerCvScreen(),
        ),
        // ── Worker Routes ───────────────────────────────────
        GoRoute(
          path: '/worker_home',
          builder: (context, state) => const WorkerHomeScreen(),
        ),
        GoRoute(
          path: '/worker/tasks',
          builder: (context, state) => const WorkerTasksScreen(),
        ),
        GoRoute(
          path: '/worker/tasks/:id',
          builder: (context, state) {
            final id = int.parse(state.pathParameters['id']!);
            return WorkerTaskDetailsScreen(taskId: id);
          },
        ),
        GoRoute(
          path: '/worker/workshops',
          builder: (context, state) => const WorkerWorkshopsScreen(),
        ),
        GoRoute(
          path: '/worker/cv',
          builder: (context, state) => const WorkerCvScreen(),
        ),
      ],
    );
  }
}
