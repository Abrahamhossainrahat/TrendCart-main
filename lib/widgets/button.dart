import 'package:flutter/material.dart';
import 'package:shopping_app/const/app-colors.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const CustomButton({super.key, 
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColor.colorRed,
        
      ),
    
      onPressed: onPressed,
      child: Text(text, style: const TextStyle(color: Colors.white),),
    );
  }
}