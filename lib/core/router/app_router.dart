import 'package:go_router/go_router.dart';
import '../../features/auth/presentation/pages/login_screen.dart';
import '../../features/sim_management/presentation/pages/sim_management_screen.dart';
import '../../features/sms_sync/presentation/pages/sms_sync_screen.dart';

final router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(path: '/', builder: (context, state) => const LoginScreen()),
    GoRoute(
      path: '/sim-management',
      builder: (context, state) => const SimManagementScreen(),
    ),
    GoRoute(
      path: '/sms-sync',
      builder: (context, state) => const SmsSyncScreen(),
    ),
  ],
);
