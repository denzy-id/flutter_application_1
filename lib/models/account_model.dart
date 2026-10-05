import '../utils/currency_helper.dart';

class BankAccount {
  final String id;
  String bankName;
  String accountNumber;
  String imageAssetPath;
  String accountCategory;
  
  double _balance;
  bool _isFavorite;

  BankAccount({
    required this.id,
    required this.bankName,
    required this.accountNumber,
    required this.imageAssetPath,
    required double initialBalance,
    this.accountCategory = 'Bank Utama',
    bool isFavorite = false,
  })  : _balance = initialBalance,
        _isFavorite = isFavorite;

  double get balance => _balance;
  bool get isFavorite => _isFavorite;

  String get formattedBalance => CurrencyHelper.format(_balance);

  set balance(double newBalance) {
    if (newBalance >= 0) {
      _balance = newBalance;
    }
  }

  void deposit(double amount) {
    if (amount > 0) {
      _balance += amount;
    }
  }

  bool withdraw(double amount) {
    if (amount > 0 && _balance >= amount) {
      _balance -= amount;
      return true;
    }
    return false;
  }

  void toggleFavorite() {
    _isFavorite = !_isFavorite;
  }
}