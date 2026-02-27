import 'package:expense/provider/providers.dart';
import 'package:expense/repositories/expenses_repository.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class AddExpenseDialog extends ConsumerStatefulWidget {
  final int categoryId;

  const AddExpenseDialog({required this.categoryId, super.key});

  static Future<bool?> show(BuildContext context, {required int categoryId}) {
    return showDialog<bool>(
      context: context,
      builder: (_) => AddExpenseDialog(categoryId: categoryId),
    );
  }

  @override
  ConsumerState<AddExpenseDialog> createState() => _AddExpenseDialogState();
}

class _AddExpenseDialogState extends ConsumerState<AddExpenseDialog> {
  final textController = TextEditingController();

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  Future<void> _saveCategory(BuildContext context) async {
    final expense = ref.read(totalExpenseInput);

    await ExpenseRepository().insertExpense(widget.categoryId, expense);

    ref.invalidate(totalExpenseProvider);

    if (mounted) Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Add Category"),
      content: TextField(
        controller: textController,
        keyboardType: TextInputType.number,
        decoration: const InputDecoration(
          labelText: "Total Expense",
          border: OutlineInputBorder(),
        ),
        onChanged: (value) {
          ref.read(totalExpenseInput.notifier).state =
              double.tryParse(value) ?? 0.0;
        },
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: const Text("Cancel"),
        ),
        ElevatedButton(
          onPressed: () => _saveCategory(context),
          style: ButtonStyle(
            backgroundColor: WidgetStateProperty.all(
              Theme.of(context).colorScheme.primary,
            ),
          ),
          child: const Text("Save", style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }
}
