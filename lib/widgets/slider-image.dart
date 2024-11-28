//ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_const_constructors_in_immutables, avoid_unnecessary_containers, prefer_const_constructors, file_names

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SliderImage extends StatelessWidget {
  const SliderImage({
    super.key,
    this.border,
    this.padding,
    this.height = 250.0,
    this.width = 300.0,
    this.applyImageRadius = false,
    required this.imageUrl,
    this.backgroundColor = Colors.transparent,
    this.fit = BoxFit.contain,
    this.isNetwrorkImage = true,
    this.onPressed,
    this.borderRadius = 10,
  
  });

  final double? width, height;
  final String imageUrl;
  final bool applyImageRadius;
  final BoxBorder? border;
  final Color backgroundColor;
  final BoxFit? fit;
  final EdgeInsetsGeometry? padding;
  final bool isNetwrorkImage;
  final voidCallback? onPressed;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){

      },
      child: Container(
        height: MediaQuery.of(context).size.height * .2, // Adjust height according to your needs
        width: MediaQuery.of(context).size.width * .35,
        decoration: BoxDecoration(
          border: border,
          color: backgroundColor,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        child: ClipRRect(
          borderRadius: applyImageRadius ? BorderRadius.circular(borderRadius) : BorderRadius.zero,
          child: Image(
            height: 75.h, // Adjust height according to your needs
            width: 150.w,
           fit: fit,
           image:AssetImage(imageUrl) as ImageProvider,
          ),
        ),
      ),
    );
  }
}

// ignore: camel_case_types
class voidCallback {

}
