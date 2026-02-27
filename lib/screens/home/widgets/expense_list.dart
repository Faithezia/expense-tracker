import 'package:expense/provider/providers.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

class ExpenseList extends StatefulHookConsumerWidget {
  const ExpenseList({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ExpenseListState();
}

class _ExpenseListState extends ConsumerState<ExpenseList> {
  @override
  Widget build(BuildContext context) {
    final expensesList = ref.watch(totalExpenseProvider);
    final iconColors = ref.watch(listOfColorsProvider);
    final iconList = ref.watch(iconListProvider);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 20, left: 16, right: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text(
                "Recent Transaction",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              Text("See All", style: TextStyle(color: Colors.black54)),
            ],
          ),
        ),

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
                          iconList[category.categoryIcon] ?? Icons.category;
                      final color =
                          iconColors[category.categoryIcon] ?? Colors.grey;
                      final date = DateFormat.yMMMMd().format(
                        category.createDate,
                      );

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: ListTile(
                          leading: Icon(icon, color: color, size: 40),
                          title: Text(
                            category.categoryName,
                            style: const TextStyle(fontWeight: FontWeight.w700),
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
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, _) => Center(child: Text("Error: $e")),
              )
            : const Center(
                child: Text("No data yet", style: TextStyle(fontSize: 24)),
              ),
      ],
    );
  }
}
