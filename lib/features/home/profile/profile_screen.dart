import 'package:code/providers/firebase_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../utils/cached_netwok_image_loader.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(firebaseUserProvider);
    final localfirebaseAuthProvider = ref.watch(fireBaseAuthProvider);
    return Column(
      children: [
        user.when(
          data: (user) {
            return user?.email == null
                ?  SizedBox(
                        width: double.maxFinite,
                        child: OutlinedButton(
                            onPressed: () {
                              Navigator.pushNamed(context, '/loginScreen');
                            },
                            child: const Text("Login")),
                      )
                : Column(
                    children: [
                      ListTile(
                        leading: SizedBox(
                            width: 50,
                            child: getCachedNetworkImage(
                              user?.photoURL ?? '',
                              BoxShape.circle,
                            )),
                        title: Text(user?.displayName ?? ''),
                        subtitle: Text(user?.email ?? ''),
                        trailing: IconButton(
                          icon: const Icon(Icons.logout_rounded),
                          onPressed: () async {
                            await localfirebaseAuthProvider.signOut();
                          },
                        ),
                      ),
                      // ignore: prefer_const_constructors
                      SizedBox(
                        width: double.maxFinite,
                        child: OutlinedButton(
                            onPressed: () {
                              Navigator.pushReplacementNamed(context, '/blogUploadScreen');
                            },
                            child: const Text("Create an post")),
                      )
                    ],
                  );
          },
          error: (e, s) => const Text('error'),
          loading: () => const Text('loading'),
        ),
        const SizedBox(height: 10),
        SizedBox(
          width: double.maxFinite,
          child: OutlinedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/savedBlogsScreen');
              },
              child: const Text("Saved Blogs")),
        )
      ],
    );
  }
}
