import 'package:expense/screens/home/widgets/expense_list.dart';
import 'package:expense/screens/home/widgets/monthly_spent.dart';
import 'package:expense/screens/home/widgets/total_budget.dart';
import 'package:expense/widgets/bottom_navigation_bar_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:scaffold_gradient_background/scaffold_gradient_background.dart';

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
    return ScaffoldGradientBackground(
      gradient: LinearGradient(
        colors: [
          Color.fromRGBO(170, 137, 253, 1),
          Color.fromRGBO(238, 237, 240, 1),
          Color.fromRGBO(238, 237, 240, 1),
          Color.fromRGBO(240, 239, 242, 1),
        ],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ),
      bottomNavigationBar: BottomNavigationBarWidget(),
      body: Padding(
        padding: EdgeInsets.only(top: 50, left: 16, right: 16),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton.filled(
                    onPressed: () {},
                    icon: Icon(Icons.settings, color: Colors.black87),
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all(
                        Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                  ),
                  Text(
                    formattedDate,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                  ),
                  IconButton.filled(
                    onPressed: () {},
                    icon: Icon(Icons.notifications_none, color: Colors.black87),
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all(
                        Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                  ),
                ],
              ),
              MonthlySpent(),
              TotalBudget(),
              ExpenseList(),
            ],
          ),
        ),
      ),
    );
  }
}
