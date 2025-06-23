class UserModel {
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final String phone;
  final String birthdate;
  final String? avatarUrl;

  UserModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.birthdate,
    this.avatarUrl,
  });

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'],
      firstName: map['first_name'],
      lastName: map['last_name'],
      email: map['email'],
      phone: map['phone'],
      birthdate: map['birthdate'],
      avatarUrl: map['avatar_url'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'first_name': firstName,
      'last_name': lastName,
      'email': email,
      'phone': phone,
      'birthdate': birthdate,
      'avatar_url': avatarUrl,
    };
  }
}
