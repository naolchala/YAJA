import 'package:firebase_auth/firebase_auth.dart';
import 'package:isar/isar.dart';
import 'package:uuid/uuid.dart';
part "journal.g.dart";

@collection
class Journal {
  Id id = Isar.autoIncrement;
  String docID = const Uuid().v4();
  String? title;
  String? content;
  DateTime? createdAt;
  DateTime? lastUpdatedAt;
  String? uid = FirebaseAuth.instance.currentUser?.uid;
}
