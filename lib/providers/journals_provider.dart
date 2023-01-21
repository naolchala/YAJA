import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_test/controllers/journals_controller.dart';
import 'package:firebase_test/models/journal.dart';
import 'package:firebase_test/providers/user.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:isar/isar.dart';

import 'isar_service.dart';

class DateNotifier extends StateNotifier<DateTime> {
  DateNotifier() : super(DateTime.now());

  void changeDate(DateTime date) {
    state = date;
  }
}

final dateProvider = StateNotifierProvider<DateNotifier, DateTime>((ref) {
  return DateNotifier();
});

class JournalState {
  final bool isLoading;
  final String? error;
  final List<Journal> journals;

  JournalState({
    required this.isLoading,
    this.error,
    required this.journals,
  });

  JournalState copyWithLoading({required bool loading}) =>
      JournalState(isLoading: loading, journals: journals, error: error);

  JournalState copyWith({
    isLoading,
    error,
    journals,
  }) =>
      JournalState(
        isLoading: isLoading ?? this.isLoading,
        journals: journals ?? this.journals,
        error: error ?? this.error,
      );
}

class JournalStateNotifier extends StateNotifier<JournalState> {
  JournalStateNotifier({required this.user, required this.currentDate})
      : super(
          JournalState(isLoading: false, journals: []),
        ) {
    load();
  }

  final User? user;
  final DateTime currentDate;

  Future<void> load() async {
    var today = DateTime(currentDate.year, currentDate.month, currentDate.day);
    var tomorrow = today.add(const Duration(days: 1));
    state = state.copyWithLoading(loading: true);

    var journals = await isar.journals
        .filter()
        .uidEqualTo(user?.uid)
        .and()
        .createdAtBetween(today, tomorrow)
        .sortByLastUpdatedAt()
        .findAll();

    state = state.copyWith(journals: journals, isLoading: false);
  }

  Future<void> deleteJournal(int id) async {
    await JournalsController.deleteJournal(id);
    await load();
  }

  Future<void> addJournal(Journal journal) async {
    await JournalsController.addJournal(journal);
    await load();
  }

  Future<void> editJournal(Journal journal) async {
    await JournalsController.editJournal(journal);
    await load();
  }
}

final journalsProvider =
    StateNotifierProvider.autoDispose<JournalStateNotifier, JournalState>(
        (ref) {
  var user = ref.watch(authStateProvider);
  var currentDate = ref.watch(dateProvider);
  return JournalStateNotifier(user: user.user, currentDate: currentDate);
});

final singleJournalProvider = StreamProvider.autoDispose.family<Journal?, int>(
  (ref, id) => isar.journals.watchObject(id, fireImmediately: true),
);
