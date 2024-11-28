import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shopping_app/models/wishlist-model.dart';

class WishlistController extends ChangeNotifier {
  List<WishListModel> _wishlistItems = [];

  List<WishListModel> get wishlistItems => _wishlistItems;

  WishlistController() {
    _loadWishlist();
  }

  void addToWishlist(WishListModel item) {
    final isAlreadyAdded = _wishlistItems
        .any((wishlistItem) => wishlistItem.productId == item.productId);
    if (!isAlreadyAdded) {
      _wishlistItems.clear(); // Clear existing items
      _wishlistItems.add(item); // Add the new item
      _saveWishlist();
      notifyListeners();
      _uploadWishlist(); // Upload to Firestore after adding to local list
    } else {
      print('Product already exists in the wishlist.');
    }
  }

  void removeFromWishlistById(String productId) async {
    _wishlistItems.removeWhere((item) => item.productId == productId);
    _saveWishlist();
    // clearWishlist();
    notifyListeners();

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw Exception('User is not logged in');
    }
    final userEmail = user.email ?? '';

    try {
      final DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('wishlist')
          .doc(userEmail)
          .get();

      if (!doc.exists) {
        throw Exception('Wishlist document does not exist');
      }

      List<dynamic> wishlistJson = doc['wishlist'];
      List<WishListModel> wishlist =
          wishlistJson.map((json) => WishListModel.fromMap(json)).toList();

      wishlist.removeWhere((item) => item.productId == productId);

      await FirebaseFirestore.instance
          .collection('wishlist')
          .doc(userEmail)
          .update({
        'wishlist': wishlist.map((item) => item.toMap()).toList(),
      });

      print('Item removed from wishlist in Firestore.');
    } catch (error) {
      print('Error removing item from wishlist in Firestore: $error');
    }
  }

  Future<void> _saveWishlist() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> wishlistJson =
        _wishlistItems.map((item) => json.encode(item.toMap())).toList();
    prefs.setStringList('wishlist', wishlistJson);
  }

  Future<void> _loadWishlist() async {
    final prefs = await SharedPreferences.getInstance();
    List<String>? wishlistJson = prefs.getStringList('wishlist');
    if (wishlistJson != null) {
      _wishlistItems = wishlistJson
          .map((item) => WishListModel.fromMap(json.decode(item)))
          .toList();
      notifyListeners();
    }
  }

  Future<void> _uploadWishlist() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw Exception('User is not logged in');
    }
    final userEmail = user.email ?? '';

    try {
      final DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('wishlist')
          .doc(userEmail)
          .get();

      List<WishListModel> currentWishlist = [];
      if (doc.exists) {
        List<dynamic> wishlistJson = doc['wishlist'];
        currentWishlist =
            wishlistJson.map((item) => WishListModel.fromMap(item)).toList();
      }

      // Add the current local wishlist items to the fetched wishlist
      currentWishlist.addAll(_wishlistItems);

      // Remove duplicates (if any)
      final updatedWishlist = currentWishlist.toSet().toList();

      await FirebaseFirestore.instance
          .collection('wishlist')
          .doc(userEmail)
          .set({
        'wishlist': updatedWishlist.map((item) => item.toMap()).toList(),
      });

      print('Wishlist uploaded successfully.');
    } catch (error) {
      print('Error uploading wishlist: $error');
    }
  }

  Future<void> fetchWishlist() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw Exception('User is not logged in');
    }
    final userEmail = user.email ?? '';

    try {
      final DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('wishlist')
          .doc(userEmail)
          .get();
      if (!doc.exists) {
        _wishlistItems = [];
        notifyListeners();
        return;
      }

      List<dynamic> wishlistJson = doc['wishlist'];
      _wishlistItems =
          wishlistJson.map((item) => WishListModel.fromMap(item)).toList();
      notifyListeners();
    } catch (error) {
      throw Exception('Error fetching wishlist: $error');
    }
  }

  Future<void> updateTimeSlot(WishListModel item, String newTimeSlot) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw Exception('User is not logged in');
    }
    final userEmail = user.email ?? '';

    try {
      final DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('wishlist')
          .doc(userEmail)
          .get();
      if (!doc.exists) {
        throw Exception('Wishlist document does not exist');
      }

      List<dynamic> wishlistJson = doc['wishlist'];
      List<WishListModel> wishlist =
          wishlistJson.map((json) => WishListModel.fromMap(json)).toList();

      for (var wishlistItem in wishlist) {
        if (wishlistItem.productId == item.productId) {
          wishlistItem.timeSlot = newTimeSlot;
          break;
        }
      }

      await FirebaseFirestore.instance
          .collection('wishlist')
          .doc(userEmail)
          .update({
        'wishlist': wishlist.map((item) => item.toMap()).toList(),
      });

      await fetchWishlist(); // Refresh the list
    } catch (error) {
      throw Exception('Error updating time slot: $error');
    }
  }
}
