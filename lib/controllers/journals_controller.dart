import 'package:firebase_test/providers/journals_provider.dart';
import 'package:firebase_test/models/journal.dart';

class JournalsController {
  static Future<void> deleteJournal(int id) async {
    await isar.writeTxn(() async => await isar.journals.delete(id));
  }
}
