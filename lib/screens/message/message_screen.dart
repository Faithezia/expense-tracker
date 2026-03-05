import 'package:expense/repositories/category_repository.dart';
import 'package:expense/repositories/expenses_repository.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:scaffold_gradient_background/scaffold_gradient_background.dart';

class MessageScreen extends StatefulHookConsumerWidget {
  const MessageScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MessageScreenState();
}

class _MessageScreenState extends ConsumerState<MessageScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, String>> _messages = [];
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

      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              reverse: true,
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final msg = _messages[_messages.length - 1 - index];
                return ListTile(
                  title: Align(
                    alignment: msg['role'] == 'user'
                        ? Alignment.centerRight
                        : Alignment.centerLeft,
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: msg['role'] == 'user'
                            ? Colors.blueAccent
                            : Colors.grey[300],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        msg['text']!,
                        style: TextStyle(
                          color: msg['role'] == 'user'
                              ? Colors.white
                              : Colors.black,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.only(
              top: 8.0,
              right: 8.0,
              left: 8.0,
              bottom: 100,
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _controller,
                        decoration: const InputDecoration(
                          hintText: "Ask me about your expenses",
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.send),
                      onPressed: _sendMessage,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ],
                ),
                Text(
                  "Basic NLP, you can only ask how much you spent based on month (January, February, etc.)",
                  style: TextStyle(fontStyle: FontStyle.italic, color: Colors.grey),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _sendMessage() async {
    final userMessage = _controller.text.trim();
    if (userMessage.isEmpty) return;

    setState(() {
      _messages.add({'role': 'user', 'text': userMessage});
      _controller.clear();
    });

    final response = await _handleQuery(userMessage);
    setState(() {
      _messages.add({'role': 'coach', 'text': response});
    });
  }

  Future<String> _handleQuery(String message) async {
    final messageLower = message.toLowerCase();
    final categoryRepo = CategoryRepository();
    final expenseRepo = ExpenseRepository();

    String? category;
    final categories = await categoryRepo.getCategories();
    for (var cat in categories) {
      if (messageLower.contains(cat.name.toLowerCase())) {
        category = cat.name;
        break;
      }
    }

    DateTime? start;
    DateTime? end;
    final monthRegex = RegExp(
      r'(january|february|march|april|may|june|july|august|september|october|november|december)',
    );
    final match = monthRegex.firstMatch(messageLower);
    if (match != null) {
      final month = _monthFromString(match.group(1)!);
      final now = DateTime.now();
      start = DateTime(now.year, month, 1);
      end = DateTime(now.year, month + 1, 0);
    }

    final total = await expenseRepo.getTotalExpenseAgent(
      category != null
          ? await categoryRepo.getCategoryIdByName(category)
          : null,
      start,
      end,
    );

    String reply = 'You spent ₱${total.toStringAsFixed(2)}';
    if (category != null) reply += ' on $category';
    if (start != null && end != null) reply += ' in ${match!.group(1)}';

    // Add simple suggestions
    if (category != null) {
      if (category == 'food' && total > 5000) {
        reply += '. Consider cooking at home more to save money.';
      } else if (category == 'transport' && total > 3000) {
        reply +=
            '. Try using Grab or public transport instead of private car for short trips.';
      }
    }

    return reply;
  }

  int _monthFromString(String month) {
    switch (month) {
      case 'january':
        return 1;
      case 'february':
        return 2;
      case 'march':
        return 3;
      case 'april':
        return 4;
      case 'may':
        return 5;
      case 'june':
        return 6;
      case 'july':
        return 7;
      case 'august':
        return 8;
      case 'september':
        return 9;
      case 'october':
        return 10;
      case 'november':
        return 11;
      case 'december':
        return 12;
    }
    return 1;
  }
}
