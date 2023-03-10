import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_test/compontents/week_picker.dart';
import 'package:firebase_test/providers/user.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ProfileDialog extends ConsumerWidget {
  const ProfileDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    AuthState authState = ref.watch(authStateProvider);
    var theme = Theme.of(context);
    var brightness = theme.brightness;

    var btnFore = brightness == Brightness.light
        ? theme.colorScheme.primary
        : theme.colorScheme.secondary;

    var btnBack = btnFore.withOpacity(0.2);

    return Dialog(
      child: Container(
        padding: const EdgeInsets.all(30),
        height: 350,
        child: authState.isLoading || authState.user == null
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        Container(
                          height: 90,
                          width: 90,
                          clipBehavior: Clip.antiAlias,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(250),
                            boxShadow: [
                              BoxShadow(
                                spreadRadius: 6,
                                color: Theme.of(context).colorScheme.secondary,
                              ),
                              BoxShadow(
                                spreadRadius: 3,
                                color: Theme.of(context).cardColor,
                              ),
                              BoxShadow(
                                blurRadius: 25,
                                spreadRadius: 3,
                                color: Theme.of(context)
                                    .colorScheme
                                    .secondary
                                    .withOpacity(0.5),
                              ),
                            ],
                          ),
                          child: CachedNetworkImage(
                            imageUrl: authState.user?.photoURL ?? "",
                            placeholder: (context, url) =>
                                initialImage(authState),
                            errorWidget: (context, url, error) =>
                                initialImage(authState),
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Text(
                          "${authState.user?.displayName}",
                          style: const TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "${authState.user?.email}",
                          style: TextStyle(
                            color:
                                Theme.of(context).textTheme.subtitle2?.color!,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    children: [
                      TextButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(btnBack),
                          foregroundColor: MaterialStatePropertyAll(btnFore),
                        ),
                        onPressed: () async {
                          ref.read(authStateProvider.notifier).logout();
                          Navigator.pop(context);
                        },
                        child: Row(
                          children: const [
                            Expanded(
                              child: Center(child: Text("Logout")),
                            ),
                          ],
                        ),
                      ),
                      TextButton(
                        style: ButtonStyle(
                          foregroundColor: MaterialStateProperty.all(btnFore),
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Row(
                          children: const [
                            Expanded(
                              child: Center(child: Text("Close")),
                            ),
                          ],
                        ),
                      ),
                    ],
                  )
                ],
              ),
      ),
    );
  }

  Container initialImage(AuthState authState) {
    return Container(
      decoration: const BoxDecoration(
        color: kSecondaryAccent,
      ),
      child: Center(
        child: Text(
          authState.user!.displayName!.substring(0, 1),
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 40,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
