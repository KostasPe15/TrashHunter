import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

/// Tracks the selected page (e.g., for a BottomNavigationBar)
ValueNotifier<int> selectedPageNotifier = ValueNotifier(0);

/// Holds the current user's data
ValueNotifier<Map<String, dynamic>?> userDataNotifier = ValueNotifier(null);

/// Fetch user data and update the notifier
Future<void> fetchUserData() async {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) {
    userDataNotifier.value = null;
    return;
  }

  try {
    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();
    if (doc.exists) {
      final data = doc.data();
      userDataNotifier.value = {
        'firstName': data?['first_name'] ?? '',
        'lastName': data?['last_name'] ?? '',
        'email': user.email ?? '',
      };
    } else {
      userDataNotifier.value = null;
    }
  } catch (e) {
    print('Error fetching user data: $e');
    userDataNotifier.value = null;
  }
}
