import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/app_providers.dart';
import 'my_drawer.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      drawer: MyDrawer(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/blogUploadScreen');
        },
        child: const Icon(Icons.add),
      ),
      appBar: AppBar(actions: [
        Consumer(builder: (context, ref, child) {
          final theme = ref.watch(themeModeProvider);
          return IconButton(
              onPressed: () {
                ref.read(themeModeProvider.notifier).state =
                    theme == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
              },
              icon: Icon(theme == ThemeMode.dark
                  ? Icons.light_mode
                  : Icons.dark_mode));
        })
      ]),
    );
  }
}
