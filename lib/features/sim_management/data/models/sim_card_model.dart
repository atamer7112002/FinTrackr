import 'package:fintech_task/features/sim_management/domain/entities/sim_card.dart';

class SimCardModel extends SimCard {
  const SimCardModel({
    required super.iccid,
    super.phoneNumber,
    required super.carrierName,
    super.countryCode,
    required super.slotIndex,
    required super.isActive,
    required super.connectionStatus,
    required super.signalStrength,
    required super.networkType,
    super.isRoaming,
    super.isDefaultDataSim,
  });

  factory SimCardModel.fromJson(Map<String, dynamic> json) {
    return SimCardModel(
      iccid: json['iccid'] as String,
      phoneNumber: json['phoneNumber'] as String?,
      carrierName: json['carrierName'] as String,
      countryCode: json['countryCode'] as String?,
      slotIndex: json['slotIndex'] as int,
      isActive: json['isActive'] as bool,
      connectionStatus: _parseConnectionStatus(
        json['connectionStatus'] as String,
      ),
      signalStrength: json['signalStrength'] as int,
      networkType: _parseNetworkType(json['networkType'] as String),
      isRoaming: json['isRoaming'] as bool? ?? false,
      isDefaultDataSim: json['isDefaultDataSim'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'iccid': iccid,
      'phoneNumber': phoneNumber,
      'carrierName': carrierName,
      'countryCode': countryCode,
      'slotIndex': slotIndex,
      'isActive': isActive,
      'connectionStatus': connectionStatus.name,
      'signalStrength': signalStrength,
      'networkType': networkType.name,
      'isRoaming': isRoaming,
      'isDefaultDataSim': isDefaultDataSim,
    };
  }

  static ConnectionStatus _parseConnectionStatus(String status) {
    switch (status.toLowerCase()) {
      case 'connected':
        return ConnectionStatus.connected;
      case 'connecting':
        return ConnectionStatus.connecting;
      default:
        return ConnectionStatus.notConnected;
    }
  }

  static NetworkType _parseNetworkType(String type) {
    switch (type.toLowerCase()) {
      case 'wifi':
        return NetworkType.wifi;
      case '2g':
        return NetworkType.twoG;
      case '3g':
        return NetworkType.threeG;
      case '4g':
      case 'lte':
        return NetworkType.fourG;
      case '5g':
        return NetworkType.fiveG;
      default:
        return NetworkType.unknown;
    }
  }

  SimCard toEntity() {
    return SimCard(
      iccid: iccid,
      phoneNumber: phoneNumber,
      carrierName: carrierName,
      countryCode: countryCode,
      slotIndex: slotIndex,
      isActive: isActive,
      connectionStatus: connectionStatus,
      signalStrength: signalStrength,
      networkType: networkType,
      isRoaming: isRoaming,
      isDefaultDataSim: isDefaultDataSim,
    );
  }
}
