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
    return Padding(
      padding: EdgeInsets.all(30),
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
          Text(
            "₱6969.69",
            style: TextStyle(
              color: Colors.black,
              fontSize: 28,
              fontWeight: FontWeight.w700,
            ),
          ),
          Text(
            "69% less than last month",
            style: TextStyle(fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}
