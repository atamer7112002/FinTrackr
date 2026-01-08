import 'package:go_router/go_router.dart';
import '../../features/auth/presentation/pages/login_screen.dart';
import '../../features/sim_management/presentation/pages/sim_management_screen.dart';
import '../../features/sms_sync/presentation/pages/sms_sync_screen.dart';

class AppRoutes {
  static const String login = '/';
  static const String simManagement = '/sim-management';
  static const String smsSync = '/sms-sync';
}

final router = GoRouter(
  initialLocation: AppRoutes.login,
  routes: [
    GoRoute(
      path: AppRoutes.login,
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: AppRoutes.simManagement,
      builder: (context, state) => const SimManagementScreen(),
    ),
    GoRoute(
      path: AppRoutes.smsSync,
      builder: (context, state) => const SmsSyncScreen(),
    ),
  ],
);
