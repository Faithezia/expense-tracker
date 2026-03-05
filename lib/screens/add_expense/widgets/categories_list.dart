import 'package:expense/provider/category_providers.dart';
import 'package:expense/screens/add_expense/widgets/add_expense_dialog.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class CategoriesList extends ConsumerWidget {
  const CategoriesList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoriesAsync = ref.watch(categoriesProvider);
    final iconColors = ref.watch(listOfColorsProvider);
    final iconList = ref.watch(iconListProvider);

    return Expanded(
      child: Column(
        children: [
          const SizedBox(height: 16),
          Expanded(
            child: categoriesAsync.hasValue
                ? categoriesAsync.when(
                    loading: () =>
                        const Center(child: CircularProgressIndicator()),
                    error: (e, _) => Center(child: Text("Error: $e")),
                    data: (categories) {
                      if (categories.isEmpty) {
                        return const Center(child: Text("No categories yet"));
                      }

                      return GridView.builder(
                        padding: const EdgeInsets.all(16),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 4,
                              mainAxisSpacing: 20,
                              crossAxisSpacing: 20,
                              childAspectRatio: 0.8,
                            ),
                        itemCount: categories.length,
                        itemBuilder: (context, index) {
                          final category = categories[index];
                          final icon =
                              iconList[category.icon] ??
                              FontAwesomeIcons.question;
                          final color =
                              iconColors[category.icon] ?? Colors.grey;

                          return Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Expanded(
                                child: Material(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                  child: InkWell(
                                    borderRadius: BorderRadius.circular(20),
                                    splashColor: color.withValues(alpha: 0.3),
                                    highlightColor: color.withValues(
                                      alpha: 0.1,
                                    ),
                                    onTap: () async {
                                      final result =
                                          await AddExpenseDialog.show(
                                            context,
                                            categoryId: category.id,
                                          );
                                      if (result == true) {
                                        ref.invalidate(categoriesProvider);
                                      }
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      height: 80,
                                      child: Center(
                                        child: Icon(
                                          icon,
                                          color: color,
                                          size: 40,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                category.name.toUpperCase(),
                                textAlign: TextAlign.center,
                                style: const TextStyle(fontSize: 12),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          );
                        },
                      );
                    },
                  )
                : Text("No data yet", style: TextStyle(fontSize: 24)),
          ),
        ],
      ),
    );
  }
}
