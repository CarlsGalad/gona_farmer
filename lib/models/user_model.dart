import 'package:cloud_firestore/cloud_firestore.dart';


class FarmProfile {
  final String farmName;
  final String ownersName;
  final String mobile;
  final String email;
  final String address;
  final String imagePath;
  final String farmState;
  final String city; // Changed from lga to city (more general)
  final String userId; //Added User Id
  final Timestamp? createdAt;
  final Map<String, dynamic>? accountDetails;
  final String? totalSales;
  final String? totalEarnings;

  FarmProfile(
      {required this.farmName,
      required this.ownersName,
      required this.mobile,
      required this.email,
      required this.address,
      required this.imagePath,
      required this.farmState,
      required this.city,
      required this.userId,
      this.createdAt,
      this.accountDetails,
      this.totalSales,
      this.totalEarnings});

  factory FarmProfile.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return FarmProfile(
      farmName: data['farmName'] ?? '',
      ownersName: data['ownersName'] ?? '',
      mobile: data['mobile'] ?? '',
      email: data['email'] ?? '',
      address: data['address'] ?? '',
      imagePath: data['imagePath'] ?? '',
      farmState: data['state'] ?? '',
      city: data['lga'] ?? '', // Keep lga and map to city
      userId: data['userId'] ?? '',
      createdAt: data['createdAt'] as Timestamp?,
      accountDetails: data['accountDetails'] as Map<String, dynamic>?,
      totalSales: data['totalSales']?.toString(),
      totalEarnings: data['totalEarnings']?.toString(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'farmName': farmName,
      'ownersName': ownersName,
      'mobile': mobile,
      'email': email,
      'address': address,
      'imagePath': imagePath,
      'state': farmState,
      'lga': city, // Keep lga
      'userId': userId,
      'createdAt': createdAt ??
          FieldValue.serverTimestamp(), // Use serverTimestamp for new farms
      'accountDetails': accountDetails ??
          {'accountName': '', 'bankName': '', 'accountNumber': ''}, // Default
      'totalSales': totalSales ?? '',
      'totalEarnings': totalEarnings ?? '',
    };
  }
}
