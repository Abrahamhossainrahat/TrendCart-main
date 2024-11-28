import 'package:firebase_messaging/firebase_messaging.dart';

Future<String?> getCustomerDeviceToken() async {
  try {
    String? token = await FirebaseMessaging.instance.getToken();
    if (token != null) {
      print("Device token: $token");
      return token;
    } else {
      print("Error: Failed to get device token");
      return null;
    }
  } catch (e) {
    print("Error fetching device token: $e");
    return null;
  }
}
