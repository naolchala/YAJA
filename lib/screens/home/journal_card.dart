import 'package:firebase_test/compontents/week_picker.dart';
import 'package:firebase_test/controllers/journals_controller.dart';
import 'package:firebase_test/models/journal.dart';
import 'package:firebase_test/providers/journals_provider.dart';
import 'package:firebase_test/screens/edit_journal.dart';
import 'package:firebase_test/screens/view_journal.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:intl/intl.dart';

enum OptionActions {
  edit,
  delete,
  close,
}

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
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ViewJournal(journal),
          ),
        ),
        onLongPress: () async {
          OptionActions action = await showDialog(
            context: context,
            builder: (context) => optionsDialog(context, ref),
          );

          switch (action) {
            case OptionActions.edit:
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditJournalScreen(journal),
                ),
              );
              break;
            case OptionActions.delete:
              {
                bool accept = await showDialog(
                  context: context,
                  builder: (context) => confirmationDialog(context),
                );

                if (!accept) {
                  return;
                }

                showDialog(
                  context: context,
                  builder: (context) => loadingDialog(),
                );

                await ref
                    .read(journalsProvider.notifier)
                    .deleteJournal(journal.id)
                    .then((value) => Navigator.pop(context));

                break;
              }
            case OptionActions.close:
              break;
          }
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

  AlertDialog loadingDialog() {
    return const AlertDialog(
      title: Text("Deleting..."),
      content: SizedBox(
        height: 150,
        child: Center(
          child: CircularProgressIndicator(
            strokeWidth: 2,
          ),
        ),
      ),
    );
  }

  Widget confirmationDialog(BuildContext context) {
    return AlertDialog(
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
              kPrimary.withOpacity(0.04),
            ),
          ),
          child: const Text("Cancel"),
        ),
      ],
    );
  }

  Widget optionsDialog(BuildContext context, WidgetRef ref) {
    return SimpleDialog(children: [
      SimpleDialogOption(
        child: ListTile(
          leading: const Icon(BoxIcons.bx_edit_alt),
          title: const Text("Edit"),
          onTap: () {
            Navigator.pop(context, OptionActions.edit);
          },
        ),
      ),
      SimpleDialogOption(
        child: ListTile(
          leading: const Icon(BoxIcons.bx_trash),
          title: const Text("Delete"),
          onTap: () {
            Navigator.pop(context, OptionActions.delete);
          },
        ),
      ),
      SimpleDialogOption(
        child: ListTile(
          leading: const Icon(BoxIcons.bx_x),
          title: const Text("Cancel"),
          onTap: () {
            Navigator.pop(context);
          },
        ),
      ),
    ]);
  }
}

// TODO: Reload After Deleting and Adding
// TODO: Go to View Page with contains edit button on tap
// TODO: Edit page will be the same us Add but contains the information 