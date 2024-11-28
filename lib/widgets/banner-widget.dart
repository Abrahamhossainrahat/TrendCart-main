// ignore_for_file: prefer_const_constructors

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shopping_app/controller/banner-controller.dart';
import 'package:shopping_app/widgets/slider-image.dart';

class BannerWidget extends StatefulWidget {
  // ignore: use_super_parameters
  const BannerWidget({Key? key}) : super(key: key);

  @override
  State<BannerWidget> createState() => _BannerWidgetState();
}

class _BannerWidgetState extends State<BannerWidget> {
  final BannerController bannerController = Get.put(BannerController());

  @override
  Widget build(BuildContext context) {
    return Obx(() => CarouselSlider(
          options: CarouselOptions(
            viewportFraction: 1,
          ),
          items: bannerController.bannerUrls.map((imageURL) {
            return CachedNetworkImage(
              imageUrl: SliderImage(imageUrl: imageURL).imageUrl,
              placeholder: (context, url) => const Center(
                child: CircularProgressIndicator(),
              ),
              errorWidget: (context, url, error) => const Icon(Icons.error),
            );
          }).toList(),
        ));
  }
}
