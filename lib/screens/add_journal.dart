import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_test/models/journal.dart';
import 'package:firebase_test/providers/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:intl/intl.dart';

class AddTaskScreen extends HookConsumerWidget {
  AddTaskScreen({super.key});
  final date = DateTime.now();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var authState = ref.watch(authStateProvider);
    var titleController = useTextEditingController();
    var contentController = useTextEditingController();

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(BoxIcons.bx_arrow_back),
          onPressed: () async {
            await saveJournal(
              context,
              titleController,
              contentController,
              authState.user!,
            ).then((value) => Navigator.pop(context));
          },
        ),
        title: const Text("Add Journal"),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
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
                  alignment: AlignmentDirectional.centerEnd,
                  child: Text(
                    DateFormat.yMMMd().format(date),
                    style: TextStyle(
                      color: Theme.of(context).textTheme.headline2?.color,
                      fontSize: 16,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: TextFormField(
                    controller: titleController,
                    style: const TextStyle(
                      fontSize: 22,
                      // fontWeight: FontWeight.w600,
                    ),
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.all(0),
                      hintText: "Title",
                      border: InputBorder.none,
                    ),
                  ),
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
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> saveJournal(
    BuildContext context,
    TextEditingController titleController,
    TextEditingController contentController,
    User user,
  ) async {
    if (titleController.text.isNotEmpty) {
      var title = titleController.text;
      var content = contentController.text;
      var newJournal = Journal(
        title: title,
        content: content,
        createdAt: date,
        lastUpdatedAt: date,
        uid: user.uid,
      );

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

      await FirebaseFirestore.instance
          .collection('journals')
          .add(newJournal.toMap())
          .then((value) => Navigator.pop(context))
          .catchError((err) => Navigator.pop(context));
    }
  }
}
