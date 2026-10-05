import 'package:flutter/material.dart';
import 'login_page.dart';
import '../models/user_model.dart';
import '../models/account_model.dart';
import '../models/transaction_model.dart';
import '../models/developer_model.dart';
import '../services/vault_repository.dart';
import '../utils/currency_helper.dart';
import '../utils/date_helper.dart';

class HomePage extends StatefulWidget {
  final UserModel user;

  const HomePage({super.key, required this.user});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final DeveloperModel _developerInfo = DeveloperModel(
    developerName: 'myVault Private Banking',
    role: 'Lead Architect & Tech Lead',
    appVersion: 'v6.0.0 Master Pro Edition',
    techStack: const ['Flutter 3.x', 'Clean OOP', 'PIN Security', 'NetWorth Chart', 'Export PDF/CSV'],
    bio: 'Platform Agregasi Kekayaan & Portofolio Manajemen Terpadu dengan fitur Saham, Kripto, Transfer, QRIS, & Export Report.',
    email: 'private@myvault.wealth.id',
  );

  bool _hideBalance = false;
  String _selectedCategory = 'Semua';
  String _searchQuery = '';

  List<BankAccount> get _accounts => VaultRepository.accounts;
  double get _totalNetWorth => _accounts.fold(0, (sum, acc) => sum + acc.balance);

  List<BankAccount> get _filteredAccounts {
    return _accounts.where((acc) {
      final matchesCategory = _selectedCategory == 'Semua' || acc.accountCategory == _selectedCategory;
      final matchesSearch = acc.bankName.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          acc.accountNumber.contains(_searchQuery);
      return matchesCategory && matchesSearch;
    }).toList();
  }

