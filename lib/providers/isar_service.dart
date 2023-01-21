import 'package:firebase_test/models/journal.dart';
import 'package:firebase_test/models/theme.dart';
import 'package:isar/isar.dart';

class IsarServices {
  Isar? instance = Isar.openSync([ThemeModelSchema, JournalSchema]);
}

final isar = IsarServices().instance!;
