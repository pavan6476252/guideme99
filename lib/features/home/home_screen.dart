import 'package:code/features/home/profile/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/app_providers.dart';
import '../../providers/firebase_providers.dart';
import '../../providers/theme_provider.dart';
import 'main/main_screen.dart';
import 'blog_viewer.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final List<Tab> _tabs = const [
    Tab(
      icon: Icon(Icons.home),
    ),
    Tab(
      icon: Icon(Icons.play_circle_outlined),
    ),
    Tab(
      icon: Icon(Icons.person_4_outlined),
    ),
  ];

  final List<Widget> _tabScreens = [
    const FirstScreen(),
    PlayScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: _tabs.length,
      child: Scaffold(
        // floatingActionButton: FloatingActionButton(
        //   onPressed: () {
        //     Navigator.pushNamed(context, '/blogUploadScreen');
        //   },
        //   child: const Icon(Icons.add),
        // ),
        appBar: AppBar(title: const Text("Guideme 99"), actions: [
          Consumer(builder: (context, ref, child) {
            var darkMode = ref.watch(darkModeProvider);
            return  Switch(
                value: darkMode,
                onChanged: (val) {
                  ref.read(darkModeProvider.notifier).toggle();
                },
              );
          })
        ]),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: TabBarView(
            
            clipBehavior: Clip.hardEdge,
            children: _tabScreens,
          ),
        ),
        bottomNavigationBar: Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Colors.black54,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 0),
              ),
            ],
          ),
          child: SafeArea(
            child: TabBar(
              tabs: _tabs,
              labelColor: Colors.blueAccent,
              unselectedLabelColor: Colors.grey,
              indicatorColor: Colors.transparent,
            ),
          ),
        ),
      ),
    );
  }
}

class FirstScreen extends ConsumerWidget {
  const FirstScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(firebaseUserProvider);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Hello,',
          style: TextStyle(fontSize: 30),
        ),
        user.when(
          data: (user) {
            return user?.email == null
                ? const Text("Anonymus user",
                    style: const TextStyle(fontSize: 30))
                : Text(
                    user!.displayName ?? '',
                    style: const TextStyle(fontSize: 30),
                  );
          },
          error: (e, s) => const Text('error'),
          loading: () => const Text('loading'),
        ),
        Expanded(child: FeedsScreen())
      ],
    );
  }
}

class PlayScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Play Screen'),
    );
  }
}
