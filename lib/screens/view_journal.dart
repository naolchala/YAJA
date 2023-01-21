import 'package:firebase_test/models/journal.dart';
import 'package:firebase_test/providers/journals_provider.dart';
import 'package:firebase_test/screens/edit_journal.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';

class ViewJournal extends HookConsumerWidget {
  const ViewJournal(this.journal, {super.key});
  final Journal journal;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var current = ref.watch(singleJournalProvider(journal.id));
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Journal"),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditJournalScreen(journal),
                ),
              );
            },
            icon: const Icon(BoxIcons.bx_edit_alt),
          )
        ],
      ),
      body: SafeArea(
        child: current.when(
          loading: () => const Center(
            child: CircularProgressIndicator(
              strokeWidth: 2,
            ),
          ),
          error: (error, stackTrace) => const Text("Error."),
          data: (data) => Padding(
            padding: const EdgeInsets.all(20.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 30.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          data!.title ?? "Title",
                          style: const TextStyle(
                            fontSize: 36,
                          ),
                        ),
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(right: 18.0),
                              child: Row(
                                children: [
                                  const Padding(
                                    padding: EdgeInsets.only(right: 8.0),
                                    child: Icon(
                                      BoxIcons.bx_calendar,
                                      size: 20,
                                    ),
                                  ),
                                  Center(
                                    child: Text(
                                      DateFormat.yMMMMd()
                                          .format(data.createdAt!),
                                      style: const TextStyle(fontSize: 12),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 18.0),
                              child: Row(
                                children: [
                                  const Padding(
                                    padding: EdgeInsets.only(right: 8.0),
                                    child: Icon(
                                      BoxIcons.bx_time_five,
                                      size: 20,
                                    ),
                                  ),
                                  Center(
                                    child: Text(
                                      DateFormat.jm().format(data.createdAt!),
                                      style: const TextStyle(fontSize: 12),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Text(
                    data.content ?? "",
                    style: const TextStyle(
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
