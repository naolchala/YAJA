import 'package:firebase_test/providers/theme.dart';
import 'package:firebase_test/providers/user.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:icons_plus/icons_plus.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var authState = ref.watch(authStateProvider);
    var themeMode = ref.watch(ThemeModeProvider);

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            // ignore: prefer_const_literals_to_create_immutables
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: Column(
                    children: [
                      Expanded(
                        child: FractionallySizedBox(
                          widthFactor: 0.8,
                          child: Image.asset("assets/employee-planner-1.png"),
                        ),
                      ),
                      const Text(
                        "Journal",
                        style: TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: Text(
                          """Lorem ipsum dolor sit amet consectetur adipisicing elit. Maxime mollitia molestiae quas vel sint commodi repudiandae consequuntur voluptatum laborum numquam blanditiis harum quisquam eius sed odit fugiat iusto """,
                          textAlign: TextAlign.justify,
                          style: TextStyle(
                            fontSize: 16,
                            color: themeMode == ThemeMode.dark
                                ? Colors.white54
                                : Colors.black54,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                ),
              ),
              AnimatedContainer(
                duration: const Duration(milliseconds: 800),
                curve: Curves.fastLinearToSlowEaseIn,
                padding: EdgeInsets.all(authState.isLoading ? 40 : 20),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(40),
                  ),
                ),
                child: authState.isLoading
                    ? const Center(
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : ElevatedButton(
                        onPressed: () {
                          ref
                              .read(authStateProvider.notifier)
                              .loginWithGoogle();
                        },
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Logo(
                              Logos.google,
                              size: 20,
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            const Expanded(
                              child: Center(
                                child: Text(
                                  "Sign in with Google",
                                  style: TextStyle(
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
