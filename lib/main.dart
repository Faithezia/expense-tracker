import 'package:expense/screens/account/account_screen.dart';
import 'package:expense/screens/add_expense/add_expense.dart';
import 'package:expense/screens/analytics/analytics_screen.dart';
import 'package:expense/screens/home/home_screen.dart';
import 'package:expense/screens/transaction/transaction_screen.dart';
import 'package:expense/services/database_service.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DatabaseInit.instance.database;

  // await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(ProviderScope(child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final router = GoRouter(
      initialLocation: '/',
      routes: [
        GoRoute(path: '/', builder: (context, state) => const HomeScreen()),
        GoRoute(
          path: '/transaction',
          builder: (context, state) => const TransactionScreen(),
        ),
        GoRoute(
          path: '/add_expense',
          builder: (context, state) => const AddExpense(),
        ),
        GoRoute(
          path: '/analytics',
          builder: (context, state) => const AnalyticsScreen(),
        ),
        GoRoute(
          path: '/account',
          builder: (context, state) => const AccountScreen(),
        ),
      ],
    );

    return MaterialApp.router(
      routerConfig: router,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          primary: Color.fromRGBO(148, 101, 255, 1),
          secondary: Colors.white,
          surface: Colors.white,
        ),
      ),
    );
  }
}
