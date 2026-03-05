import 'package:expense/screens/add_expense/widgets/add_category_dialog.dart';
import 'package:expense/screens/add_expense/widgets/categories_list.dart';
import 'package:expense/screens/add_expense/widgets/receipt_scanner.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:scaffold_gradient_background/scaffold_gradient_background.dart';

class AddExpense extends StatefulHookConsumerWidget {
  const AddExpense({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AddExpenseState();
}

class _AddExpenseState extends ConsumerState<AddExpense> {
  final textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ScaffoldGradientBackground(
      gradient: LinearGradient(
        colors: [
          Color.fromRGBO(253, 195, 161, 1),
          Color.fromRGBO(255, 247, 205, 1),
          Color.fromRGBO(238, 237, 240, 1),
          Color.fromRGBO(240, 239, 242, 1),
        ],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ),
      body: Padding(
        padding: EdgeInsets.only(top: 50, left: 16, right: 16),
        child: Center(
          child: Column(
            children: [
              Text(
                "Select Category",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 20),
              // SearchBarWidget(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [AddCategoryDialog(), ReceiptScanner()],
              ),
              CategoriesList(),
            ],
          ),
        ),
      ),
    );
  }
}
