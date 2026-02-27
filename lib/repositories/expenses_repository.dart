import 'package:expense/models/expense_model.dart';
import 'package:expense/services/database_service.dart';

class ExpenseRepository {
  Future<List<ExpenseModel>> getExpenses() async {
    final db = await DatabaseService.database;
    final result = await db.rawQuery('''
      SELECT
        a.id,
        a.category_id,
        a.total_expense,
        a.create_date,
        b.name,
        b.icon
      FROM expenses a
      LEFT JOIN categories b ON b.id = a.category_id
    ''');
    return result.map((e) => ExpenseModel.fromMap(e)).toList();
  }

  Future<void> insertExpense(int categoryId, double totalExpense) async {
    final db = await DatabaseService.database;
    final now = DateTime.now();
    await db.insert('expenses', {
      'category_id': categoryId,
      'total_expense': totalExpense,
      'create_date': now.toIso8601String(),
    });
  }
}
