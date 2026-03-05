class ExpenseModel {
  final int id;
  final int categoryId;
  final String categoryName;
  final String categoryIcon;
  final double totalExpense;
  final DateTime createDate;

  ExpenseModel({
    required this.id,
    required this.categoryId,
    required this.categoryName,
    required this.categoryIcon,
    required this.totalExpense,
    required this.createDate,
  });

  factory ExpenseModel.fromMap(Map<String, dynamic> map) {
    return ExpenseModel(
      id: int.parse(map['id'].toString()),
      categoryId: int.parse(map['category_id'].toString()),
      categoryName: map['name'],
      categoryIcon: map['icon'],
      totalExpense: double.parse(map['total_expense'].toString()),
      createDate: DateTime.parse(map['create_date'].toString()),
    );
  }
}

class ChartData {
  final String label;
  final double amount;

  ChartData({required this.label, required this.amount});
}
