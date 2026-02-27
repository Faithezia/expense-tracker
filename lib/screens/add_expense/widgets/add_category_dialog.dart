import 'package:expense/provider/providers.dart';
import 'package:expense/services/database_service.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class AddCategoryDialog extends ConsumerStatefulWidget {
  const AddCategoryDialog({super.key});

  @override
  ConsumerState<AddCategoryDialog> createState() => _AddCategoryDialogState();
}

class _AddCategoryDialogState extends ConsumerState<AddCategoryDialog> {
  String categoryName = '';
  String selectedIcon = "home";

  final Map<String, IconData> iconList = {
    "home": Icons.home,
    "transport": Icons.directions_car,
    "food": Icons.fastfood,
    "groceries": FontAwesomeIcons.basketShopping,
    "electric": Icons.electric_bolt,
    "water": FontAwesomeIcons.droplet,
    "travel": Icons.flight,
    "internet": Icons.wifi,
  };

  Future<void> _saveCategory(BuildContext context) async {
    final db = await DatabaseInit.instance.database;

    if (categoryName.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Category name cannot be empty")),
      );
      return;
    }

    await db.insert('categories', {
      'name': categoryName.trim(),
      'icon': selectedIcon,
    });

    ref.invalidate(categoriesProvider);

    if (mounted) Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Column(
        children: [
          Material(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            child: InkWell(
              borderRadius: BorderRadius.circular(20),
              onTap: () async {
                final result = await _showAddDialog(context);
                if (result == true) ref.invalidate(categoriesProvider);
              },
              child: Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Center(
                  child: Icon(
                    Icons.add,
                    color: Colors.deepPurpleAccent,
                    size: 40,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 5),
          const Text("ADD", style: TextStyle(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  Future<bool?> _showAddDialog(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, dialogSetState) {
            return AlertDialog(
              title: const Text("Add Category"),
              content: SizedBox(
                width: double.maxFinite,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      decoration: const InputDecoration(
                        labelText: "Category Name",
                        border: OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(),
                      ),
                      onChanged: (value) => categoryName = value,
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      height: 150,
                      child: GridView.count(
                        crossAxisCount: 4,
                        physics: const NeverScrollableScrollPhysics(),
                        children: iconList.entries.map((entry) {
                          return IconButton(
                            icon: Icon(
                              entry.value,
                              color: selectedIcon == entry.key
                                  ? Colors.blue
                                  : Colors.grey,
                              size: 30,
                            ),
                            onPressed: () {
                              dialogSetState(() {
                                selectedIcon = entry.key;
                              });
                            },
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(dialogContext).pop(false),
                  child: const Text(
                    "Cancel",
                    style: TextStyle(color: Colors.black),
                  ),
                ),
                ElevatedButton(
                  onPressed: () => _saveCategory(context),
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.all(
                      Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  child: const Text(
                    "Save",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
