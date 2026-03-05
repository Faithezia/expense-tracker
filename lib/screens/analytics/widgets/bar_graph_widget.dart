import 'package:expense/provider/expense_provider.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';

class BarGraphWidget extends ConsumerStatefulWidget {
  const BarGraphWidget({super.key});

  @override
  ConsumerState<BarGraphWidget> createState() => _BarGraphWidgetState();
}

class _BarGraphWidgetState extends ConsumerState<BarGraphWidget> {
  int touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    final selectedFilter = ref.watch(chartFilterProvider);

    final expenseData = selectedFilter == ChartFilter.monthly
        ? ref.watch(monthlyExpenseProvider)
        : ref.watch(yearlyExpenseProvider);

    return Container(
      height: 360,
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          /// 🔽 Dropdown Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Expenses Overview",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              DropdownButton<ChartFilter>(
                value: selectedFilter,
                underline: const SizedBox(),
                borderRadius: BorderRadius.circular(12),
                items: const [
                  DropdownMenuItem(
                    value: ChartFilter.monthly,
                    child: Text("Monthly"),
                  ),
                  DropdownMenuItem(
                    value: ChartFilter.yearly,
                    child: Text("Yearly"),
                  ),
                ],
                onChanged: (value) {
                  ref.read(chartFilterProvider.notifier).state = value!;
                },
              ),
            ],
          ),

          const SizedBox(height: 20),

          /// 📊 Chart
          Expanded(
            child: expenseData.when(
              data: (data) {
                final hasRealData =
                    data.isNotEmpty && data.any((e) => e.amount > 0);

                if (!hasRealData) {
                  return const Center(
                    child: Text(
                      "No expense data yet",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey,
                      ),
                    ),
                  );
                }

                final maxY = data
                    .map((e) => e.amount)
                    .reduce((a, b) => a > b ? a : b);

                final safeMaxY = maxY == 0 ? 10 : maxY;
                final interval = (safeMaxY / 5).ceilToDouble();

                return BarChart(
                  BarChartData(
                    maxY: safeMaxY * 1.25,
                    alignment: BarChartAlignment.spaceAround,
                    gridData: FlGridData(
                      show: true,
                      drawVerticalLine: false,
                      horizontalInterval: interval,
                      getDrawingHorizontalLine: (value) => FlLine(
                        color: Colors.grey.withValues(alpha: 0.15),
                        strokeWidth: 1,
                      ),
                    ),
                    borderData: FlBorderData(show: false),
                    titlesData: FlTitlesData(
                      topTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      rightTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          interval: interval,
                          reservedSize: 45,
                          getTitlesWidget: (value, meta) {
                            return Text(
                              '₱${value.toInt()}',
                              style: const TextStyle(
                                fontSize: 11,
                                color: Colors.grey,
                              ),
                            );
                          },
                        ),
                      ),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (value, meta) {
                            final index = value.toInt();
                            if (index >= data.length) {
                              return const SizedBox();
                            }
                            return Padding(
                              padding: const EdgeInsets.only(top: 6),
                              child: Text(
                                data[index].label,
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    barGroups: List.generate(data.length, (index) {
                      final item = data[index];
                      final isTouched = index == touchedIndex;

                      return BarChartGroupData(
                        x: index,
                        barRods: [
                          BarChartRodData(
                            toY: item.amount,
                            width: isTouched ? 26 : 22,
                            borderRadius: BorderRadius.circular(14),
                            gradient: LinearGradient(
                              colors: isTouched
                                  ? [
                                      const Color(0xFF00C9FF),
                                      const Color(0xFF92FE9D),
                                    ]
                                  : [
                                      Color.fromRGBO(255, 247, 205, 1),
                                      Color.fromRGBO(253, 195, 161, 1),
                                    ],
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                            ),
                          ),
                        ],
                      );
                    }),
                  ),
                  duration: const Duration(milliseconds: 800),
                  curve: Curves.easeOutExpo,
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, _) => Center(child: Text("Error: $err")),
            ),
          ),
        ],
      ),
    );
  }
}
