import 'package:expense/provider/providers.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'add_category_dialog.dart';

class CategoriesList extends ConsumerWidget {
  const CategoriesList({super.key});

  final Map<String, IconData> iconList = const {
    "home": Icons.home,
    "transport": Icons.directions_car,
    "food": Icons.fastfood,
    "groceries": FontAwesomeIcons.basketShopping,
    "electric": Icons.electric_bolt,
    "travel": Icons.flight,
    "internet": Icons.wifi,
  };

  final Map<String, Color> iconColors = const {
    "home": Colors.purpleAccent,
    "transport": Colors.red,
    "food": Colors.orange,
    "groceries": Colors.purple,
    "electric": Colors.yellow,
    "travel": Colors.blueAccent,
    "internet": Colors.deepPurpleAccent,
  };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoriesAsync = ref.watch(categoriesProvider);

    return Expanded(
      child: Column(
        children: [
          AddCategoryDialog(),
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
                              crossAxisSpacing: 25,
                              childAspectRatio: 0.8,
                            ),
                        itemCount: categories.length,
                        itemBuilder: (context, index) {
                          final category = categories[index];
                          final icon =
                              iconList[category.icon] ?? Icons.category;
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
                                    onTap: () {},
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
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
                : Text("No data yet", style: TextStyle(fontSize: 24),),
          ),
        ],
      ),
    );
  }
}
