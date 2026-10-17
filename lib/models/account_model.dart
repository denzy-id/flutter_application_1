class BankAccount {
  final String id;
  String bankName;
  String accountNumber;
  String imageAssetPath;
  double balance;
  String accountCategory;
  bool isFavorite;

  BankAccount({
    required this.id,
    required this.bankName,
    required this.accountNumber,
    required this.imageAssetPath,
    required double initialBalance,
    required this.accountCategory,
    this.isFavorite = false,
  }) : balance = initialBalance;

  String get formattedBalance {
    return 'Rp ${balance.toStringAsFixed(0).replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]}.',
    )}';
  }

  bool withdraw(double amount) {
    if (balance >= amount) {
      balance -= amount;
      return true;
    }
    return false;
  }
}