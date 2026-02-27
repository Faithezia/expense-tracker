import 'package:expense/widgets/bottom_navigation_bar_widget.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:scaffold_gradient_background/scaffold_gradient_background.dart';

class AnalyticsScreen extends StatefulHookConsumerWidget {
  const AnalyticsScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _AnalyticsScreenState();
}

class _AnalyticsScreenState extends ConsumerState<AnalyticsScreen> {
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
