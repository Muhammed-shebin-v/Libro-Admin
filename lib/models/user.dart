class User {
  final String uid;
  final String username;
  final String email;
  final String address;
  final String phoneNumber;

  User({
    required this.uid,
    required this.username,
    required this.email,
    required this.address,
    required this.phoneNumber,
  });

  factory User.fromMap(Map<String, dynamic> data) {
    return User(
      uid: data['uid'] ?? '',
      username: data['username'] ?? '',
      email: data['email'] ?? '',
      address: data['address'] ?? '',
      phoneNumber: data['phoneNumber'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'username': username,
      'email': email,
      'address': address,
      'phoneNumber': phoneNumber,
    };
  }
}