class UserProfile {
  final String name;
  final String email;
  final String imagePath;
  final String phoneNumber;
  final String address;
  final Map<String, dynamic>?
      billingInfo; // Update type to Map<String, dynamic>?

  UserProfile({
    required this.name,
    required this.email,
    required this.imagePath,
    required this.phoneNumber,
    required this.address,
    this.billingInfo, // Update type to Map<String, dynamic>?
  });
}
