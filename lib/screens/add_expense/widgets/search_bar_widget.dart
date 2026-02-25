import 'package:expense/provider/providers.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SearchBarWidget extends StatefulHookConsumerWidget {
  const SearchBarWidget({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _SearchBarWidgetState();
}

class _SearchBarWidgetState extends ConsumerState<SearchBarWidget> {
  final textController = TextEditingController();

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SearchBar(
      controller: textController,
      onChanged: (value) {
        ref.read(searchValue.notifier).state = value;
      },
      leading: Icon(FontAwesomeIcons.magnifyingGlass, color: Colors.black54),
      hintText: "Search for Categories",
      backgroundColor: WidgetStatePropertyAll(Colors.white),
      // elevation: WidgetStatePropertyAll(0),
    );
  }
}
