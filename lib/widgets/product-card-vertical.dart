import 'package:flutter/material.dart';

class ProductCardVertical extends StatelessWidget {
  const ProductCardVertical({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 180,
      padding: const EdgeInsets.all(1),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 7,
            blurRadius: 50,
            offset: const Offset(0, 2), // changes position of shadow
          ),
          
        ],
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
      ),
      child: Container(
        height: 100,
        width: 100,
        padding: const EdgeInsets.all(10),
        decoration: const BoxDecoration(
          
        ),
      ),
    );
  }
}