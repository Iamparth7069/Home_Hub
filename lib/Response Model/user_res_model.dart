class UserResModel {
  String firstName;
  String lastName;
  String phoneNumber;
  String address;
  String email;
  String uId;
  String profileImage;
  String? fcmToken;

  UserResModel({
    required this.firstName,
    required this.lastName,
    required this.phoneNumber,
    required this.address,
    required this.email,
    required this.uId,
    required this.profileImage,
    required this.fcmToken,
  });

  // Method to convert UserData to a Map
  Map<String, dynamic> toMap() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'phoneNumber': phoneNumber,
      'address': address,
      'uId': uId,
      'email': email,
      'fcmToken': fcmToken,
      'profileImage': profileImage,
    };
  }

  // Factory constructor to create a UserData instance from a Map
  factory UserResModel.fromMap(Map<String, dynamic> map) {
    return UserResModel(
        firstName: map['firstName'],
        lastName: map['lastName'],
        phoneNumber: map['phoneNumber'],
        address: map['address'],
        uId: map['uId'],
        email: map['email'],
        fcmToken: map['fcmToken'],
        profileImage: map['profileImage']);
  }
}
