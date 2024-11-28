import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shopping_app/const/app-colors.dart';
import 'package:shopping_app/controller/sign-in-controller.dart';
import 'package:shopping_app/screens/auth-ui/login-screen.dart';
import 'package:shopping_app/screens/auth-ui/register-screen.dart';
import 'package:shopping_app/screens/user/home-screen.dart';

class WelcomeScreen extends StatefulWidget {
  final User? user;
  final String password;

  WelcomeScreen({Key? key, required this.user, required this.password})
      : super(key: key);

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final SignInController signInController = SignInController();
  late final LocalAuthentication localAuth;
  bool _supportState = false;

  @override
  void initState() {
    super.initState();
    localAuth = LocalAuthentication();
    localAuth.isDeviceSupported().then((bool isSupported) => setState(() {
          _supportState = isSupported;
        }));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Column(
            children: [
              const SizedBox(height: 50),
              Column(
                children: [
                  Image.asset(
                    "assets/trend.jpg", // Replace with your image asset path
                    width: 400.w,
                    height: 300.h,
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColor.colorRed, // Button background color
                      minimumSize: Size(200.w, 50.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginScreen(),
                        ),
                      );
                    },
                    child: Text(
                      "Login",
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.white, // Button text color
                      ),
                    ),
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
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const RegisterScreen(),
                        ),
                      );
                    },
                    child: Text(
                      "Register",
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.white, // Button text color
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> authenticate(User? user) async {
    try {
      bool isAuthenticated = await localAuth.authenticate(
        localizedReason: "Authenticate to login",
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: true,
        ),
      );
      if (isAuthenticated) {
        if (user != null) {
          signInWithBiometrics(user, widget.password);
        } else {
          showToast(context, "No user found. Please log in manually first.");
        }
      }
    } on PlatformException catch (e) {
      showToast(context, "Authentication failed: ${e.message}");
    }
  }

  Future<void> signInWithBiometrics(User user, String password) async {
    try {
      print("user email : ${user.email.toString()} , password : $password");
      await signInController.signInMethod(user.email.toString(), password);

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const HomeScreen(),
        ),
      );
    } catch (e) {
      showToast(context, "Failed to sign in: ${e.toString()}");
    }
  }

  void showToast(BuildContext context, String message) {
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(
      SnackBar(
        content: Text(message),
        action: SnackBarAction(
          label: 'OK',
          onPressed: scaffold.hideCurrentSnackBar,
        ),
      ),
    );
  }
}
