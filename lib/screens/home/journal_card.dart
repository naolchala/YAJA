import 'package:firebase_test/compontents/week_picker.dart';
import 'package:firebase_test/controllers/journals_controller.dart';
import 'package:firebase_test/models/journal.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:intl/intl.dart';

class JournalCard extends HookConsumerWidget {
  const JournalCard({
    Key? key,
    required this.journal,
  }) : super(key: key);

  final Journal journal;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: InkWell(
        onLongPress: () {
          showDialog(
            context: context,
            builder: (context) => SimpleDialog(children: [
              SimpleDialogOption(
                child: ListTile(
                  onTap: () {},
                  leading: const Icon(BoxIcons.bx_edit_alt),
                  title: const Text("Edit"),
                ),
              ),
              SimpleDialogOption(
                child: ListTile(
                  onTap: () async {
                    Navigator.pop(context);
                    bool sure = await showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text("Are you sure?"),
                        content: Text("Delete \"${journal.title}\"?"),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context, true);
                            },
                            child: const Text("Delete"),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context, false);
                            },
                            style: ButtonStyle(
                              backgroundColor: MaterialStatePropertyAll(
                                kPrimary.withOpacity(0.1),
                              ),
                            ),
                            child: const Text("Cancel"),
                          ),
                        ],
                      ),
                    );

                    if (!sure) {
                      return;
                    }

                    showDialog(
                      context: context,
                      builder: (context) => const AlertDialog(
                        title: Text("Deleting..."),
                        content: Center(
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                          ),
                        ),
                      ),
                    );

                    await JournalsController.deleteJournal(journal.id)
                        .whenComplete(
                      () => Navigator.pop(context),
                    );
                  },
                  leading: const Icon(BoxIcons.bx_trash),
                  title: const Text("Delete"),
                ),
              ),
              SimpleDialogOption(
                child: ListTile(
                  onTap: () {},
                  leading: const Icon(BoxIcons.bx_x),
                  title: const Text("Cancel"),
                ),
              ),
            ]),
          );
        },
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.grey.shade900
                : Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Theme.of(context).colorScheme.primary.withOpacity(0.22),
                blurRadius: 30,
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Text(
                  journal.title ?? "",
                  style: const TextStyle(fontSize: 24),
                ),
              ),
              Text(
                journal.content!.length > 200
                    ? journal.content!.substring(0, 200)
                    : journal.content!,
                style: const TextStyle(
                  fontSize: 16,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 18.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(journal.createdAt != null
                        ? DateFormat.yMMMMEEEEd().format(journal.createdAt!)
                        : ""),
                    Text(DateFormat.jm().format(journal.createdAt!))
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
