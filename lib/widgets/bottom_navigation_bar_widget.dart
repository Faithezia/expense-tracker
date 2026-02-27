import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:expense/provider/providers.dart';

class BottomNavigationBarWidget extends ConsumerStatefulWidget {
  const BottomNavigationBarWidget({super.key});

  @override
  ConsumerState<BottomNavigationBarWidget> createState() =>
      _BottomNavigationBarWidgetState();
}

class _BottomNavigationBarWidgetState
    extends ConsumerState<BottomNavigationBarWidget> {
  final List<String> _routes = [
    '/',
    '/transaction', 
    '/add_expense',
    '/analytics',
    '/account',
  ];

  @override
  Widget build(BuildContext context) {
    final currPage = ref.watch(currentPage);

    return Padding(
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
    );
  }

  Widget _buildNavItem(IconData icon, int index, int currPage) {
    final bool isActive = currPage == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          ref.read(currentPage.notifier).state = index;
          context.go(_routes[index]);
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isActive
              ? Theme.of(context).colorScheme.primary
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
