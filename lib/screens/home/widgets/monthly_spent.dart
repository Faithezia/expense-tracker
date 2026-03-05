import 'package:expense/provider/expense_provider.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class MonthlySpent extends ConsumerStatefulWidget {
  const MonthlySpent({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MonthlySpentState();
}

class _MonthlySpentState extends ConsumerState<MonthlySpent> {
  @override
  Widget build(BuildContext context) {
    final expense = ref.watch(getTotalExpenseProvider);
    return Padding(
      padding: EdgeInsets.only(top: 30, bottom: 20),
      child: Container(
        padding: EdgeInsets.all(15),
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            Text(
              "Spent This Month",
              style: TextStyle(
                color: Colors.black45,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            expense.when(
              data: (data) {
                return Text(
                  "₱$data",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 32,
                    fontWeight: FontWeight.w700,
                  ),
                );
              },
              error: (error, stackTrace) {
                return Text(
                  "$error, $stackTrace",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                  ),
                );
              },
              loading: () => CircularProgressIndicator(),
            ),

            // Text(
            //   "69% less than last month",
            //   style: TextStyle(fontWeight: FontWeight.w500),
            // ),
          ],
        ),
      ),
    );
  }
}
