import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Auth {
  FirebaseAuth get _auth => FirebaseAuth.instance;
  User? get user => _auth.currentUser;
  Stream<User?> get userChanged => _auth.userChanges();
  bool get isAlreadyLoggedIn => FirebaseAuth.instance.currentUser?.uid != null;

  Future<UserCredential?> signInWithGoogle() async {
    var googleAccount = await GoogleSignIn().signIn();
    var authentication = await googleAccount?.authentication;
    var credentials = GoogleAuthProvider.credential(
      accessToken: authentication?.accessToken,
      idToken: authentication?.idToken,
    );

    return _auth.signInWithCredential(credentials);
  }

  Future<UserCredential> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    return await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<void> signOut() async {
    await _auth.signOut();
    await GoogleSignIn().signOut();
  }
}
