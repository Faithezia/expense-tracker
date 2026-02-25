import 'package:expense/firebase_options.dart';
import 'package:expense/screens/account/account_screen.dart';
import 'package:expense/screens/add_expense/add_expense.dart';
import 'package:expense/screens/analytics/analytics_screen.dart';
import 'package:expense/screens/home/home_screen.dart';
import 'package:expense/screens/transaction/transaction_screen.dart';
import 'package:expense/widgets/bottom_navigation_bar_widget.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(ProviderScope(child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final router = GoRouter(
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => BottomNavigationBarWidget(),
        ),
        GoRoute(path: '/home', builder: (context, state) => HomeScreen()),
        GoRoute(
          path: '/transaction',
          builder: (context, state) => TransactionScreen(),
        ),
        GoRoute(
          path: '/add_expense',
          builder: (context, state) => AddExpense(),
        ),
        GoRoute(
          path: '/analytics',
          builder: (context, state) => AnalyticsScreen(),
        ),
        GoRoute(path: '/account', builder: (context, state) => AccountScreen()),
      ],
    );

    return MaterialApp.router(
      routerConfig: router,

      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: .fromSeed(
          seedColor: Colors.deepPurple,
          primary: Colors.white,
          secondary: Color.fromRGBO(148, 101, 255, 1),
          surface: Colors.white,
        ),
      ),
    );
  }
}
