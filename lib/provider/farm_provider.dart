import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../models/user_model.dart';

part 'farm_provider.g.dart';

@riverpod
CollectionReference<Map<String, dynamic>> farmCollection(
    Ref ref) {
  return FirebaseFirestore.instance.collection('farms');
}

/// Provides a stream of the current user's FarmProfile.  Handles null user case.
@riverpod
Stream<FarmProfile?> currentFarmProfile(Ref ref) {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) {
    return Stream.value(null); // No user logged in
  }

  final collection = ref.watch(farmCollectionProvider);
  return collection.doc(user.uid).snapshots().map((snapshot) {
    if (snapshot.exists) {
      return FarmProfile.fromFirestore(snapshot);
    } else {
      return null; // Farm document doesn't exist for this user.
    }
  });
}

/// Fetches the farm profile by farm ID.  Returns null if not found.
@riverpod
Future<FarmProfile?> farmProfileById(
    Ref ref, String farmId) async {
  final collection = ref.read(farmCollectionProvider);
  final doc = await collection.doc(farmId).get();
  if (doc.exists) {
    return FarmProfile.fromFirestore(doc);
  } else {
    return null;
  }
}

/// Fetches account details for a specific farm. Returns a Map.
@riverpod
Future<Map<String, dynamic>> accountDetails(
    Ref ref, String farmId) async {
  final farmProfile =
      await ref.watch(farmProfileByIdProvider(farmId).future); // Use .future
  return farmProfile?.accountDetails ??
      {'accountName': '', 'bankName': '', 'accountNumber': ''};
}

/// Updates the farm profile.
@riverpod
Future<void> updateFarmProfile(
    Ref ref, FarmProfile updatedProfile) async {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) {
    throw Exception("User not logged in"); // Or handle more gracefully
  }

  final collection = ref.read(farmCollectionProvider);

  // Use toFirestore to get a Map for updating
  await collection.doc(user.uid).update(updatedProfile.toFirestore());
}

/// Updates the account details of current logged-in farm.
@riverpod
Future<void> updateAccountDetails(Ref ref,
    {required String accountName,
    required String bankName,
    required String accountNumber}) async {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) {
    throw Exception("User not logged in"); // Or handle more gracefully
  }
  final collection = ref.read(farmCollectionProvider);

  await collection.doc(user.uid).update({
    'accountDetails': {
      'accountName': accountName,
      'bankName': bankName,
      'accountNumber': accountNumber,
    }
  });
}

/// Creates a new farm profile during signup.  Requires email/password.
@riverpod
Future<void> createFarmProfile(Ref ref,
    {required String email,
    required String password,
    required String farmName,
    required String ownersName,
    required String mobile,
    required String address,
    required String farmState,
    required String lga}) async {
  try {
    // 1. Create User with Email/Password
    final userCredential =
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    final user = userCredential.user;
    if (user == null) {
      throw Exception("User creation failed.");
    }

    // 2. Create FarmProfile object
    final farmProfile = FarmProfile(
      farmName: farmName,
      ownersName: ownersName,
      mobile: mobile,
      email: email,
      address: address,
      imagePath: '', // Initially empty, can be updated later
      farmState: farmState,
      city: lga,
      userId: user.uid, // Set userId here
    );

    // 3. Save to Firestore
    final collection = ref.read(farmCollectionProvider);
    await collection.doc(user.uid).set(farmProfile.toFirestore());
  } on FirebaseAuthException catch (e) {
    //Important for error handling.
    throw Exception("Firebase Auth Exception: ${e.message}");
  } catch (e) {
    // General error handling.  Consider more specific error types.
    throw Exception("Failed to create farm profile: $e");
  }
}

/// Uploads a farm profile image and updates the FarmProfile.
@riverpod
Future<void> uploadFarmImage(Ref ref,
    {required Uint8List imageFile}) async {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) {
    throw Exception("User not logged in");
  }

  try {
    final storageRef = FirebaseStorage.instance
        .ref()
        .child('farms_profile_images')
        .child('${user.uid}.jpg');
    await storageRef.putData(imageFile);
    final imageUrl = await storageRef.getDownloadURL();

    final collection = ref.read(farmCollectionProvider);

    // Update the user's profile with the new image URL
    await collection.doc(user.uid).update({'imagePath': imageUrl});
  } catch (e) {
    // Handle storage upload errors
    throw Exception("Failed to upload image: $e");
  }
}

/// Signs in a user with email and password.  Doesn't return anything, relies on auth state changes.
@riverpod
Future<void> signInWithEmailAndPassword(Ref ref,
    {required String email, required String password}) async {
  try {
    await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    // Authentication state will be handled by the `currentFarmProfileProvider`.
  } on FirebaseAuthException catch (e) {
    // More specific error handling.
    if (e.code == 'user-not-found') {
      throw Exception('No user found for that email.');
    } else if (e.code == 'wrong-password') {
      throw Exception('Wrong password provided for that user.');
    } else {
      throw Exception('Firebase Auth Exception: ${e.message}');
    }
  } catch (e) {
    throw Exception("Failed to sign in: $e");
  }
}

/// Fetches a farm's name by its ID
@riverpod
Future<String> farmNameById(Ref ref, String farmId) async {
  final collection = ref.read(farmCollectionProvider);
  DocumentSnapshot farmDoc = await collection.doc(farmId).get();
  var farmData = farmDoc.data() as Map<String, dynamic>;
  return farmData['farmName'] ?? 'Farm Name Not Found'; // Provide a default
}

@riverpod
Future<String> farmerName(Ref ref) async {
  String? uid = FirebaseAuth.instance.currentUser?.uid;
  if (uid != null) {
    DocumentSnapshot snapshot =
        await ref.watch(farmCollectionProvider).doc(uid).get();
    if (snapshot.exists) {
      return snapshot['ownersName'] ?? '';
    }
  }
  return '';
}

@riverpod
class UserDetails extends _$UserDetails {
  @override
  Future<Map<String, dynamic>> build() async {
    String? userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId != null) {
      // Fetch user city from Firestore
      DocumentSnapshot<Map<String, dynamic>> userSnapshot =
          await ref.watch(farmCollectionProvider).doc(userId).get();
      if (userSnapshot.exists) {
        // Extract the details from the user data
        return {
          'userState': userSnapshot['state'],
          'userCity': userSnapshot['lga'] ?? 'Unknown',
          'farmName': userSnapshot['farmName'] ?? 'Farm Name Not Found',
        };
      }
    }
    return {
      'userState': '',
      'userCity': 'Unknown',
      'farmName': 'Farm Name Not Found',
    };
  }
}
