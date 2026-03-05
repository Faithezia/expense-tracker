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
      ORDER BY a.id DESC
    ''');
    return result.map((e) => ExpenseModel.fromMap(e)).toList();
  }

  Future<List<ExpenseModel>> getTopTenExpense() async {
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
      ORDER BY a.id DESC
      LIMIT 10
    ''');
    return result.map((e) => ExpenseModel.fromMap(e)).toList();
  }

  Future<List<Map<String, dynamic>>> getMonthlyExpenses(int year) async {
    final db = await DatabaseService.database;

    final result = await db.rawQuery(
      '''
    SELECT 
      strftime('%m', create_date) as month,
      SUM(total_expense) as total
    FROM expenses
    WHERE strftime('%Y', create_date) = ?
    GROUP BY month
    ORDER BY month ASC
  ''',
      [year.toString()],
    );

    return result.map((e) {
      return {
        'month': e['month'],
        'total': (e['total'] as num?)?.toDouble() ?? 0.0,
      };
    }).toList();
  }

  Future<List<Map<String, dynamic>>> getMonthlyChartData(int year) async {
    final rawData = await getMonthlyExpenses(year);

    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];

    List<Map<String, dynamic>> chartData = List.generate(12, (index) {
      final monthNumber = (index + 1).toString().padLeft(2, '0');

      final match = rawData.firstWhere(
        (e) => e['month'] == monthNumber,
        orElse: () => {'total': 0.0},
      );

      return {'label': months[index], 'amount': match['total']};
    });

    return chartData;
  }

  Future<double> getMonthlyTotal(int year, int month) async {
    final db = await DatabaseService.database;

    final result = await db.rawQuery(
      '''
    SELECT SUM(total_expense) as total
    FROM expenses
    WHERE strftime('%Y', create_date) = ?
    AND strftime('%m', create_date) = ?
  ''',
      [year.toString(), month.toString().padLeft(2, '0')],
    );

    return (result.first['total'] as num?)?.toDouble() ?? 0.0;
  }

  Future<double> getTotalExpense() async {
    final db = await DatabaseService.database;
    final result = await db.rawQuery('''
    SELECT SUM(total_expense) as total
    FROM expenses
  ''');

    double total = 0;
    if (result.isNotEmpty && result.first['total'] != null) {
      total = (result.first['total'] as num).toDouble();
    }
    return total;
  }

  Future<double> getTotalExpenseAgent(
    int? categoryId,
    DateTime? start,
    DateTime? end,
  ) async {
    final db = await DatabaseService.database;

    String whereClause = '';
    List<dynamic> args = [];

    if (categoryId != null) {
      whereClause += 'category_id = ?';
      args.add(categoryId);
    }

    if (start != null && end != null) {
      if (whereClause.isNotEmpty) whereClause += ' AND ';
      whereClause += 'create_date BETWEEN ? AND ?';
      args.add(start.toIso8601String());
      args.add(end.toIso8601String());
    }

    final result = await db.rawQuery(
      'SELECT SUM(total_expense) as total FROM expenses' +
          (whereClause.isNotEmpty ? ' WHERE $whereClause' : ''),
      args,
    );

    return result.first['total'] as double? ?? 0.0;
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

  Future<List<Map<String, dynamic>>> getYearlyChartData() async {
    final db = await DatabaseService.database;

    final result = await db.rawQuery('''
    SELECT 
      strftime('%Y', create_date) as year,
      SUM(total_expense) as total
    FROM expenses
    GROUP BY year
    ORDER BY year ASC
  ''');

    return result.map((e) {
      return {
        'label': e['year'],
        'amount': (e['total'] as num?)?.toDouble() ?? 0.0,
      };
    }).toList();
  }
}
