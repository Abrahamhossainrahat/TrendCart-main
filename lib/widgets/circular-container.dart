import 'package:flutter/material.dart';
import 'package:shopping_app/const/app-colors.dart';

class CircularConatiner extends StatelessWidget {
  const CircularConatiner({
    super.key,
    this.width = 400.0,
    this.height = 400.0,
    this.radius = 400.0,
    this.padding = 0,
    this.bgColor = Colors.white,
    this.child,
    
  });

  final double? width, height;
  final double radius, padding;
  final Color bgColor;
  final Widget? child;
  
  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColor().backgroundColor,
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }
}