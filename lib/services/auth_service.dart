import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';


class AuthService {
  Future<User?> signInWithGoogle() async {
    // Begin interactive sign-in process
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain auth details from request
    final GoogleSignInAuthentication googleAuth =
        await googleUser!.authentication;

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
        },
      );
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
}
