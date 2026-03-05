import 'package:expense/services/receipt_scanner_service.dart';
import 'package:hooks_riverpod/legacy.dart';

final receiptScannerServiceProvider = StateProvider((ref) {
  return ReceiptScannerService();
});