  void _showExportReportModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
          ),
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(child: Container(width: 44, height: 5, decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(10)))),
              const SizedBox(height: 18),
              Row(
                children: const [
                  Icon(Icons.picture_as_pdf_rounded, color: Color(0xFFD97706), size: 26),
                  SizedBox(width: 10),
                  Text('Export Laporan Keuangan', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
                ],
              ),
              const SizedBox(height: 6),
              Text('Ringkasan Rekapitulasi Portofolio ${DateHelper.formatDateOnly(DateTime.now())}', style: const TextStyle(fontSize: 12, color: Color(0xFF64748B))),
              const SizedBox(height: 20),

              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(color: const Color(0xFFF8FAFC), borderRadius: BorderRadius.circular(16), border: Border.all(color: const Color(0xFFE2E8F0))),
                child: Column(
                  children: [
                    _buildReportSummaryRow('Pemilik Akun', widget.user.fullName),
                    _buildReportSummaryRow('ID Akses', widget.user.userId),
                    _buildReportSummaryRow('Total Net Worth', CurrencyHelper.format(_totalNetWorth)),
                    _buildReportSummaryRow('Total Portofolio', '${_accounts.length} Aset'),
                    _buildReportSummaryRow('Status Keuangan', 'Sehat & Terverifikasi'),
                  ],
                ),
              ),
              const SizedBox(height: 22),

              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 48,
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.download_rounded, size: 18),
                        label: const Text('Cetak PDF'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF0F172A),
                          foregroundColor: const Color(0xFFFBBF24),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Laporan PDF berhasil diunduh ke folder dokumen!'), backgroundColor: Color(0xFF059669)),
                          );
                        },
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: SizedBox(
                      height: 48,
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.table_chart_rounded, size: 18),
                        label: const Text('Export CSV'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFF1F5F9),
                          foregroundColor: const Color(0xFF0F172A),
                          elevation: 0,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Laporan CSV berhasil disalin ke clipboard!'), backgroundColor: Color(0xFF059669)),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        );
      },
    );
  }

  Widget _buildReportSummaryRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 12, color: Color(0xFF64748B))),
          Text(value, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
        ],
      ),
    );
  }

  Widget _buildNetWorthGrowthChart() {
    const List<double> growthData = [0.65, 0.72, 0.68, 0.82, 0.88, 0.92, 1.0];
    const List<String> days = ['Sen', 'Sel', 'Rab', 'Kam', 'Jum', 'Sab', 'Ming'];

    return Container(
      margin: const EdgeInsets.only(top: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text('Tren Pertumbuhan 7 Hari', style: TextStyle(color: Colors.white70, fontSize: 11, fontWeight: FontWeight.bold)),
              Icon(Icons.trending_up_rounded, color: Color(0xFF34D399), size: 16),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: List.generate(growthData.length, (index) {
              return Column(
                children: [
                  Container(
                    width: 14,
                    height: 38 * growthData[index],
                    decoration: BoxDecoration(
                      color: index == growthData.length - 1 ? const Color(0xFFFBBF24) : Colors.white38,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(days[index], style: const TextStyle(color: Colors.white54, fontSize: 9)),
                ],
              );
            }),
          )
        ],
      ),
    );
  }

  Future<bool> _verifySecurityPin() async {
    final pinController = TextEditingController();
    bool isValid = false;

    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          title: Row(
            children: const [
              Icon(Icons.security_rounded, color: Color(0xFFD97706), size: 24),
              SizedBox(width: 8),
              Text('Konfirmasi PIN', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Masukkan 6-digit PIN Keamanan Anda untuk memproses transaksi ini.', style: TextStyle(color: Color(0xFF64748B), fontSize: 12)),
              const SizedBox(height: 16),
              TextField(
                controller: pinController,
                obscureText: true,
                keyboardType: TextInputType.number,
                maxLength: 6,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, letterSpacing: 8, color: Color(0xFF0F172A)),
                decoration: InputDecoration(
                  counterText: '',
                  hintText: '••••••',
                  filled: true,
                  fillColor: const Color(0xFFF8FAFC),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
                ),
              ),
              const SizedBox(height: 6),
              const Text('*PIN Default: 123456', style: TextStyle(color: Color(0xFF94A3B8), fontSize: 10, fontStyle: FontStyle.italic)),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('BATAL', style: TextStyle(color: Color(0xFF64748B), fontWeight: FontWeight.bold)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0F172A),
                foregroundColor: const Color(0xFFFBBF24),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              onPressed: () {
                if (pinController.text == widget.user.pin) {
                  isValid = true;
                  Navigator.pop(dialogContext);
                } else {
                  ScaffoldMessenger.of(dialogContext).showSnackBar(const SnackBar(content: Text('PIN Salah! Silakan coba lagi.')));
                }
              },
              child: const Text('VERIFIKASI', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ],
        );
      },
    );

    return isValid;
  }

  void _showTransactionHistoryModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        final txList = VaultRepository.transactions;
        return Container(
          height: MediaQuery.of(context).size.height * 0.75,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
          ),
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(child: Container(width: 44, height: 5, decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(10)))),
              const SizedBox(height: 18),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Riwayat Transaksi', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
                  Text('${txList.length} Transaksi', style: const TextStyle(fontSize: 12, color: Color(0xFF64748B))),
                ],
              ),
              const SizedBox(height: 16),
              Expanded(
                child: txList.isEmpty
                    ? const Center(child: Text('Belum ada riwayat transaksi.', style: TextStyle(color: Color(0xFF94A3B8))))
                    : ListView.builder(
                        itemCount: txList.length,
                        itemBuilder: (context, index) {
                          final tx = txList[index];
                          final isDeposit = tx.type == TransactionType.deposit;
                          return Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF8FAFC),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: const Color(0xFFE2E8F0)),
                            ),
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundColor: isDeposit ? const Color(0xFFECFDF5) : const Color(0xFFFEF2F2),
                                child: Icon(
                                  isDeposit ? Icons.arrow_downward_rounded : Icons.arrow_upward_rounded,
                                  color: isDeposit ? const Color(0xFF059669) : Colors.redAccent,
                                ),
                              ),
                              title: Text(tx.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF0F172A))),
                              subtitle: Text('${tx.accountName} • ${tx.formattedDate}', style: const TextStyle(fontSize: 11, color: Color(0xFF64748B))),
                              trailing: Text(
                                tx.formattedAmount,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                  color: isDeposit ? const Color(0xFF059669) : Colors.redAccent,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
              )
            ],
          ),
        );
      },
    );
  }

  void _showEditDeleteAssetModal(BankAccount account) {
    final nameController = TextEditingController(text: account.bankName);
    final accNumController = TextEditingController(text: account.accountNumber);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (modalContext) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
          ),
          padding: EdgeInsets.only(
            left: 24, right: 24, top: 20,
            bottom: MediaQuery.of(modalContext).viewInsets.bottom + 24,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(child: Container(width: 44, height: 5, decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(10)))),
              const SizedBox(height: 18),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Kelola Aset "${account.bankName}"', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
                  IconButton(
                    icon: const Icon(Icons.delete_outline_rounded, color: Colors.redAccent),
                    onPressed: () {
                      VaultRepository.deleteAccount(account.id);
                      setState(() {});
                      Navigator.pop(modalContext);
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Aset "${account.bankName}" telah dihapus.')));
                    },
                  )
                ],
              ),
              const SizedBox(height: 14),
              _buildLightInput(controller: nameController, label: 'Ubah Nama Aset', icon: Icons.edit_outlined),
              const SizedBox(height: 12),
              _buildLightInput(controller: accNumController, label: 'Ubah Nomor Rekening / ID', icon: Icons.numbers_rounded),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0F172A),
                    foregroundColor: const Color(0xFFFBBF24),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: () {
                    setState(() {
                      account.bankName = nameController.text.trim();
                      account.accountNumber = accNumController.text.trim();
                    });
                    Navigator.pop(modalContext);
                  },
                  child: const Text('SIMPAN PERUBAHAN', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              )
            ],
          ),
        );
      },
    );
  }

  void _showAddAccountDialog() {
    final bankNameController = TextEditingController();
    final accountNumberController = TextEditingController();
    final balanceController = TextEditingController();

    String selectedCategory = 'Investasi Saham';
    String selectedImagePath = 'assets/images/welma.png';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
              ),
              padding: EdgeInsets.only(
                left: 24, right: 24, top: 16,
                bottom: MediaQuery.of(sheetContext).viewInsets.bottom + 24,
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(child: Container(width: 44, height: 5, decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(10)))),
                    const SizedBox(height: 18),
                    const Text('Tambah Aset / Portofolio Baru', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
                    const SizedBox(height: 16),

                    _buildLightInput(controller: bankNameController, label: 'Nama Aset / Institusi', icon: Icons.account_balance_outlined),
                    const SizedBox(height: 12),
                    _buildLightInput(controller: accountNumberController, label: 'Nomor Rekening / Lot / Jumlah Koin', icon: Icons.numbers_rounded),
                    const SizedBox(height: 12),
                    _buildLightInput(controller: balanceController, label: 'Saldo Awal (Rp)', icon: Icons.attach_money_rounded, keyboardType: TextInputType.number),
                    const SizedBox(height: 20),

                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF0F172A),
                          foregroundColor: const Color(0xFFFBBF24),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                        ),
                        onPressed: () {
                          final name = bankNameController.text.trim();
                          final accNum = accountNumberController.text.trim();
                          final balance = double.tryParse(balanceController.text) ?? 0;

                          if (name.isNotEmpty && accNum.isNotEmpty) {
                            setState(() {
                              VaultRepository.addAccount(
                                BankAccount(
                                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                                  bankName: name,
                                  accountNumber: accNum,
                                  imageAssetPath: selectedImagePath,
                                  initialBalance: balance,
                                  accountCategory: selectedCategory,
                                ),
                              );
                            });
                            Navigator.pop(sheetContext);
                          }
                        },
                        child: const Text('SIMPAN ASET BARU', style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    )
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _showTransferDialog() {
    BankAccount selectedSource = _accounts.first;
    final recipientAccController = TextEditingController();
    final recipientBankController = TextEditingController(text: 'BCA');
    final amountController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (modalContext) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
              ),
              padding: EdgeInsets.only(
                left: 24, right: 24, top: 20,
                bottom: MediaQuery.of(modalContext).viewInsets.bottom + 24,
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(child: Container(width: 44, height: 5, decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(10)))),
                    const SizedBox(height: 18),
                    const Text('Transfer Dana Instant', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
                    const SizedBox(height: 16),

                    _buildLightInput(controller: recipientBankController, label: 'Bank Tujuan', icon: Icons.account_balance_outlined),
                    const SizedBox(height: 12),
                    _buildLightInput(controller: recipientAccController, label: 'Nomor Rekening Tujuan', icon: Icons.credit_card_rounded, keyboardType: TextInputType.number),
                    const SizedBox(height: 12),
                    _buildLightInput(controller: amountController, label: 'Nominal Transfer (Rp)', icon: Icons.attach_money_rounded, keyboardType: TextInputType.number),
                    const SizedBox(height: 22),

                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF0F172A),
                          foregroundColor: const Color(0xFFFBBF24),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                        ),
                        onPressed: () async {
                          final amount = double.tryParse(amountController.text) ?? 0;
                          final recipient = recipientAccController.text.trim();

                          if (amount <= 0 || recipient.isEmpty) return;

                          // Tangkap konteks sebelum async gap untuk menghindari warning use_build_context_synchronously
                          final navigator = Navigator.of(modalContext);
                          final messenger = ScaffoldMessenger.of(context);

                          final pinOk = await _verifySecurityPin();
                          if (!pinOk) return;

                          final success = selectedSource.withdraw(amount);
                          if (success) {
                            VaultRepository.logTransaction(
                              TransactionModel(
                                id: DateTime.now().toString(),
                                title: 'Transfer ke $recipient',
                                subtitle: 'Transfer Bank ${recipientBankController.text}',
                                amount: amount,
                                type: TransactionType.transfer,
                                timestamp: DateTime.now(),
                                accountName: selectedSource.bankName,
                              ),
                            );
                            setState(() {});
                            navigator.pop();
                            messenger.showSnackBar(SnackBar(content: Text('Transfer ${CurrencyHelper.format(amount)} sukses!'), backgroundColor: const Color(0xFF059669)));
                          }
                        },
                        child: const Text('VERIFIKASI & KIRIM DANA', style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    )
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _showQrisDialog() {
    BankAccount selectedSource = _accounts.first;
    final merchantController = TextEditingController(text: 'Starbucks Reserve');
    final amountController = TextEditingController(text: '75000');

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (modalContext) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
              ),
              padding: EdgeInsets.only(
                left: 24, right: 24, top: 20,
                bottom: MediaQuery.of(modalContext).viewInsets.bottom + 24,
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(width: 44, height: 5, decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(10))),
                    const SizedBox(height: 18),
                    
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(color: const Color(0xFF0F172A), borderRadius: BorderRadius.circular(20)),
                      child: Column(
                        children: const [
                          Icon(Icons.qr_code_2_rounded, size: 90, color: Color(0xFFFBBF24)),
                          SizedBox(height: 6),
                          Text('PEMINDAI QRIS NASIONAL', style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 1)),
                        ],
                      ),
                    ),
                    const SizedBox(height: 18),

                    _buildLightInput(controller: merchantController, label: 'Nama Merchant / Toko', icon: Icons.storefront_rounded),
                    const SizedBox(height: 12),
                    _buildLightInput(controller: amountController, label: 'Nominal Pembayaran (Rp)', icon: Icons.payments_outlined, keyboardType: TextInputType.number),
                    const SizedBox(height: 20),

                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF059669),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                        ),
                        onPressed: () async {
                          final amount = double.tryParse(amountController.text) ?? 0;
                          if (amount <= 0) return;

                          // Tangkap konteks sebelum async gap
                          final navigator = Navigator.of(modalContext);
                          final messenger = ScaffoldMessenger.of(context);

                          final pinOk = await _verifySecurityPin();
                          if (!pinOk) return;

                          final success = selectedSource.withdraw(amount);
                          if (success) {
                            VaultRepository.logTransaction(
                              TransactionModel(
                                id: DateTime.now().toString(),
                                title: 'Pembayaran QRIS',
                                subtitle: merchantController.text,
                                amount: amount,
                                type: TransactionType.qris,
                                timestamp: DateTime.now(),
                                accountName: selectedSource.bankName,
                              ),
                            );
                            setState(() {});
                            navigator.pop();
                            messenger.showSnackBar(SnackBar(content: Text('Pembayaran QRIS ${CurrencyHelper.format(amount)} Berhasil!'), backgroundColor: const Color(0xFF059669)));
                          }
                        },
                        child: const Text('VERIFIKASI & BAYAR QRIS', style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    )
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _showAboutMeModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
          ),
          padding: const EdgeInsets.all(28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(width: 44, height: 5, decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(10))),
              const SizedBox(height: 20),
              
              Container(
                width: 80,
                height: 80,
                padding: const EdgeInsets.all(3),
                decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: const Color(0xFFD97706), width: 2)),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(40),
                  child: Image.asset(_developerInfo.avatarPath, fit: BoxFit.cover, errorBuilder: (_, __, ___) => const Icon(Icons.person, size: 50, color: Color(0xFF0F172A))),
                ),
              ),
              const SizedBox(height: 14),
              Text(_developerInfo.developerName, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
              Text(_developerInfo.role, style: const TextStyle(color: Color(0xFFD97706), fontSize: 13, fontWeight: FontWeight.w600)),
              const SizedBox(height: 12),
              Text(_developerInfo.bio, textAlign: TextAlign.center, style: const TextStyle(fontSize: 13, color: Color(0xFF64748B), height: 1.4)),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0F172A),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  onPressed: () => Navigator.pop(context),
                  child: const Text('TUTUP PROFIL', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        title: Row(
          children: [
            GestureDetector(
              onTap: _showAboutMeModal,
              child: Container(
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: const Color(0xFFD97706), width: 1.5)),
                child: CircleAvatar(
                  radius: 17,
                  backgroundColor: const Color(0xFF0F172A),
                  child: Text(
                    widget.user.fullName.isNotEmpty ? widget.user.fullName[0].toUpperCase() : 'U',
                    style: const TextStyle(color: Color(0xFFFBBF24), fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${widget.user.timeGreeting},', style: const TextStyle(fontSize: 11, color: Color(0xFF64748B))),
                Text(widget.user.fullName, style: const TextStyle(fontSize: 15, color: Color(0xFF0F172A), fontWeight: FontWeight.bold)),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.picture_as_pdf_outlined, color: Color(0xFFD97706)),
            tooltip: 'Export Laporan',
            onPressed: _showExportReportModal,
          ),
          IconButton(
            icon: const Icon(Icons.history_rounded, color: Color(0xFF0F172A)),
            tooltip: 'Riwayat Transaksi',
            onPressed: _showTransactionHistoryModal,
          ),
          IconButton(
            icon: const Icon(Icons.logout_rounded, color: Color(0xFF64748B)),
            onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const LoginPage())),
          )
        ],
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(18.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(22),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(colors: [Color(0xFF0F172A), Color(0xFF1E293B)]),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.verified_rounded, size: 16, color: Color(0xFFFBBF24)),
                                const SizedBox(width: 6),
                                Text('TOTAL NET WORTH • ${widget.user.userId}', style: const TextStyle(color: Color(0xFFFBBF24), fontSize: 10, fontWeight: FontWeight.bold)),
                              ],
                            ),
                            IconButton(
                              constraints: const BoxConstraints(),
                              padding: EdgeInsets.zero,
                              icon: Icon(_hideBalance ? Icons.visibility_off_rounded : Icons.visibility_rounded, color: Colors.white70, size: 20),
                              onPressed: () => setState(() => _hideBalance = !_hideBalance),
                            )
                          ],
                        ),
                        const SizedBox(height: 10),
                        Text(
                          _hideBalance ? 'Rp ••••••••' : CurrencyHelper.format(_totalNetWorth),
                          style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                        _buildNetWorthGrowthChart(),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildQuickAction(Icons.picture_as_pdf_rounded, 'Laporan', _showExportReportModal),
                      _buildQuickAction(Icons.history_rounded, 'Riwayat', _showTransactionHistoryModal),
                      _buildQuickAction(Icons.swap_horiz_rounded, 'Transfer', _showTransferDialog),
                      _buildQuickAction(Icons.qr_code_scanner_rounded, 'Bayar QR', _showQrisDialog),
                      _buildQuickAction(Icons.add_chart_rounded, 'Aset Baru', _showAddAccountDialog),
                    ],
                  ),

                  const SizedBox(height: 22),

                  TextField(
                    onChanged: (val) => setState(() => _searchQuery = val),
                    style: const TextStyle(color: Color(0xFF0F172A), fontSize: 13, fontWeight: FontWeight.w600),
                    decoration: InputDecoration(
                      hintText: 'Cari nama aset, saham, kripto, atau rekening...',
                      hintStyle: const TextStyle(color: Color(0xFF94A3B8), fontSize: 13),
                      prefixIcon: const Icon(Icons.search_rounded, color: Color(0xFFD97706), size: 20),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
                    ),
                  ),

                  const SizedBox(height: 14),

                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: ['Semua', 'Bank Utama', 'Bank Sekunder', 'Investasi Saham', 'Kripto', 'E-Wallet'].map((cat) {
                        final isSelected = _selectedCategory == cat;
                        return Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: ChoiceChip(
                            label: Text(cat),
                            selected: isSelected,
                            selectedColor: const Color(0xFF0F172A),
                            backgroundColor: Colors.white,
                            labelStyle: TextStyle(
                              color: isSelected ? const Color(0xFFFBBF24) : const Color(0xFF64748B),
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                              fontSize: 12,
                            ),
                            onSelected: (_) => setState(() => _selectedCategory = cat),
                          ),
                        );
                      }).toList(),
                    ),
                  ),

                  const SizedBox(height: 20),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Daftar Aset Terhubung', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
                      Text('${_filteredAccounts.length} Aset Tampil', style: const TextStyle(fontSize: 12, color: Color(0xFF64748B))),
                    ],
                  ),
                ],
              ),
            ),
          ),

          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 18.0),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final account = _filteredAccounts[index];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                      leading: Container(
                        width: 44,
                        height: 44,
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(color: const Color(0xFFF8FAFC), borderRadius: BorderRadius.circular(12)),
                        child: Image.asset(account.imageAssetPath, fit: BoxFit.contain, errorBuilder: (_, __, ___) => const Icon(Icons.account_balance, color: Color(0xFF0F172A))),
                      ),
                      title: Row(
                        children: [
                          Expanded(child: Text(account.bankName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF0F172A)), overflow: TextOverflow.ellipsis)),
                          if (account.isFavorite) ...[
                            const SizedBox(width: 4),
                            const Icon(Icons.star_rounded, size: 16, color: Color(0xFFD97706)),
                          ]
                        ],
                      ),
                      subtitle: Text('${account.accountCategory} • ${account.accountNumber}', style: const TextStyle(color: Color(0xFF64748B), fontSize: 11)),
                      trailing: Text(_hideBalance ? 'Rp ••••••' : account.formattedBalance, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF0F172A))),
                      onTap: () => _showEditDeleteAssetModal(account),
                    ),
                  );
                },
                childCount: _filteredAccounts.length,
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 80)),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddAccountDialog,
        backgroundColor: const Color(0xFF0F172A),
        icon: const Icon(Icons.add, color: Color(0xFFFBBF24)),
        label: const Text('Tambah Aset', style: TextStyle(color: Color(0xFFFBBF24), fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _buildQuickAction(IconData icon, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: const Color(0xFFE2E8F0))),
            child: Icon(icon, color: const Color(0xFF0F172A), size: 20),
          ),
          const SizedBox(height: 6),
          Text(label, style: const TextStyle(fontSize: 10, color: Color(0xFF0F172A), fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  Widget _buildLightInput({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      style: const TextStyle(color: Color(0xFF0F172A), fontSize: 13, fontWeight: FontWeight.w600),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Color(0xFF64748B), fontSize: 12),
        prefixIcon: Icon(icon, color: const Color(0xFFD97706), size: 20),
        filled: true,
        fillColor: const Color(0xFFF8FAFC),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
      ),
    );
  }
}