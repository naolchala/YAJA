import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_test/compontents/week_picker.dart';
import 'package:firebase_test/models/journal.dart';
import 'package:firebase_test/providers/journals_provider.dart';
import 'package:firebase_test/providers/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:intl/intl.dart';

class EditJournalScreen extends HookConsumerWidget {
  EditJournalScreen(this.journal, {super.key});
  final Journal journal;
  final date = DateTime.now();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var authState = ref.watch(authStateProvider);
    var titleController = useTextEditingController(text: journal.title);
    var contentController = useTextEditingController(text: journal.content);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(BoxIcons.bx_arrow_back),
          onPressed: () async {
            var discard = await showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text("Discard Changes"),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context, true);
                    },
                    child: const Text("Discard"),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context, false);
                    },
                    style: const ButtonStyle(
                      backgroundColor: MaterialStatePropertyAll(kPrimary),
                      foregroundColor: MaterialStatePropertyAll(Colors.white),
                    ),
                    child: const Text("Cancel"),
                  ),
                ],
              ),
            );

            if (discard) {
              Navigator.pop(context);
            }
          },
        ),
        title: const Text("Edit Journal"),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () async {
              await saveJournal(
                context: context,
                ref: ref,
                contentController: contentController,
                titleController: titleController,
                user: authState.user!,
              ).then((value) => Navigator.pop(context));
            },
            icon: const Icon(BoxIcons.bx_save),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      offset: const Offset(0, 2),
                      blurRadius: 10,
                    ),
                  ],
                ),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: TextFormField(
                          controller: titleController,
                          style: const TextStyle(
                            fontSize: 32,
                            // fontWeight: FontWeight.w600,
                          ),
                          decoration: const InputDecoration(
                            contentPadding: EdgeInsets.all(0),
                            hintText: "Title",
                            border: InputBorder.none,
                          ),
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
                                        .format(journal.createdAt!),
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
                                    DateFormat.jm().format(journal.createdAt!),
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const Divider(),
                      TextFormField(
                        controller: contentController,
                        maxLength: 6000,
                        minLines: 5,
                        maxLines: 20,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: "Content",
                        ),
                        style: const TextStyle(
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> saveJournal({
    required BuildContext context,
    required WidgetRef ref,
    required TextEditingController titleController,
    required TextEditingController contentController,
    required User user,
  }) async {
    if (titleController.text.isNotEmpty || contentController.text.isNotEmpty) {
      var title = titleController.text;
      var content = contentController.text;

      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) => const SimpleDialog(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 5),
              child: Center(
                child: Text("Saving..."),
              ),
            ),
          ],
        ),
      );

      journal
        ..content = content
        ..title = title
        ..lastUpdatedAt = date;

      await ref
          .read(journalsProvider.notifier)
          .editJournal(journal)
          .whenComplete(() => Navigator.pop(context));
    }
  }
}
