import '../models/user_model.dart';
import '../models/account_model.dart';
import '../models/transaction_model.dart';

class VaultRepository {
  static final List<UserModel> _users = [
    UserModel(
      userId: 'USR-8892',
      fullName: 'Budi Santoso',
      email: 'budi@vault.id',
      password: 'password123',
      pin: '123456',
    ),
  ];

  static final List<BankAccount> _accounts = [
    BankAccount(
      id: '1',
      bankName: 'BCA Private Banking',
      accountNumber: '8830192841',
      imageAssetPath: 'assets/images/bca.png',
      initialBalance: 245000000,
      accountCategory: 'Bank Utama',
      isFavorite: true,
    ),
    BankAccount(
      id: '2',
      bankName: 'Mandiri Privilege',
      accountNumber: '142001928374',
      imageAssetPath: 'assets/images/mandiri.png',
      initialBalance: 182500000,
      accountCategory: 'Bank Sekunder',
    ),
    BankAccount(
      id: '3',
      bankName: 'Saham BBCA (Bank Central Asia)',
      accountNumber: 'LOT-1500',
      imageAssetPath: 'assets/images/bca.png',
      initialBalance: 152250000,
      accountCategory: 'Investasi Saham',
      isFavorite: true,
    ),
    BankAccount(
      id: '4',
      bankName: 'Welma Portfolio Gold',
      accountNumber: 'RDN-991823',
      imageAssetPath: 'assets/images/welma.png',
      initialBalance: 316750000,
      accountCategory: 'Investasi Saham',
    ),
    BankAccount(
      id: '5',
      bankName: 'Bitcoin (BTC) Vault',
      accountNumber: '0.4285 BTC',
      imageAssetPath: 'assets/images/welma.png',
      initialBalance: 420000000,
      accountCategory: 'Kripto',
      isFavorite: true,
    ),
    BankAccount(
      id: '6',
      bankName: 'Ethereum (ETH) Portfolio',
      accountNumber: '3.1200 ETH',
      imageAssetPath: 'assets/images/welma.png',
      initialBalance: 165000000,
      accountCategory: 'Kripto',
    ),
    BankAccount(
      id: '7',
      bankName: 'GoPay Platinum',
      accountNumber: '081298765432',
      imageAssetPath: 'assets/images/gopay.png',
      initialBalance: 8500000,
      accountCategory: 'E-Wallet',
    ),
  ];

  static final List<TransactionModel> _transactions = [
    TransactionModel(
      id: 'tx_1',
      title: 'Deposit Modal Saham',
      subtitle: 'Setoran Dana RDN Welma',
      amount: 15000000,
      type: TransactionType.deposit,
      timestamp: DateTime.now().subtract(const Duration(hours: 4)),
      accountName: 'Welma Portfolio Gold',
    ),
    TransactionModel(
      id: 'tx_2',
      title: 'Pembayaran QRIS Starbucks',
      subtitle: 'Pembelian Kopi & Snack',
      amount: 75000,
      type: TransactionType.qris,
      timestamp: DateTime.now().subtract(const Duration(hours: 18)),
      accountName: 'GoPay Platinum',
    ),
  ];

  static List<BankAccount> get accounts => _accounts;
  static List<TransactionModel> get transactions => _transactions;

  static bool registerUser(UserModel newUser) {
    final exists = _users.any(
      (u) => u.email.toLowerCase() == newUser.email.toLowerCase() || u.userId == newUser.userId,
    );
    if (exists) return false;
    _users.add(newUser);
    return true;
  }

  static UserModel? login(String identifier, String password) {
    for (var u in _users) {
      if ((u.email.toLowerCase() == identifier.toLowerCase() ||
              u.userId.toLowerCase() == identifier.toLowerCase()) &&
          u.password == password) {
        return u;
      }
    }
    return null;
  }

  static void addAccount(BankAccount acc) {
    _accounts.add(acc);
  }

  static void deleteAccount(String id) {
    _accounts.removeWhere((acc) => acc.id == id);
  }

  static void logTransaction(TransactionModel tx) {
    _transactions.insert(0, tx);
  }
}