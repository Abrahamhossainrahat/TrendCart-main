// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:local_auth/local_auth.dart';

class SignInController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  CollectionReference colRef = FirebaseFirestore.instance.collection("users");

  var isPasswordVisible = false.obs;
  String user = "";

  Future<UserCredential?> signInMethod(
    String userEmail,
    String userPassword,
  ) async {
    print(userEmail);
    print(userPassword);
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: userEmail,
        password: userPassword,
      );

      return userCredential;
    } on FirebaseAuthException catch (e) {
      Get.snackbar("Error", e.message.toString());
    }
    return null;
  }

  Future<DocumentSnapshot> getUserData(String uid) async {
    return await colRef.doc(uid).get();
  }

  void email(String email) {
    user = email;
  }

  Future<bool> signInWithBiometric(BuildContext context) async {
    bool canChecBiometrics = await LocalAuthentication().canCheckBiometrics;
    if (canChecBiometrics) {
      List<BiometricType> availableBiometrics =
          await LocalAuthentication().getAvailableBiometrics();
      if (availableBiometrics.contains(BiometricType.fingerprint)) {
        try {
          bool isAuthenticated = await LocalAuthentication().authenticate(
            localizedReason: "Authenticate to login",
          );
          return isAuthenticated;
        } catch (e) {
          Get.snackbar("Error", e.toString());
        }
      }
    }
    return false;
  }
}
