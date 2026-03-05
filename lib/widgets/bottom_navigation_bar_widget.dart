import 'package:expense/provider/category_providers.dart';
import 'package:expense/screens/add_expense/add_expense.dart';
import 'package:expense/screens/analytics/analytics_screen.dart';
import 'package:expense/screens/home/home_screen.dart';
import 'package:expense/screens/message/message_screen.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

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
    MessageScreen(),
    AddExpense(),
    AnalyticsScreen(),
    // AccountScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final currPage = ref.watch(currentPage);

    return Scaffold(
      extendBody: true,
      body: IndexedStack(index: currPage, children: _pages),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(top: 0, bottom: 15, left: 20, right: 20),
        child: Material(
          color: Colors.transparent,
          child: Container(
            height: 70,
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
                _buildNavItem(FontAwesomeIcons.message, 1, currPage),
                _buildNavItem(FontAwesomeIcons.plus, 2, currPage),
                _buildNavItem(FontAwesomeIcons.chartSimple, 3, currPage),
                // _buildNavItem(FontAwesomeIcons.user, 4, currPage),
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
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isActive
              ? Theme.of(context).colorScheme.primary
              : Colors.transparent,
        ),
        child: Icon(
          icon,
          size: 24,
          color: isActive ? Colors.white : Colors.grey,
        ),
      ),
    );
  }
}
