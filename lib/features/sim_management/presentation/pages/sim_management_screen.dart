import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/sim_bloc.dart';
import '../bloc/sim_event.dart';
import '../bloc/sim_state.dart';
import '../../../../core/di/injection_container.dart';
import 'widgets/sim_card_widget.dart';
import 'widgets/loading_state_widget.dart';
import 'widgets/no_sim_state_widget.dart';
import 'widgets/permission_required_widget.dart';
import 'widgets/error_state_widget.dart';

class SimManagementScreen extends StatelessWidget {
  const SimManagementScreen({super.key});

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
    return BlocProvider(
      create: (_) => sl<SimBloc>()..add(LoadSimCards()),
      child: PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) async {
          if (didPop) return;
          final shouldPop = await _onWillPop(context);
          if (shouldPop && context.mounted) {
            Navigator.of(context).pop();
          }
        },
        child: Scaffold(
          backgroundColor: const Color(0xFFF5F5F5),
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () => Navigator.pop(context),
            ),
            title: const Text(
              'SIM Management',
              style: TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.more_vert, color: Colors.black),
                onPressed: () {},
              ),
            ],
          ),
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Expanded(
                      child: BlocBuilder<SimBloc, SimState>(
                        builder: (context, state) {
                          return OutlinedButton.icon(
                            onPressed: state is SimLoading
                                ? null
                                : () => context.read<SimBloc>().add(
                                    RefreshSimCards(),
                                  ),
                            icon: const Icon(Icons.refresh),
                            label: const Text('Refresh'),
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.settings),
                        label: const Text('Settings'),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: BlocBuilder<SimBloc, SimState>(
                  builder: (context, state) {
                    if (state is SimLoading) {
                      return const LoadingStateWidget();
                    } else if (state is SimLoaded) {
                      return ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: state.simCards.length,
                        itemBuilder: (context, index) {
                          return SimCardWidget(simCard: state.simCards[index]);
                        },
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
    );
  }
}
