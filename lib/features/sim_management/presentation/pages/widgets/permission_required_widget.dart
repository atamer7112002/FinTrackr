import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../bloc/sim_bloc.dart';
import '../../bloc/sim_event.dart';

class PermissionRequiredWidget extends StatefulWidget {
  const PermissionRequiredWidget({super.key});

  @override
  State<PermissionRequiredWidget> createState() =>
      _PermissionRequiredWidgetState();
}

class _PermissionRequiredWidgetState extends State<PermissionRequiredWidget> {
  bool _isRequesting = false;

  Future<void> _handlePermissionRequest() async {
    setState(() => _isRequesting = true);

    final phoneStatus = await Permission.phone.request();
    final smsStatus = await Permission.sms.request();

    final granted = phoneStatus.isGranted && smsStatus.isGranted;

    if (mounted) {
      setState(() => _isRequesting = false);

      if (granted) {
        context.read<SimBloc>().add(LoadSimCards());
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Permission denied. Please grant permissions to continue.',
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.withOpacity(0.1)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: const BoxDecoration(
                color: Color(0xFFFFEBEE),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.shield_outlined,
                size: 48,
                color: Color(0xFFEF5350),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Permission Required',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'This app needs permission to access\nsim card information. Please grant the\nnecessary permissions.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
                height: 1.5,
              ),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: 180,
              child: ElevatedButton(
                onPressed: _isRequesting ? null : _handlePermissionRequest,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: _isRequesting
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
                    : const Text(
                        'Grant Permission',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
