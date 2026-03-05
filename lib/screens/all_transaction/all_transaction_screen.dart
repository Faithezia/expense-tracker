import 'package:expense/provider/category_providers.dart';
import 'package:expense/provider/expense_provider.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:scaffold_gradient_background/scaffold_gradient_background.dart';

class AllTransactionScreen extends ConsumerStatefulWidget {
  const AllTransactionScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _AllTransactionScreenState();
}

class _AllTransactionScreenState extends ConsumerState<AllTransactionScreen> {
  @override
  Widget build(BuildContext context) {
    final expensesList = ref.watch(totalExpenseProvider);
    final iconColors = ref.watch(listOfColorsProvider);
    final iconList = ref.watch(iconListProvider);
    return ScaffoldGradientBackground(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          style: ButtonStyle(
            backgroundColor: WidgetStateProperty.all(
              Theme.of(context).colorScheme.tertiary,
            ),
          ),
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
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
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Column(
            children: [
              Center(
                child: Text(
                  "All Transactions",
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.w600),
                ),
              ),
              SizedBox(height: 20),
              expensesList.hasValue
                  ? expensesList.when(
                      data: (data) {
                        if (data.isEmpty) {
                          return const Center(
                            child: Text(
                              "No data yet",
                              style: TextStyle(fontSize: 24),
                            ),
                          );
                        }
                        return ListView.builder(
                          shrinkWrap: true,
                          itemCount: data.length,
                          physics: NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            final category = data[index];

                            final icon =
                                iconList[category.categoryIcon] ??
                                Icons.category;
                            final color =
                                iconColors[category.categoryIcon] ??
                                Colors.grey;
                            final date = DateFormat.yMMMMd().format(
                              category.createDate,
                            );

                            return Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: ListTile(
                                leading: Icon(icon, color: color, size: 40),
                                title: Text(
                                  category.categoryName,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                subtitle: Text(date),
                                trailing: Text(
                                  "-₱${category.totalExpense.toString()}",
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Colors.redAccent,
                                  ),
                                ),
                                tileColor: Colors.white,
                                horizontalTitleGap: 12,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                minTileHeight: 70,
                              ),
                            );
                          },
                        );
                      },
                      loading: () =>
                          const Center(child: CircularProgressIndicator()),
                      error: (e, _) => Center(child: Text("Error: $e")),
                    )
                  : const Center(
                      child: Text(
                        "No data yet",
                        style: TextStyle(fontSize: 24),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
