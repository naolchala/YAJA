import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_test/auth/auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final firebaseAuth = Auth();

final userProvider = StreamProvider((ref) => firebaseAuth.userChanged);

@immutable
class AuthState {
  final bool isLoading;
  final User? user;
  final AuthResult result;

  const AuthState({
    required this.isLoading,
    this.user,
    required this.result,
  });

  AuthState copyWith({bool? isLoading, User? user, AuthResult? result}) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      user: user,
      result: result ?? this.result,
    );
  }
}

class AuthStateNotifier extends StateNotifier<AuthState> {
  AuthStateNotifier({User? user})
      : super(
          AuthState(
            isLoading: false,
            result: AuthResult.none,
            user: user,
          ),
        );

  void loginWithGoogle() async {
    state = state.copyWith(isLoading: true);
    try {
      await firebaseAuth.signInWithGoogle();
    } catch (error) {
      print(error);
      state = state.copyWith(isLoading: false, result: AuthResult.aborted);
    }
    state = state.copyWith(isLoading: false, user: firebaseAuth.user);
  }

  void logout() async {
    state = state.copyWith(isLoading: true, user: null);
    await firebaseAuth.signOut().then((value) {
      state = state.copyWith(isLoading: false, user: null);
    });
  }
}

final authStateProvider = StateNotifierProvider<AuthStateNotifier, AuthState>(
  (ref) {
    var userChange = ref.watch(userProvider);
    return userChange.when(
      data: (data) => AuthStateNotifier(user: data),
      error: (error, stackTrace) => AuthStateNotifier(),
      loading: () => AuthStateNotifier(),
    );
  },
);

enum AuthResult { success, aborted, none }
