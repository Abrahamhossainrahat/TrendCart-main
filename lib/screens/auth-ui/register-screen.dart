import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shopping_app/const/app-colors.dart';
import 'package:shopping_app/controller/get-device-token-controller.dart';
import 'package:shopping_app/controller/sign-up-controller.dart';
import 'package:shopping_app/screens/auth-ui/login-screen.dart';
import 'package:flutter/material.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  @override
  Widget build(BuildContext context) {
    // add a media query to get the screen size
    final mediaQuery = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColor.colorRed,
          //Add a back button to left of the app bar
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),
        body: SingleChildScrollView(
          child: Container(
            color: const Color.fromARGB(255, 248, 246, 242),
            child: Column(
              children: [
                Image(
                  image: const AssetImage(
                    "assets/trend.jpg",
                  ),
                  width: 400.w,
                  height: 200.h,
                ),
                Text(
                  'Register Form',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColor.colorRed,
                  ),
                ),
                const SizedBox(height: 20),
                const RegisterForm(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class RegisterForm extends StatelessWidget {
  const RegisterForm({super.key});

  @override
  Widget build(BuildContext context) {
    final SignUpController registerController = Get.put(SignUpController());
    TextEditingController nameController = TextEditingController();
    TextEditingController emailController = TextEditingController();
    TextEditingController phoneController = TextEditingController();
    TextEditingController passwordController = TextEditingController();
    User? user = FirebaseAuth.instance.currentUser;

    Future<void> handleRegister() async {
      final GetDeviceTokenController getDeviceTokenController =
          Get.put(GetDeviceTokenController());
      final LocalAuthentication auth = LocalAuthentication();

      String name = nameController.text.trim();
      String email = emailController.text.trim();
      String phone = phoneController.text.trim();
      String password = passwordController.text.trim();
      String deviceToken = getDeviceTokenController.deviceToken.toString();

      print("this is $deviceToken");

      if (name.isEmpty || email.isEmpty || phone.isEmpty || password.isEmpty) {
        showToast(context, 'All fields are required');
        return;
      }

      try {
        bool canCheckBiometrics = await auth.canCheckBiometrics;
        bool isBiometricAvailable = await auth.isDeviceSupported();

        if (!canCheckBiometrics || !isBiometricAvailable) {
          showToast(context, 'Biometric authentication is not available');
          return;
        }

        // Authenticate the user with biometrics
        bool authenticated = await auth.authenticate(
          localizedReason: 'Please authenticate to register',
          options: const AuthenticationOptions(
            biometricOnly: true,
            stickyAuth: true,
          ),
        );

        if (authenticated) {
          await registerController.signUpMethod(
            name,
            email,
            phone,
            password,
            deviceToken,
            password,
          );

          showToast(
              context, "Registration successful. Verify your email to login.");

          nameController.clear();
          emailController.clear();
          phoneController.clear();
          passwordController.clear();

          await FirebaseAuth.instance.signOut();

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const LoginScreen(),
            ),
          );
        } else {
          showToast(context, 'Biometric authentication failed');
        }
      } catch (e) {
        print("Registration failed: $e");
        showToast(context, "Registration failed. Please try again later.");
      }
    }

    return Container(
      margin: const EdgeInsets.all(20),
      child: Column(
        children: [
          TextFormField(
            controller: nameController,
            decoration: InputDecoration(
              icon: const Icon(Icons.man),
              labelText: 'Name',
              hintText: 'Enter your name',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          const SizedBox(height: 20),
          TextFormField(
            controller: emailController,
            decoration: InputDecoration(
              icon: const Icon(Icons.email),
              labelText: 'Email',
              hintText: 'Enter your email',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          const SizedBox(height: 20),
          TextFormField(
            controller: phoneController,
            decoration: InputDecoration(
              icon: const Icon(Icons.phone),
              labelText: 'Phone',
              hintText: 'Enter your Phone Number',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.all(2.0),
            child: Obx(
              () => TextFormField(
                controller: passwordController,
                obscureText: registerController.isPasswordVisible.value,
                decoration: InputDecoration(
                  icon: const Icon(Icons.lock),
                  labelText: 'Password',
                  hintText: 'Enter your password',
                  suffixIcon: GestureDetector(
                    onTap: () {
                      registerController.isPasswordVisible.toggle();
                    },
                    child: Icon(registerController.isPasswordVisible.value
                        ? Icons.visibility_off
                        : Icons.visibility),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Container(
              width: 200.w,
              height: 50.h,
              child: ElevatedButton(
                onPressed: handleRegister,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColor.colorRed,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: handleRegister,
                      child: Text(
                        "Register",
                        style: TextStyle(
                            fontSize: 14.sp,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }
}

// Create a toast message for the user
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
