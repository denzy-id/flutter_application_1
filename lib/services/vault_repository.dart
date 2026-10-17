import '../models/account_model.dart';
import '../models/transaction_model.dart';
import '../models/user_model.dart';

class VaultRepository {
  // Mock Data Pengguna Default
  static final List<UserModel> _users = [
    UserModel(
      userId: 'ACC-882910',
      fullName: 'Deny',
      email: 'deny@myvault.id',
      password: 'password123',
      pin: '123456',
    ),
  ];

  // Mock Data Akun Bank & Portofolio
  static final List<BankAccount> _accounts = [
    BankAccount(
      id: '1',
      bankName: 'BCA Utama',
      accountNumber: '8830-1928-44',
      imageAssetPath: 'assets/images/bca.png',
      initialBalance: 125000000,
      accountCategory: 'Bank Utama',
      isFavorite: true,
    ),
    BankAccount(
      id: '2',
      bankName: 'Bank Mandiri Private',
      accountNumber: '1370-0092-881',
      imageAssetPath: 'assets/images/mandiri.png',
      initialBalance: 85000000,
      accountCategory: 'Bank Sekunder',
    ),
    BankAccount(
      id: '3',
      bankName: 'Saham BBCA',
      accountNumber: 'LOT-1500',
      imageAssetPath: 'assets/images/bca.png',
      initialBalance: 152500000,
      accountCategory: 'Investasi Saham',
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
      imageAssetPath: 'assets/images/bitcoin.png',
      initialBalance: 420000000,
      accountCategory: 'Kripto',
      isFavorite: true,
    ),
    BankAccount(
      id: '6',
      bankName: 'Ethereum (ETH) Portfolio',
      accountNumber: '3.1200 ETH',
      imageAssetPath: 'assets/images/ethereum.png',
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
    BankAccount(
      id: '8',
      bankName: 'TLKM',
      accountNumber: '500 LOT',
      imageAssetPath: 'assets/images/telkom.png',
      initialBalance: 50000000,
      accountCategory: 'Investasi Saham',
    ),
    BankAccount(
      id: '9',
      bankName: 'Astra International',
      accountNumber: '300 LOT',
      imageAssetPath: 'assets/images/astra.png',
      initialBalance: 75000000,
      accountCategory: 'Investasi Saham',
    ),
  ];

  static final List<TransactionModel> _transactions = [];

  // Getter
  static List<BankAccount> get accounts => _accounts;
  static List<TransactionModel> get transactions => _transactions;

  // Fitur Autentikasi User (Memperbaiki Error login & registerUser)
  static UserModel? login(String email, String password) {
    try {
      return _users.firstWhere(
        (u) => u.email.trim().toLowerCase() == email.trim().toLowerCase() && u.password == password,
      );
    } catch (_) {
      return null;
    }
  }

  static bool registerUser(UserModel newUser) {
    bool exists = _users.any((u) => u.email.trim().toLowerCase() == newUser.email.trim().toLowerCase());
    if (exists) return false;
    _users.add(newUser);
    return true;
  }

  // Operasi Manajemen Portofolio
  static void addAccount(BankAccount account) {
    _accounts.add(account);
  }

  static void deleteAccount(String id) {
    _accounts.removeWhere((acc) => acc.id == id);
  }

  static void logTransaction(TransactionModel transaction) {
    _transactions.insert(0, transaction);
  }
}