import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shopping_app/const/app-colors.dart';

class SignUpController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  CollectionReference colRef = FirebaseFirestore.instance.collection("users");
  User? user = FirebaseAuth.instance.currentUser;
  var isPasswordVisible = false.obs;

  Future<UserCredential?> signUpMethod(
    String userName,
    String userEmail,
    String userPhone,
    String userPassword,
    String userDeviceToken,
    String password,
  ) async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: userEmail,
        password: userPassword,
      );

      await userCredential.user!.sendEmailVerification();

      await colRef.doc(userCredential.user!.uid).set({
        'uId': userCredential.user!.uid,
        'name': userName,
        'email': userEmail,
        'phone': userPhone,
        'isAdmin': false,
        'deviceToken': userDeviceToken,
        'biometricEnabled': true,
        'password' : password // Set the biometric enabled flag
      });

      return userCredential;
    } on FirebaseAuthException catch (e) {
      Get.snackbar("Error", "$e",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: AppColor.colorRed,
          colorText: Colors.white);
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
    return null;
  }
}
