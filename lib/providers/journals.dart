import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_test/providers/user.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final journalsProvider = StreamProvider((ref) {
  var user = ref.watch(authStateProvider).user;
  return FirebaseFirestore.instance
      .collection("journals")
      .where("uid", isEqualTo: user?.uid)
      .orderBy("createdAt")
      .snapshots();
});
