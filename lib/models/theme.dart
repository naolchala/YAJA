import 'package:firebase_test/providers/journals_provider.dart';
import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
part 'theme.g.dart';

@collection
class ThemeModel {
  Id id = Isar.autoIncrement;
  late String theme;
}
