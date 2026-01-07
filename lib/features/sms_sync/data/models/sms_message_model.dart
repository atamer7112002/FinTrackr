import 'package:fintech_task/features/sms_sync/domain/entities/sms_message.dart';

class SmsMessageModel extends SmsMessage {
  const SmsMessageModel({
    required super.id,
    required super.address,
    required super.body,
    required super.date,
    required super.isFinancial,
    required super.category,
  });

  factory SmsMessageModel.fromJson(Map<String, dynamic> json) {
    return SmsMessageModel(
      id: json['id'] as String,
      address: json['address'] as String,
      body: json['body'] as String,
      date: DateTime.fromMillisecondsSinceEpoch(json['date'] as int),
      isFinancial: json['isFinancial'] as bool,
      category: _parseCategoryFromString(json['category'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'address': address,
      'body': body,
      'date': date.millisecondsSinceEpoch,
      'isFinancial': isFinancial,
      'category': category.name,
    };
  }

  static SmsCategory _parseCategoryFromString(String category) {
    switch (category.toLowerCase()) {
      case 'otp':
        return SmsCategory.otp;
      case 'transaction':
        return SmsCategory.transaction;
      case 'balance':
        return SmsCategory.balance;
      case 'payment':
        return SmsCategory.payment;
      default:
        return SmsCategory.general;
    }
  }
}
