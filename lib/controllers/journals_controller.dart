import 'package:firebase_test/providers/isar_service.dart';
import 'package:firebase_test/models/journal.dart';

class JournalsController {
  static Future<void> deleteJournal(int id) async {
    await isar.writeTxn(() async => await isar.journals.delete(id));
  }

  static Future<void> addJournal(Journal journal) async {
    await isar.writeTxn(() async => await isar.journals.put(journal));
  }

  static Future<void> editJournal(Journal journal) async {
    await isar.writeTxn(() async => await isar.journals.put(journal));
  }
}
