import '../utils/currency_helper.dart';
import '../utils/date_helper.dart';

enum TransactionType { deposit, withdraw, transfer, qris }

class TransactionModel {
  final String id;
  final String title;
  final String subtitle;
  final double amount;
  final TransactionType type;
  final DateTime timestamp;
  final String accountName;

  TransactionModel({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.amount,
    required this.type,
    required this.timestamp,
    required this.accountName,
  });

  String get formattedAmount {
    final prefix = (type == TransactionType.deposit) ? '+' : '-';
    return '$prefix ${CurrencyHelper.format(amount)}';
  }

  String get formattedDate => DateHelper.formatDateTime(timestamp);
}