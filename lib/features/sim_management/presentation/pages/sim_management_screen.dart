import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';
import '../bloc/sim_bloc.dart';
import '../bloc/sim_event.dart';
import '../bloc/sim_state.dart';
import '../../../../core/di/injection_container.dart';
import 'widgets/sim_card_widget.dart';
import 'widgets/loading_state_widget.dart';
import 'widgets/no_sim_state_widget.dart';
import 'widgets/permission_required_widget.dart';
import 'widgets/error_state_widget.dart';
import 'widgets/quick_tips_widget.dart';

class SimManagementScreen extends StatefulWidget {
  const SimManagementScreen({super.key});

  @override
  State<SimManagementScreen> createState() => _SimManagementScreenState();
}

class _SimManagementScreenState extends State<SimManagementScreen>
    with WidgetsBindingObserver {
  late SimBloc _simBloc;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _simBloc = sl<SimBloc>()..add(LoadSimCards());
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // Immediately check permissions and reload when app resumes
      Future.delayed(const Duration(milliseconds: 300), () {
        _checkPermissionsAndReload();
      });
    }
  }

  Future<void> _checkPermissionsAndReload() async {
    final phonePermission = await Permission.phone.isGranted;
    final smsPermission = await Permission.sms.isGranted;

    if (phonePermission && smsPermission && mounted) {
      // Force reload to clear PermissionDenied state
      _simBloc.add(LoadSimCards());
    }
  }

  Future<bool> _onWillPop(BuildContext context) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Exit App'),
        content: const Text('Are you sure you want to exit?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Exit'),
          ),
        ],
      ),
    );
    return result ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _simBloc,
      child: PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) async {
          if (didPop) return;
          final shouldPop = await _onWillPop(context);
          if (shouldPop && context.mounted) {
            SystemNavigator.pop();
          }
        },
        child: Scaffold(
          backgroundColor: const Color(0xFFF8F9FA),
          appBar: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: Colors.transparent,
            elevation: 0,
            centerTitle: true,
            title: const Text(
              'SIM Management',
              style: TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.more_vert, color: Colors.black),
                onPressed: () {},
              ),
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: BlocBuilder<SimBloc, SimState>(
                        builder: (context, state) {
                          return _buildActionButton(
                            icon: Icons.refresh,
                            label: 'Refresh',
                            onTap: state is SimLoading
                                ? null
                                : () => context.read<SimBloc>().add(
                                    RefreshSimCards(),
                                  ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildActionButton(
                        icon: Icons.settings_outlined,
                        label: 'Settings',
                        onTap: () {},
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Expanded(
                  child: BlocBuilder<SimBloc, SimState>(
                    builder: (context, state) {
                      if (state is SimLoading) {
                        return const LoadingStateWidget();
                      } else if (state is SimLoaded) {
                        return ListView(
                          children: [
                            ...state.simCards.map(
                              (sim) => SimCardWidget(simCard: sim),
                            ),
                            const QuickTipsWidget(),
                          ],
                        );
                      } else if (state is NoSimCardsFound) {
                        return const NoSimStateWidget();
                      } else if (state is PermissionDenied) {
                        return const PermissionRequiredWidget();
                      } else if (state is SimError) {
                        return ErrorStateWidget(failure: state.failure);
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback? onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 20, color: Colors.grey[600]),
                const SizedBox(width: 8),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[700],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
