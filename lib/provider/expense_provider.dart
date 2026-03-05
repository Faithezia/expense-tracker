import 'package:expense/models/expense_model.dart';
import 'package:expense/repositories/expenses_repository.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:hooks_riverpod/legacy.dart';

final totalExpenseInput = StateProvider<double>((ref) => 0);

final totalExpenseRepositoryProvider = StateProvider((ref) {
  return ExpenseRepository();
});

final totalExpenseProvider = FutureProvider<List<ExpenseModel>>((ref) async {
  final repo = ref.watch(totalExpenseRepositoryProvider);
  return repo.getExpenses();
});

final topTenExpenses = FutureProvider<List<ExpenseModel>>((ref) async {
  final repo = ref.watch(totalExpenseRepositoryProvider);
  return repo.getTopTenExpense();
});

final getTotalExpenseProvider = FutureProvider<double>((ref) async {
  final repo = ref.watch(totalExpenseRepositoryProvider);
  return repo.getTotalExpense();
});

final selectedYearProvider = StateProvider<int>((ref) {
  return DateTime.now().year;
});

final monthlyExpenseProvider = FutureProvider<List<ChartData>>((ref) async {
  final repo = ref.watch(totalExpenseRepositoryProvider);
  final year = ref.watch(selectedYearProvider);

  final rawData = await repo.getMonthlyChartData(year);

  return rawData.map((e) {
    return ChartData(
      label: e['label'] as String,
      amount: (e['amount'] as num).toDouble(),
    );
  }).toList();
});

enum ChartFilter { monthly, yearly }

final chartFilterProvider = StateProvider<ChartFilter>(
  (ref) => ChartFilter.monthly,
);

final yearlyExpenseProvider = FutureProvider<List<ChartData>>((ref) async {
  final repo = ref.watch(totalExpenseRepositoryProvider);

  final rawData = await repo.getYearlyChartData();

  return rawData.map((e) {
    return ChartData(
      label: e['label'] as String,
      amount: (e['amount'] as num).toDouble(),
    );
  }).toList();
});
