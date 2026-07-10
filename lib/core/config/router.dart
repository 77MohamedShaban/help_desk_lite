import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../features/authentication/presentation/pages/login_page.dart';
import '../../features/authentication/presentation/pages/register_page.dart';
import '../../features/authentication/presentation/pages/splash_page.dart';
import '../../features/employee/presentation/pages/employee_dashboard.dart';
import '../../features/support/presentation/pages/support_dashboard.dart';
import '../../features/manager/presentation/pages/manager_dashboard.dart';
import '../../features/tickets/presentation/pages/ticket_details_page.dart';
import '../../features/tickets/presentation/pages/create_ticket_page.dart';
import '../../features/authentication/presentation/cubit/auth_cubit.dart';
import '../constants/app_constants.dart';
import '../di/injection.dart';

// مساعد لتحويل Stream الـ Cubit إلى Listenable يفهمه GoRouter
class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    notifyListeners();
    _subscription = stream.asBroadcastStream().listen(
          (dynamic _) => notifyListeners(),
        );
  }

  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}

final router = GoRouter(
  initialLocation: '/',
  // ربط الـ Router بحالة الـ AuthCubit ليعيد التوجيه تلقائياً عند أي تغيير
  refreshListenable: GoRouterRefreshStream(getIt<AuthCubit>().stream),
  redirect: (context, state) {
    final authState = getIt<AuthCubit>().state;
    final isLoggingIn = state.matchedLocation == '/login' || state.matchedLocation == '/register';
    final isSplash = state.matchedLocation == '/';

    if (authState is Authenticated) {
      // إذا نجح تسجيل الدخول، وجه المستخدم للوحة التحكم الخاصة به
      if (isLoggingIn || isSplash) {
        switch (authState.user.role) {
          case UserRole.employee: return '/employee';
          case UserRole.agent: return '/support';
          case UserRole.manager: return '/manager';
        }
      }
    }

    if (authState is Unauthenticated) {
      // إذا انتهت الجلسة أو خرج المستخدم، وجهه للـ Login
      if (!isLoggingIn && !isSplash) {
        return '/login';
      }
    }

    return null;
  },
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const SplashPage(),
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginPage(),
    ),
    GoRoute(
      path: '/register',
      builder: (context, state) => const RegisterPage(),
    ),
    GoRoute(
      path: '/employee',
      builder: (context, state) => const EmployeeDashboard(),
    ),
    GoRoute(
      path: '/support',
      builder: (context, state) => const SupportDashboard(),
    ),
    GoRoute(
      path: '/manager',
      builder: (context, state) => const ManagerDashboard(),
    ),
    GoRoute(
      path: '/create-ticket',
      builder: (context, state) => const CreateTicketPage(),
    ),
    GoRoute(
      path: '/ticket/:id',
      builder: (context, state) => TicketDetailsPage(ticketId: state.pathParameters['id']!),
    ),
  ],
);
