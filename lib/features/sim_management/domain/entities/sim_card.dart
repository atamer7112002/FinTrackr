import 'package:equatable/equatable.dart';

class SimCard extends Equatable {
  final String iccid;
  final String? phoneNumber;
  final String carrierName;
  final String? countryCode;
  final int slotIndex;
  final bool isActive;
  final ConnectionStatus connectionStatus;
  final int signalStrength;
  final NetworkType networkType;
  final bool isRoaming;
  final bool isDefaultDataSim;

  const SimCard({
    required this.iccid,
    this.phoneNumber,
    required this.carrierName,
    this.countryCode,
    required this.slotIndex,
    required this.isActive,
    required this.connectionStatus,
    required this.signalStrength,
    required this.networkType,
    this.isRoaming = false,
    this.isDefaultDataSim = false,
  });

  @override
  List<Object?> get props => [
    iccid,
    phoneNumber,
    carrierName,
    countryCode,
    slotIndex,
    isActive,
    connectionStatus,
    signalStrength,
    networkType,
    isRoaming,
    isDefaultDataSim,
  ];
}

enum ConnectionStatus { connected, notConnected, connecting }

enum NetworkType { unknown, wifi, twoG, threeG, fourG, fiveG }
