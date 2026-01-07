import 'package:flutter/services.dart';
import '../models/sms_message_model.dart';

abstract class SmsLocalDataSource {
  Future<List<SmsMessageModel>> getFinancialSms();
  Future<bool> checkPermissions();
  Future<bool> requestPermissions();
}

class SmsLocalDataSourceImpl implements SmsLocalDataSource {
  static const MethodChannel _channel = MethodChannel('sms_manager');

  @override
  Future<List<SmsMessageModel>> getFinancialSms() async {
    try {
      final result = await _channel.invokeMethod('getFinancialSms');
      final List<dynamic> smsList = result as List<dynamic>;
      return smsList
          .map(
            (json) => SmsMessageModel.fromJson(
              Map<String, dynamic>.from(json as Map),
            ),
          )
          .toList();
    } on PlatformException catch (e) {
      throw Exception('Failed to get SMS: ${e.message}');
    }
  }

  @override
  Future<bool> checkPermissions() async {
    try {
      final result = await _channel.invokeMethod('checkSmsPermissions');
      return result as bool;
    } on PlatformException catch (e) {
      throw Exception('Failed to check permissions: ${e.message}');
    }
  }

  @override
  Future<bool> requestPermissions() async {
    try {
      final result = await _channel.invokeMethod('requestSmsPermissions');
      return result as bool;
    } on PlatformException catch (e) {
      throw Exception('Failed to request permissions: ${e.message}');
    }
  }
}
