import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_test/firebase_options.dart';
import 'package:firebase_test/models/journal.dart';
import 'package:firebase_test/providers/theme.dart';
import 'package:firebase_test/providers/user.dart';
import 'package:firebase_test/screens/home.dart';
import 'package:firebase_test/screens/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:isar/isar.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    const ProviderScope(
      child: App(),
    ),
  );
}

class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var authState = ref.watch(authStateProvider);
    authState = authState.copyWith(user: firebaseAuth.user);
    var themeMode = ref.watch(ThemeModeProvider);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      darkTheme: darkTheme,
      theme: lightTheme,
      themeMode: themeMode,
      home: authState.user != null ? const HomeScreen() : const LoginScreen(),
    );
  }
}

class SlidePageTransition extends HookConsumerWidget {
  const SlidePageTransition(this.page, {super.key});
  final Widget page;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var animationController = useAnimationController(
      duration: const Duration(milliseconds: 1000),
      reverseDuration: const Duration(milliseconds: 1000),
    );

    var animation = Tween<Offset>(
      begin: const Offset(0.0, 1.0),
      end: const Offset(0.0, 0.0),
    )
        .chain(
          CurveTween(
            curve: Curves.fastLinearToSlowEaseIn,
          ),
        )
        .animate(animationController);
    animationController.forward();
    return Scaffold(
      body: AnimatedBuilder(
        animation: animation,
        child: page,
        builder: (context, child) {
          return SlideTransition(
            position: animation,
            child: child,
          );
        },
      ),
    );
  }
}
// TODO: Profile Dialog
//  - Contains Profile Picture, name, Email, and Logout Button

// TODO: Add Journal Page
//  - Title, Description, Date, Color, Moods 
//  - Adds to Firebase Firestore

// class SlidePageTransition extends PageRouteBuilder {
//   final Widget page;
//   SlidePageTransition(this.page)
//       : super(
//           pageBuilder: (context, animation, anotherAnimation) => page,
//           transitionDuration: const Duration(milliseconds: 1000),
//           reverseTransitionDuration: const Duration(milliseconds: 500),
//           transitionsBuilder:
//               (context, parentAnimation, anotherAnimation, child) {
//             var animation = CurvedAnimation(
//               parent: parentAnimation,
//               curve: Curves.fastLinearToSlowEaseIn,
//               reverseCurve: Curves.fastLinearToSlowEaseIn,
//             );

//             return SlideTransition(
//               position: Tween(
//                 begin: const Offset(0.0, 1.0),
//                 end: const Offset(0.0, 0.0),
//               ).animate(animation),
//               child: page,
//             );
//           },
//         );
// }
