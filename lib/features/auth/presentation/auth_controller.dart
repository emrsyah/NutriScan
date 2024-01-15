import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:nutriscan/features/auth/domain/user.dart';
import 'package:riverpod/riverpod.dart';

class AuthController extends StateNotifier<Users> {
  AuthController() : super(Users());

  Future<void> signIn(
      BuildContext context, String emailParam, String password) async {
    try {
      final email = '$emailParam';
      var userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      if (userCredential.user != null) {
        var checkUsers = await FirebaseFirestore.instance
            .collection('users')
            .doc(userCredential.user!.uid)
            .get();
        final users = Users.fromJson(checkUsers.data()!);
        state = users;
        if (!mounted) return;
        context.goNamed("home");
      }
    } on FirebaseAuthException catch (e) {
      String message = '';
      switch (e.code) {
        case 'user-not-found':
          message = 'Akun tidak ditemukan';
        case 'invalid-email':
          message = 'Email/Password Salah';
          break;
        default:
          message = 'An error occurred, please try again later';
      }
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          content: Text(message),
          backgroundColor: Colors.red,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          content: Text(e.toString()),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> setAllergies(
      BuildContext context, List<Map<String, String>> _allergies) async {
    Map<String, String> transformedData = {};
    for (var data in _allergies) {
      transformedData[data['value']!] = data['status']!;
    }
    final userRef = FirebaseFirestore.instance
        .collection("users")
        .doc(state.uid);
    context.goNamed("onboarding-finishing");
    try {
      await userRef.update({"allergies": transformedData});
    } catch (e) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          content: Text(e.toString()),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> signUp(BuildContext context, String emailParam, String name,
      String password) async {
    try {
      final email = '$emailParam';
      var userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      if (userCredential.user != null) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userCredential.user!.uid)
            .set({
          'uid': userCredential.user!.uid,
          'name': name,
          'email': email,
          'allergies': {
            "Seafood": "OK",
            "Milk, Eggs, Other Dairy": "OK",
            "Meat": "OK",
            "Nut": "OK",
            "Bakery/Bread": "OK",
            "Nut butters, Jams, and Honey": "OK",
            "Dried Fruits": "OK",
          }
        });
        final users =
            Users(uid: userCredential.user!.uid, name: name, email: email);
        state = users;
        if (!mounted) return;
        context.goNamed("onboarding-allergies");
      }
    } on FirebaseAuthException catch (e) {
      String message = '';
      switch (e.code) {
        case 'email-already-in-use':
          message = 'Email ini sudah digunakan';
        case 'weak-password':
          message = 'Password anda terlalu lemah';
          break;
        default:
          message = 'An error occurred, please try again later';
      }
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          content: Text(message),
          backgroundColor: Colors.red,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          content: Text(e.toString()),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> getUsers({required String uid}) async {
    var checkUsers =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();

    final users = Users.fromJson(checkUsers.data()!);
    state = users;
  }

  Future<void> isUserExist(BuildContext context, String email) async {
    var checkUsers = await FirebaseFirestore.instance
        .collection("users")
        .where("email", isEqualTo: email)
        .get();
    print(checkUsers);
    if (checkUsers.size != 0) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          content: Text("Email sudah digunakan"),
          backgroundColor: Colors.red,
        ),
      );
      // return true;
    } else {
      // return false;
    }
  }

  Future<void> signOut(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      if (!mounted) return;
      context.goNamed("sign-in");
    } catch (e) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          content: Text(e.toString()),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // Future<bool> isUserExist({required String email}) async {
  // await getUsers(uid: uid)
  // }

  Future<String> checkUsers() async {
    final result = FirebaseAuth.instance.currentUser;
    // Logger().i(result);
    if (result != null) {
      await getUsers(uid: result.uid);
      return result.uid;
    }
    return '';
  }
}

final authControllerProvider =
    StateNotifierProvider<AuthController, Users>((ref) => AuthController());
