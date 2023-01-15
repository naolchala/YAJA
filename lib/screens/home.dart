import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_test/models/journal.dart';
import 'package:firebase_test/providers/journals.dart';
import 'package:firebase_test/providers/theme.dart';
import 'package:firebase_test/providers/user.dart';
import 'package:firebase_test/screens/add_journal.dart';
import 'package:firebase_test/screens/home/profile_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';

class HomeScreen extends HookConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var authState = ref.watch(authStateProvider);
    var themeMode = ref.watch(ThemeModeProvider);
    var journals = ref.watch(journalsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Journal'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Iconsax.profile_circle),
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) => const ProfileDialog(),
            );
          },
        ),
        actions: [
          IconButton(
            onPressed: () {
              ref.read(ThemeModeProvider.notifier).toggleTheme();
            },
            icon: Icon(
              themeMode == ThemeMode.dark ? Iconsax.sun_1 : Iconsax.moon,
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: journals.when(
          data: (data) {
            var docs = data.docs;
            print(docs);
            return ListView.builder(
              itemCount: docs.length,
              itemBuilder: (context, index) {
                var journal = Journal.fromMap(docs[index].data());
                return Column(
                  children: [
                    ListTile(
                      leading: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.secondary,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: const Icon(
                          BoxIcons.bx_book_open,
                        ),
                      ),
                      title: Text(journal.title),
                      subtitle: Text(
                          "Last Updated ${DateFormat.jm().format(journal.lastUpdatedAt)}"),
                    ),
                    const Divider(),
                  ],
                );
              },
            );
          },
          error: (err, stack) => const Text('Error...'),
          loading: () => const Center(
            child: CircularProgressIndicator(),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AddTaskScreen(),
          ),
        ),
        isExtended: false,
        child: const Icon(BoxIcons.bx_book_add),
      ),
    );
  }
}
