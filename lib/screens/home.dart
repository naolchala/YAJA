import 'package:firebase_test/compontents/week_picker.dart';
import 'package:firebase_test/models/journal.dart';
import 'package:firebase_test/providers/journals_provider.dart';
import 'package:firebase_test/providers/theme.dart';
import 'package:firebase_test/providers/user.dart';
import 'package:firebase_test/screens/add_journal.dart';
import 'package:firebase_test/screens/home/journal_card.dart';
import 'package:firebase_test/screens/home/journal_loading.dart';
import 'package:firebase_test/screens/home/profile_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';

class HomeScreen extends HookConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var authState = ref.watch(authStateProvider);
    var themeMode = ref.watch(ThemeModeProvider);
    var journalState = ref.watch(journalsProvider);
    var currentDate = ref.watch(dateProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Journal'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Iconsax.profile_circle),
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) => const ProfileDialog(),
            );
          },
        ),
        actions: [
          IconButton(
            onPressed: () {
              ref.read(ThemeModeProvider.notifier).toggleTheme();
            },
            icon: Icon(
              themeMode == ThemeMode.dark ? Iconsax.sun_1 : Iconsax.moon,
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: WeekDatePicker(
                  initialDate: currentDate,
                  onChange: (value) =>
                      ref.read(dateProvider.notifier).changeDate(value),
                ),
              ),
            ),
            journalState.isLoading
                ? const JournalLoading()
                : SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) => AnimationConfiguration.staggeredList(
                        position: index,
                        duration: const Duration(milliseconds: 400),
                        child: SlideAnimation(
                          verticalOffset: 50,
                          curve: Curves.decelerate,
                          child: FadeInAnimation(
                            child: JournalCard(
                              journal: journalState.journals[index],
                            ),
                          ),
                        ),
                      ),
                      childCount: journalState.journals.length,
                    ),
                  ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AddJournalScreen(),
          ),
        ),
        isExtended: false,
        child: const Icon(BoxIcons.bx_book_add),
      ),
    );
  }
}
