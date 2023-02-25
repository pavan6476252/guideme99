import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/app_providers.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/blogUploadScreen');
        },
        child: const Icon(Icons.add),
      ),
      appBar: AppBar(actions: [
        ElevatedButton(
          child: const Text('Click me!'),
          onPressed: () {
            ref.read(themeMode.notifier).state =
                ref.read(themeMode) == ThemeMode.light
                    ? ThemeMode.dark
                    : ThemeMode.light;
          },
        )
      ]),
    );
  }
}
