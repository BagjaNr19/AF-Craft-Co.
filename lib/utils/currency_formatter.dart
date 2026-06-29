import 'package:intl/intl.dart';

/// Utility class for formatting currency values in Indonesian Rupiah format.
class CurrencyFormatter {
  static final NumberFormat _idr = NumberFormat.currency(
    locale: 'id_ID',
    symbol: 'Rp',
    decimalDigits: 0,
  );

  static final NumberFormat _idrCompact = NumberFormat.compactCurrency(
    locale: 'id_ID',
    symbol: 'Rp',
    decimalDigits: 0,
  );

  static final NumberFormat _plain = NumberFormat('#,###', 'id_ID');

  /// Format as full IDR: Rp1.200.000
  static String format(num amount) {
    return _idr.format(amount);
  }

  /// Format as compact IDR: Rp1,2 jt
  static String formatCompact(num amount) {
    return _idrCompact.format(amount);
  }

  /// Format as number only: 1.200.000
  static String formatPlain(num amount) {
    return _plain.format(amount);
  }

  /// Parse IDR string back to double
  static double parse(String formattedAmount) {
    try {
      return _idr.parse(formattedAmount).toDouble();
    } catch (_) {
      final cleaned = formattedAmount
          .replaceAll('Rp', '')
          .replaceAll('.', '')
          .replaceAll(',', '')
          .trim();
      return double.tryParse(cleaned) ?? 0.0;
    }
  }

  /// Format price with discount
  static String formatDiscount(num originalPrice, num discountPercent) {
    final discounted = originalPrice * (1 - discountPercent / 100);
    return format(discounted);
  }
}
