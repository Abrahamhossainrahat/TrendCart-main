import 'package:flutter/widgets.dart';

class AppColor{
  //Color colorRe = const Color.fromARGB(255, 247, 5, 5);
  static const Color colorLightRed = Color.fromARGB(255, 79, 2, 2);
  static const Color colorRed = Color.fromARGB(255, 247, 5, 5);
  static const Color colorGreen = Color.fromARGB(255, 76, 175, 80);
  Color backgroundColor = const Color.fromARGB(255, 248, 246, 242);
  static const Color bgColor = Color.fromARGB(255, 248, 246, 242);
  static const Color colorGray = Color.fromARGB(255, 128, 128, 128);
  static const Color colorWhite = Color.fromARGB(255, 255, 255, 255);


  static const Gradient linerGradient = LinearGradient(
    colors: [
      Color.fromARGB(255, 108, 2, 1),
      Color.fromARGB(255, 217, 15, 15),
    ],
    begin: Alignment(0.0,0.0),
    end: Alignment(0.707 , -0.707),
  );
  
}