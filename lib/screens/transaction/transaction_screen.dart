import 'package:expense/widgets/bottom_navigation_bar_widget.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:scaffold_gradient_background/scaffold_gradient_background.dart';

class TransactionScreen extends StatefulHookConsumerWidget {
  const TransactionScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _TransactionScreenState();
}

class _TransactionScreenState extends ConsumerState<TransactionScreen> {
  @override
  Widget build(BuildContext context) {
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

      body: Container(),
    );
  }
}
