class UserModel {
  int? id;
  String email;
  String name;
  String mobileNumber;
  String dateOfBirth;
  UserModel(
      {this.id,
      required this.name,
      required this.email,
      required this.mobileNumber,
      required this.dateOfBirth});
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'mobileNumber': mobileNumber,
      'dateOfBirth': dateOfBirth,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'],
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      mobileNumber: map['mobileNumber'] ?? '',
      dateOfBirth: map['dateOfBirth'] ?? '',
    );
  }
  UserModel copyWith({
    int? id,
    String? name,
    String? email,
    String? mobileNumber,
    String? dateOfBirth,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      mobileNumber: mobileNumber ?? this.mobileNumber,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
    );
  }

  @override
  String toString() {
    return 'UserModel{id: $id, name: $name, email: $email, mobileNumber: $mobileNumber, dateOfBirth: $dateOfBirth}';
  }
}
