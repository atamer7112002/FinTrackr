import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/entities/sim_card.dart';
import '../../bloc/sim_bloc.dart';
import '../../bloc/sim_event.dart';

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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'SIM ${simCard.slotIndex}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: simCard.isActive
                      ? const Color(0xFFE8F5E9)
                      : const Color(0xFFFFEBEE),
                  borderRadius: BorderRadius.circular(12),
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
          const SizedBox(height: 8),
          Text(
            simCard.phoneNumber ?? 'Unknown',
            style: TextStyle(fontSize: 14, color: Colors.grey[600]),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: const Color(0xFF7C4DFF).withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.wifi, color: Color(0xFF7C4DFF)),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Network Provider',
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      simCard.carrierName,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                children: [
                  Icon(
                    Icons.signal_cellular_alt,
                    color: _getSignalColor(simCard.signalStrength),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Signal',
                    style: TextStyle(fontSize: 10, color: Colors.grey[600]),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _buildStatusChip(
                Icons.check_circle,
                'System Status',
                _getConnectionStatusText(simCard.connectionStatus),
                _getConnectionStatusColor(simCard.connectionStatus),
              ),
              const SizedBox(width: 8),
              _buildStatusChip(
                Icons.signal_cellular_alt,
                'Network',
                _getNetworkTypeText(simCard.networkType),
                const Color(0xFF2196F3),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                context.read<SimBloc>().add(SyncSimCards());
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                simCard.connectionStatus == ConnectionStatus.connected
                    ? 'Sync SIM'
                    : 'Check Connection',
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusChip(
    IconData icon,
    String label,
    String value,
    Color color,
  ) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey[600]),
        const SizedBox(width: 4),
        Text(
          '$label : ',
          style: TextStyle(fontSize: 12, color: Colors.grey[600]),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            value,
            style: TextStyle(
              fontSize: 12,
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Color _getSignalColor(int strength) {
    if (strength >= 3) return Colors.green;
    if (strength >= 2) return Colors.orange;
    return Colors.red;
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
        return const Color(0xFF4CAF50);
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
        return 'Unknown';
    }
  }
}
