class CurrencyHelper {
  static String format(double amount) {
    final String numStr = amount.toStringAsFixed(0);
    final RegExp reg = RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
    return 'Rp ${numStr.replaceAllMapped(reg, (Match m) => '${m[1]}.')}';
  }
}