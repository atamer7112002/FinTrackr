import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/entities/sim_card.dart';
import '../../bloc/sim_bloc.dart';
import '../../bloc/sim_event.dart';
import '../../bloc/sim_state.dart';

class SimCardWidget extends StatelessWidget {
  final SimCard simCard;

  const SimCardWidget({super.key, required this.simCard});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: SIM Name + Status Badge
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'SIM ${simCard.slotIndex}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  if (simCard.phoneNumber != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      simCard.phoneNumber!,
                      style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                    ),
                  ],
                ],
              ),
              Row(
                children: [
                  if (simCard.isDefaultDataSim)
                    Container(
                      margin: const EdgeInsets.only(right: 8),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE3F2FD),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: const [
                          Icon(Icons.star, size: 14, color: Color(0xFF2196F3)),
                          SizedBox(width: 4),
                          Text(
                            'Default',
                            style: TextStyle(
                              color: Color(0xFF2196F3),
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: simCard.isActive
                          ? const Color(0xFFE8F5E9) // Green light
                          : const Color(0xFFFFEBEE), // Red light
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: simCard.isActive
                            ? const Color(0xFF4CAF50)
                            : const Color(0xFFEF5350),
                        width: 1,
                      ),
                    ),
                    child: Text(
                      simCard.isActive ? 'Active' : 'Inactive',
                      style: TextStyle(
                        color: simCard.isActive
                            ? const Color(0xFF4CAF50)
                            : const Color(0xFFEF5350),
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 24),
          const Divider(height: 1, color: Color(0xFFEEEEEE)),
          const SizedBox(height: 24),

          // Provider Info Row
          Row(
            children: [
              // Purple Icon
              Container(
                width: 56,
                height: 56,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF9575CD), Color(0xFF7E57C2)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.wifi, color: Colors.white, size: 28),
              ),
              const SizedBox(width: 16),

              // Provider Name
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Network Provider',
                      style: TextStyle(fontSize: 13, color: Colors.grey[500]),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      simCard.carrierName,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),

              // Signal Strength
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      _buildSignalBar(1, simCard.signalStrength),
                      const SizedBox(width: 2),
                      _buildSignalBar(2, simCard.signalStrength),
                      const SizedBox(width: 2),
                      _buildSignalBar(3, simCard.signalStrength),
                      const SizedBox(width: 2),
                      _buildSignalBar(4, simCard.signalStrength),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Signal',
                    style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 24),
          const Divider(height: 1, color: Color(0xFFEEEEEE)),
          const SizedBox(height: 24),

          // System Status Row
          Row(
            children: [
              Icon(
                simCard.connectionStatus == ConnectionStatus.connected
                    ? Icons.check_circle_outline
                    : Icons.cancel_outlined,
                size: 20,
                color: Colors.black,
              ),
              const SizedBox(width: 8),
              Text(
                'System Status :',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[700],
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(width: 12),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: _getConnectionStatusColor(
                    simCard.connectionStatus,
                  ).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: _getConnectionStatusColor(
                      simCard.connectionStatus,
                    ).withOpacity(0.3),
                  ),
                ),
                child: Text(
                  _getConnectionStatusText(simCard.connectionStatus),
                  style: TextStyle(
                    color: _getConnectionStatusColor(simCard.connectionStatus),
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              // Show Network Type if connected
              if (simCard.connectionStatus == ConnectionStatus.connected) ...[
                const SizedBox(width: 8),
                Text(
                  _getNetworkTypeText(simCard.networkType),
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[500],
                  ),
                ),
              ],
            ],
          ),

          const SizedBox(height: 24),

          // Action Button
          BlocConsumer<SimBloc, SimState>(
            listener: (context, state) {
              if (state is SimLoaded) {
                // Triggered when sync completes
                ScaffoldMessenger.of(context).clearSnackBars();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Row(
                      children: const [
                        Icon(Icons.check_circle, color: Colors.white),
                        SizedBox(width: 12),
                        Text('SIM synced successfully!'),
                      ],
                    ),
                    backgroundColor: Colors.green,
                    behavior: SnackBarBehavior.floating,
                    duration: const Duration(seconds: 2),
                  ),
                );
              }
            },
            builder: (context, state) {
              final isLoading = state is SimLoading;
              final isConnected =
                  simCard.connectionStatus == ConnectionStatus.connected;

              return SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: isLoading
                      ? null
                      : () {
                          if (isConnected) {
                            context.read<SimBloc>().add(SyncSimCards());
                          } else {
                            // Retry connection logic could go here or just refresh
                            context.read<SimBloc>().add(RefreshSimCards());
                          }
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.white,
                            ),
                          ),
                        )
                      : Text(
                          isConnected ? 'Sync SIM' : 'Check Connection',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSignalBar(int barIndex, int strength) {
    // strength 0-4
    final isActive = strength >= barIndex;
    return Container(
      width: 4,
      height: 8.0 + (barIndex * 4), // Ascending height: 12, 16, 20, 24
      decoration: BoxDecoration(
        color: isActive ? const Color(0xFF4CAF50) : Colors.grey[300],
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }

  String _getConnectionStatusText(ConnectionStatus status) {
    switch (status) {
      case ConnectionStatus.connected:
        return 'Connected';
      case ConnectionStatus.connecting:
        return 'Connecting';
      case ConnectionStatus.notConnected:
        return 'Not Connected';
    }
  }

  Color _getConnectionStatusColor(ConnectionStatus status) {
    switch (status) {
      case ConnectionStatus.connected:
        return const Color(0xFF5C6BC0); // Indigo-ish blue from image
      case ConnectionStatus.connecting:
        return const Color(0xFFFF9800);
      case ConnectionStatus.notConnected:
        return const Color(0xFFEF5350);
    }
  }

  String _getNetworkTypeText(NetworkType type) {
    switch (type) {
      case NetworkType.twoG:
        return '2G';
      case NetworkType.threeG:
        return '3G';
      case NetworkType.fourG:
        return '4G';
      case NetworkType.fiveG:
        return '5G';
      case NetworkType.wifi:
        return 'WiFi';
      case NetworkType.unknown:
        return '';
    }
  }
}
