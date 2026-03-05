import 'package:expense/provider/receipt_provider.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ReceiptScanner extends HookConsumerWidget {
  const ReceiptScanner({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repo = ref.watch(receiptScannerServiceProvider);
    return Padding(
      padding: EdgeInsetsGeometry.only(top: 20),
      child: Column(
        children: [
          Material(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            child: InkWell(
              borderRadius: BorderRadius.circular(20),
              onTap: () => repo.scanReceipt(context, ref),
              child: Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Center(
                  child: Icon(
                    Icons.document_scanner,
                    color: Color.fromRGBO(245, 119, 153, 1),
                    size: 40,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 5),
          const Text("SCAN RECEIPT", style: TextStyle(fontWeight: FontWeight.w600)),
        ],
      ),
    );
    // return IconButton.filled(
    //   onPressed: () => repo.scanReceipt(context, ref),
    //   icon: Icon(Icons.document_scanner, color: Colors.black87),
    //   style: ButtonStyle(
    //     backgroundColor: WidgetStateProperty.all(
    //       Theme.of(context).colorScheme.secondary,
    //     ),
    //   ),
    // );
    // return IconButton(
    //   icon: const Icon(Icons.document_scanner),
    //   tooltip: "Scan Receipt",
    //   onPressed: () => repo.scanReceipt(context, ref),
    // );
  }
}
