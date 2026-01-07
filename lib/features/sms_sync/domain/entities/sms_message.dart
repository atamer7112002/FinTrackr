import 'package:equatable/equatable.dart';

class SmsMessage extends Equatable {
  final String id;
  final String address;
  final String body;
  final DateTime date;
  final bool isFinancial;
  final SmsCategory category;

  const SmsMessage({
    required this.id,
    required this.address,
    required this.body,
    required this.date,
    required this.isFinancial,
    required this.category,
  });

  @override
  List<Object?> get props => [id, address, body, date, isFinancial, category];
}

enum SmsCategory { otp, transaction, balance, payment, general }
