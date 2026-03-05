import 'package:expense/provider/category_providers.dart';
import 'package:expense/provider/expense_provider.dart';
import 'package:expense/repositories/category_repository.dart';
import 'package:expense/repositories/expenses_repository.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_picker/image_picker.dart';

class ReceiptScannerService {
  double? _extractTotal(String text) {
    final lines = text
        .split('\n')
        .map((line) => line.trim())
        .where((line) => line.isNotEmpty)
        .toList();

    final totalPatterns = [
      RegExp(
        r'(TOTAL|Total|total|Amount Due|Net Total|Balance Due)[^\d]*(\d+\.\d{2})',
      ),
      RegExp(r'(\d+\.\d{2})'),
    ];

    for (var line in lines.reversed) {
      for (var pattern in totalPatterns) {
        final match = pattern.firstMatch(line);
        if (match != null) {
          String? valueStr;
          if (match.groupCount >= 2) {
            valueStr = match.group(2);
          } else if (match.groupCount >= 1) {
            valueStr = match.group(1);
          }

          if (valueStr != null) {
            final cleaned = valueStr.replaceAll(RegExp(r'[^0-9.]'), '');
            final total = double.tryParse(cleaned);
            if (total != null) return total;
          }
        }
      }
    }

    return null;
  }

  String _detectCategory(String text) {
    final cleanedText = text.toLowerCase().replaceAll(
      RegExp(r'[^a-z0-9 ]'),
      '',
    );

    if (cleanedText.contains('sm') ||
        cleanedText.contains('savemore') ||
        cleanedText.contains('puregold')) {
      return "groceries";
    }

    if (cleanedText.contains("supermarket") ||
        cleanedText.contains("rice") ||
        cleanedText.contains("grocery")) {
      return "groceries";
    }

    if (cleanedText.contains("jollibee") ||
        cleanedText.contains("mcdo") ||
        cleanedText.contains("restaurant")) {
      return "food";
    }

    if (cleanedText.contains("grab") ||
        cleanedText.contains("fuel") ||
        cleanedText.contains("gasoline")) {
      return "transport";
    }

    if (cleanedText.contains("electric") || cleanedText.contains("meralco")) {
      return "electric";
    }

    if (cleanedText.contains("water")) return "water";

    if (cleanedText.contains("wifi") || cleanedText.contains("pldt")) {
      return "internet";
    }

    if (cleanedText.contains("airlines") || cleanedText.contains("hotel")) {
      return "travel";
    }

    final firstWord = cleanedText.split(' ').first;
    return firstWord.isNotEmpty ? firstWord : "misc";
  }

  Future<void> processReceiptText(
    BuildContext context,
    WidgetRef ref,
    String text,
  ) async {
    String detectedCategoryName = _detectCategory(text);
    double? total = _extractTotal(text);

    if (total == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Could not detect total amount")),
      );
      return;
    }

    final categoryRepo = CategoryRepository();
    final expenseRepo = ExpenseRepository();

    int? categoryId = await categoryRepo.getCategoryIdByName(
      detectedCategoryName,
    );

    if (categoryId == null) {
      categoryId = await categoryRepo.createCategory(detectedCategoryName);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Category '$detectedCategoryName' created automatically",
          ),
        ),
      );
    }

    await expenseRepo.insertExpense(categoryId, total);

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("Receipt saved successfully")));

    ref.invalidate(categoriesProvider);
    ref.invalidate(totalExpenseProvider);
  }

  Future<void> scanReceipt(BuildContext context, WidgetRef ref) async {
    final picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.camera);
    if (image == null) return;

    final inputImage = InputImage.fromFilePath(image.path);
    final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);

    final recognizedText = await textRecognizer.processImage(inputImage);
    final extractedText = recognizedText.text;
    await textRecognizer.close();

    await processReceiptText(context, ref, extractedText);
  }
}
