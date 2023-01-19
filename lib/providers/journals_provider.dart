import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_test/models/journal.dart';
import 'package:firebase_test/providers/user.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:isar/isar.dart';

class DateNotifier extends StateNotifier<DateTime> {
  DateNotifier() : super(DateTime.now());

  void changeDate(DateTime date) {
    state = date;
  }
}

final dateProvider = StateNotifierProvider<DateNotifier, DateTime>((ref) {
  return DateNotifier();
});

class IsarServices {
  Isar? instance = Isar.openSync([JournalSchema]);
}

final isar = IsarServices().instance!;

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

  void load() async {
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
}

final journalsProvider =
    StateNotifierProvider<JournalStateNotifier, JournalState>((ref) {
  var user = ref.watch(authStateProvider);
  var currentDate = ref.watch(dateProvider);
  return JournalStateNotifier(user: user.user, currentDate: currentDate);
});
