import 'package:expense/provider/providers.dart';
import 'package:expense/screens/account/account_screen.dart';
import 'package:expense/screens/add_expense/add_expense.dart';
import 'package:expense/screens/analytics/analytics_screen.dart';
import 'package:expense/screens/home/home_screen.dart';
import 'package:expense/screens/transaction/transaction_screen.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:scaffold_gradient_background/scaffold_gradient_background.dart';

class BottomNavigationBarWidget extends ConsumerStatefulWidget {
  const BottomNavigationBarWidget({super.key});

  @override
  ConsumerState<BottomNavigationBarWidget> createState() =>
      _BottomNavigationBarWidgetState();
}

class _BottomNavigationBarWidgetState
    extends ConsumerState<BottomNavigationBarWidget> {
  final List<Widget> _pages = [
    HomeScreen(),
    TransactionScreen(),
    AddExpense(),
    AnalyticsScreen(),
    AccountScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final currPage = ref.watch(currentPage);

    return ScaffoldGradientBackground(
      gradient: LinearGradient(
        colors: [
          Color.fromRGBO(175, 153, 233, 1),
          Color.fromRGBO(238, 237, 240, 1),
          Color.fromRGBO(240, 239, 242, 1),
        ],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ),
      extendBody: true,
      body: Padding(
        padding: EdgeInsets.only(top: 60, left: 20, right: 20),

        child: IndexedStack(index: currPage, children: _pages),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(top: 0, bottom: 40, left: 30, right: 30),
        child: Material(
          color: Colors.transparent,
          child: Container(
            height: 60,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(40),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.2),
                  spreadRadius: 3,
                  blurRadius: 7,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildNavItem(FontAwesomeIcons.house, 0, currPage),
                _buildNavItem(FontAwesomeIcons.receipt, 1, currPage),
                _buildNavItem(FontAwesomeIcons.plus, 2, currPage),
                _buildNavItem(FontAwesomeIcons.chartSimple, 3, currPage),
                _buildNavItem(FontAwesomeIcons.user, 4, currPage),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, int index, int currPage) {
    final bool isActive = currPage == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          ref.read(currentPage.notifier).state = index;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isActive
              ? Theme.of(context).colorScheme.secondary
              : Colors.transparent,
        ),
        child: Icon(
          icon,
          size: 22,
          color: isActive ? Colors.white : Colors.grey,
        ),
      ),
    );
  }
}
