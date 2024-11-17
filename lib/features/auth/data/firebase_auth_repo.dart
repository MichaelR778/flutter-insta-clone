import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:social/features/auth/domain/entities/auth_user.dart';
import 'package:social/features/auth/domain/repos/auth_repo.dart';

class FirebaseAuthRepo implements AuthRepo {
  final firebaseAuth = FirebaseAuth.instance;
  final firebaseFirestore = FirebaseFirestore.instance;

  @override
  Future<AuthUser> signup(String name, String email, String password) async {
    try {
      final userCredential = await firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final authUser = AuthUser(
        id: userCredential.user!.uid,
        email: email,
        name: name,
      );

      // save user to db
      await firebaseFirestore
          .collection('users')
          .doc(authUser.id)
          .set(authUser.toJson());

      return authUser;
    } catch (e) {
      throw Exception('Signup failed: $e');
    }
  }

  @override
  Future<AuthUser> login(String email, String password) async {
    try {
      final userCredential = await firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // fetch user from db
      final userDoc = await firebaseFirestore
          .collection('users')
          .doc(userCredential.user!.uid)
          .get();

      if (!userDoc.exists) throw Exception('User not found');

      final userData = userDoc.data();

      final authUser = AuthUser(
        id: userCredential.user!.uid,
        email: email,
        name: userData!['name'],
      );

      return authUser;
    } catch (e) {
      throw Exception('Login failed: $e');
    }
  }

  @override
  Future<void> logout() async {
    await firebaseAuth.signOut();
  }

  @override
  Future<AuthUser?> getCurrUser() async {
    final currUser = firebaseAuth.currentUser;

    if (currUser == null) return null;

    // fetch user from db
    final userDoc =
        await firebaseFirestore.collection('users').doc(currUser.uid).get();

    if (!userDoc.exists) return null;

    final userData = userDoc.data();

    return AuthUser(
      id: currUser.uid,
      email: currUser.email!,
      name: userData!['name'],
    );
  }
}
