import 'package:expense/screens/home/widgets/monthly_spent.dart';
import 'package:expense/screens/home/widgets/total_budget.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatefulHookConsumerWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final dateNow = DateTime.now();
    final formattedDate = DateFormat("EEE, d MMM ").format(dateNow);
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton.filled(
              onPressed: () {},
              icon: Icon(Icons.settings, color: Colors.black87),
            ),
            Text(
              formattedDate,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
            ),
            IconButton.filled(
              onPressed: () {},
              icon: Icon(Icons.notifications_none, color: Colors.black87),
            ),
          ],
        ),
        MonthlySpent(),
        TotalBudget(),
      ],
    );
  }
}
