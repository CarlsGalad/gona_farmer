import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  
  Future<User?> signInWithGoogle() async {
    try {
      // Begin interactive sign-in process
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      
      if (googleUser == null) {
        return null; // User canceled the sign-in flow
      }

      // Obtain auth details from request
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Create a new credential for the user
      final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);

      // Sign user in
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);

      // Check if the user is new (just signed in)
      if (userCredential.additionalUserInfo!.isNewUser) {
        // If the user is new, create a new user document in Firestore
        await createUserInFirestore(userCredential.user!);
      }

      // Return the user
      return userCredential.user;
    } catch (e) {
     debugPrint('Google sign in error: $e');
      return null;
    }
  }
  
  Future<User?> signInWithFacebook() async {
    try {
      // Create a new Facebook provider
      FacebookAuthProvider facebookProvider = FacebookAuthProvider();
      
      // Add scopes for additional permissions
      facebookProvider.addScope('email');
      facebookProvider.addScope('public_profile');
      
      // Sign in with Facebook using Firebase
      final UserCredential userCredential = 
          await _auth.signInWithProvider(facebookProvider);
      
      // Check if the user is new
      if (userCredential.additionalUserInfo!.isNewUser) {
        await createUserInFirestore(userCredential.user!);
      }
      
      return userCredential.user;
    } catch (e) {
      debugPrint('Facebook sign in error: $e');
      return null;
    }
  }
  
  Future<User?> signInWithApple() async {
    try {
      // Create an Apple provider
      final appleProvider = AppleAuthProvider();
      
      // Add scopes for additional permissions
      appleProvider.addScope('email');
      appleProvider.addScope('name');
      
      // Sign in with Apple using Firebase
      final UserCredential userCredential = 
          await _auth.signInWithProvider(appleProvider);
      
      // Check if the user is new
      if (userCredential.additionalUserInfo!.isNewUser) {
        await createUserInFirestore(userCredential.user!);
      }
      
      return userCredential.user;
    } catch (e) {
    debugPrint('Apple sign in error: $e');
      return null;
    }
  }

  Future<void> createUserInFirestore(User user) async {
    // Access Firestore instance
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    // Check if the user document already exists in Firestore
    DocumentSnapshot userSnapshot =
        await firestore.collection('users').doc(user.uid).get();

    // If the user document does not exist, create a new user document
    if (!userSnapshot.exists) {
      await firestore.collection('users').doc(user.uid).set(
        {
          'displayName': user.displayName ?? '',
          'email': user.email ?? '',
          'photoURL': user.photoURL ?? '',
          'phoneNumber': user.phoneNumber ?? '',
          'createdAt': FieldValue.serverTimestamp(),
          'lastLogin': FieldValue.serverTimestamp(),
        },
      );
    } else {
      // Update last login timestamp
      await firestore.collection('users').doc(user.uid).update({
        'lastLogin': FieldValue.serverTimestamp(),
      });
    }
  }

  static Future<void> signUpWithEmailAndPassword(
      String email, String password) async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      throw FirebaseAuthException(message: 'Sign-up failed: $e', code: '412');
    }
  }
  
  Future<void> signOut() async {
    await _auth.signOut();
    await GoogleSignIn().signOut();
  }
}