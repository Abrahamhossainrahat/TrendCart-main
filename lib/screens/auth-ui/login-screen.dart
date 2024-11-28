// ignore_for_file: file_names , prefer_const_constructors_in_immutables, prefer_const_constructors

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:shopping_app/const/app-colors.dart';
import 'package:shopping_app/controller/get-user-data-controller.dart';
import 'package:shopping_app/screens/auth-ui/welcome-screen.dart';

import '../../controller/sign-in-controller.dart';
import '../user/home-screen.dart';
import 'forgot-password-screen.dart';
import 'register-screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    // add a media query to get the screen size
    final mediaQuery = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColor.colorRed,
        ),
        body: SingleChildScrollView(
          child: Container(
            child: SafeArea(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Image(
                    image: AssetImage(
                      "assets/trend.jpg",
                    ),
                    width: 400,
                    height: 250,
                  ),
                  LoginForm(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Don't have an account?"),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => const RegisterScreen()));
                        },
                        child: const Text(
                          "Click Here",
                          style: TextStyle(color: Colors.blue),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class LoginForm extends StatefulWidget {
  LoginForm({super.key});

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final SignInController signInController = Get.put(SignInController());
  final GetUserDataController getUserDataController =
      Get.put(GetUserDataController());
  late TextEditingController emailController;
  late TextEditingController passwordController;

  @override
  void initState() {
    super.initState();
    emailController = TextEditingController();
    passwordController = TextEditingController();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: TextFormField(
              controller: emailController,
              decoration: InputDecoration(
                labelText: 'Enter your email',
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Obx(
              () => TextFormField(
                controller: passwordController,
                obscureText: signInController.isPasswordVisible.value,
                decoration: InputDecoration(
                  labelText: 'Enter your password',
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  suffixIcon: GestureDetector(
                    onTap: () {
                      signInController.isPasswordVisible.toggle();
                    },
                    child: signInController.isPasswordVisible.value
                        ? const Icon(Icons.visibility_off)
                        : const Icon(Icons.visibility),
                  ),
                ),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const ForgotPasswordScreen()));
                },
                child: Text(
                  "Forgot Password",
                  style: TextStyle(color: AppColor.colorRed),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColor.colorRed, // Button background color
              minimumSize: Size(200.w, 50.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            onPressed: () async {
              String email = emailController.text.trim();
              String password = passwordController.text.trim();

              if (email.isEmpty || password.isEmpty) {
                showToast(context, "All fields are required");
              } else {
                UserCredential? userCredential =
                    await signInController.signInMethod(email, password);

                var userData = await getUserDataController
                    .getUserData(userCredential!.user!.uid);

                if (userCredential.user!.emailVerified) {
                  if (userData[0]['isAdmin'] == true) {
                    print("Moved to admin screen");

                    Fluttertoast.showToast(
                        msg: "Welcome Admin",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.red,
                        textColor: Colors.white,
                        fontSize: 16.0);
                  } else {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => HomeScreen()));

                    Fluttertoast.showToast(
                        msg: "Welcome User",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 1,
                        backgroundColor: AppColor.colorRed,
                        textColor: Colors.white,
                        fontSize: 16.0);
                  }

                  return; // Return here to prevent showing unnecessary toasts or snackbar
                } else {
                  showToast(context, "Please verify your email before login");
                }
              }
            },
            child: Text(
              "Login",
              style: TextStyle(
                fontSize: 14.sp,
                color: Colors.white, // Text color
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Create a toast message for the login
void showToast(BuildContext context, String message) {
  final scaffold = ScaffoldMessenger.of(context);
  scaffold.showSnackBar(
    SnackBar(
      content: Text(message),
      action: SnackBarAction(
        label: 'UNDO',
        onPressed: scaffold.hideCurrentSnackBar,
      ),
    ),
  );
}
