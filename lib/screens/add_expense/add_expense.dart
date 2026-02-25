import 'package:expense/screens/add_expense/widgets/categories_list.dart';
import 'package:expense/screens/add_expense/widgets/search_bar_widget.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class AddExpense extends StatefulHookConsumerWidget {
  const AddExpense({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AddExpenseState();
}

class _AddExpenseState extends ConsumerState<AddExpense> {
  final textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Text(
            "Select Category",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
          ),
          SizedBox(height: 20),
          SearchBarWidget(),
          CategoriesList()
        ],
      ),
    );
  }
}
