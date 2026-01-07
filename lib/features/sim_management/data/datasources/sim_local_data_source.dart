import 'package:flutter/services.dart';
import '../models/sim_card_model.dart';

abstract class SimLocalDataSource {
  Future<List<SimCardModel>> getSimCards();
  Future<bool> checkPermissions();
  Future<bool> requestPermissions();
  Stream<List<SimCardModel>> watchSimCards();
}

class SimLocalDataSourceImpl implements SimLocalDataSource {
  static const MethodChannel _channel = MethodChannel('sim_manager');
  static const EventChannel _eventChannel = EventChannel('sim_manager_stream');

  @override
  Future<List<SimCardModel>> getSimCards() async {
    try {
      final result = await _channel.invokeMethod('getSimCards');
      final List<dynamic> simList = result as List<dynamic>;
      return simList
          .map(
            (json) =>
                SimCardModel.fromJson(Map<String, dynamic>.from(json as Map)),
          )
          .toList();
    } on PlatformException catch (e) {
      throw Exception('Failed to get SIM cards: ${e.message}');
    }
  }

  @override
  Future<bool> checkPermissions() async {
    try {
      final result = await _channel.invokeMethod('checkPermissions');
      return result as bool;
    } on PlatformException catch (e) {
      throw Exception('Failed to check permissions: ${e.message}');
    }
  }

  @override
  Future<bool> requestPermissions() async {
    try {
      final result = await _channel.invokeMethod('requestPermissions');
      return result as bool;
    } on PlatformException catch (e) {
      throw Exception('Failed to request permissions: ${e.message}');
    }
  }

  @override
  Stream<List<SimCardModel>> watchSimCards() {
    return _eventChannel.receiveBroadcastStream().map((event) {
      final List<dynamic> simList = event as List<dynamic>;
      return simList
          .map(
            (json) =>
                SimCardModel.fromJson(Map<String, dynamic>.from(json as Map)),
          )
          .toList();
    });
  }
}
