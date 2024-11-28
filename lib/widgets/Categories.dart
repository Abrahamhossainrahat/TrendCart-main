//ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, avoid_print, unused_field , unused_import, use_key_in_widget_constructors, avoid_unnecessary_containers, file_names
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:shopping_app/controller/cart-controller.dart';
import 'package:shopping_app/models/Category-model.dart';
import 'package:shopping_app/screens/user/single-category-product-screen.dart';


class Categories extends StatelessWidget {
  // const Categories({
  //   super.key,
  // });
  final CartController cartController = Get.find();
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: FirebaseFirestore.instance.collection("categories").get(),
      builder: (context,AsyncSnapshot<QuerySnapshot> snapshot) {
        if(snapshot.hasError){
          return Center(child: Text("Error: ${snapshot.error}"),);
        }
        else if(snapshot.connectionState == ConnectionState.waiting){
          return Center(child: CircularProgressIndicator());
        }
        else if(snapshot.hasData){
          return Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.only(bottom: 20),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * .2,
                  width: MediaQuery.of(context).size.width * .8,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: snapshot.data!.docs.map((DocumentSnapshot document) {
                        return Padding(
                          padding: const EdgeInsets.all(10),
                          child: GestureDetector(
                            onTap: () {
                              // Navigator.push(
                              //     context,
                              //     MaterialPageRoute(
                              //         builder: (context) => SingleProductView(categoryId:,)));
                            },
                            child: Column(
                              children: [
                                Image(
                                  image: CachedNetworkImageProvider(document['categoryImg']),
                                  height: 100.h,
                                ),
                                Text(document['categoryName']),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ],
            ),
          );
        }
        else if(snapshot.data!.docs.isEmpty){
          return Center(child: Text("No data found"),);
        }
        return Container();
      },
      // child: Column(
      //   crossAxisAlignment: CrossAxisAlignment.start,
      //   children: [
      //     const Padding(
      //       padding: EdgeInsets.only(bottom: 20),
      //     ),
      //     SizedBox(
      //       height: MediaQuery.of(context).size.height * .2,
      //       width: MediaQuery.of(context).size.width * .8,
      //       child: SingleChildScrollView(
      //         scrollDirection: Axis.horizontal,
      //         child: Row(
      //           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      //           children: [
      //             Padding(
      //               padding: const EdgeInsets.all(10),
      //               child: GestureDetector(
      //                 onTap: () {
      //                   Navigator.push(
      //                       context,
      //                       MaterialPageRoute(
      //                           builder: (context) => TshirtScreen()));
      //                 },
      //                 child: Column(
      //                   children: [
      //                     Image(
      //                       image:
      //                           const AssetImage("assets/Corporate/tshirt.jpg"),
      //                       height: 100.h,
      //                     ),
      //                     const Text("T - shirt"),
      //                   ],
      //                 ),
      //               ),
      //             ),
      //             Padding(
      //               padding: const EdgeInsets.all(10),
      //               child: GestureDetector(
      //                 onTap: () {
      //                   Navigator.push(
      //                       context,
      //                       MaterialPageRoute(
      //                           builder: (context) => CorporateScreen()));
      //                 },
      //                 child: Column(
      //                   children: [
      //                     Image(
      //                       image: const AssetImage("assets/Corporate/shirt.jpg"),
      //                       height: 100.h,
      //                     ),
      //                     const Text("Corporate"),
      //                   ],
      //                 ),
      //               ),
      //             ),
      //             Padding(
      //               padding: const EdgeInsets.all(10),
      //               child: GestureDetector(
      //                 onTap: () {
      //                   Navigator.push(context,
      //                       MaterialPageRoute(builder: (context) => MugScreen()));
      //                 },
      //                 child: Column(
      //                   children: [
      //                     Image(
      //                       image: const AssetImage("assets/Corporate/cup.jpg"),
      //                       height: 100.h,
      //                     ),
      //                     const Text("Mug"),
      //                   ],
      //                 ),
      //               ),
      //             ),
      //             Padding(
      //               padding: const EdgeInsets.all(10),
      //               child: GestureDetector(
      //                 onTap: () {
      //                   Navigator.push(context,
      //                       MaterialPageRoute(builder: (context) => CapScreen()));
      //                   Fluttertoast.showToast(msg: "CLicked");
      //                 },
      //                 child: Column(
      //                   children: [
      //                     Image(
      //                       image: const AssetImage("assets/Corporate/cap.jpg"),
      //                       height: 100.h,
      //                     ),
      //                     const Text("Cap"),
      //                   ],
      //                 ),
      //               ),
      //             ),
      //           ],
      //         ),
      //       ),
      //     ),
      //   ],
      // ),
    );
  }
}
