import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class GetDeviceTokenController extends GetxController{

  String? deviceToken;

  @override
  void onInit() {
    super.onInit();
    getDeviceToken();
  }

  void getDeviceToken() async{
    // get device token from firebase messaging

    try {
      String? token = await FirebaseMessaging.instance.getToken();
      if(token != null){
        deviceToken = token;
        update();
      }
      print(deviceToken);

    
    } catch (e) {
      print("Error getting device token: $e");
    }

  }
  
}