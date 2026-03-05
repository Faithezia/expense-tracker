import 'package:expense/provider/expense_provider.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

class HistoryWidget extends ConsumerStatefulWidget {
  const HistoryWidget({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HistoryWidgetState();
}

class _HistoryWidgetState extends ConsumerState<HistoryWidget> {
  @override
  Widget build(BuildContext context) {
    final topTen = ref.watch(topTenExpenses);

    return Padding(
      padding: EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "History",
            style: TextStyle(
              color: Colors.black,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          topTen.hasValue
              ? topTen.when(
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

                        final date = DateFormat.yMMMMd().format(
                          category.createDate,
                        );

                        return Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: ListTile(
                            title: Text(
                              "Date",
                              style: const TextStyle(fontSize: 12),
                            ),
                            subtitle: Text(
                              date,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: Colors.black,
                              ),
                            ),
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
                  child: Text("No data yet", style: TextStyle(fontSize: 24)),
                ),
        ],
      ),
    );
  }
}
