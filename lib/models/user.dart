import 'package:equatable/equatable.dart';

class User extends Equatable {
  final int? id;
  final String? firstName;
  final String? lastName;
  final String? phoneNumber;
  final String? email;
  final String? jollyEmail;
  final String? country;
  final List<String>? personalizations;
  final String? createdAt;
  final String? updatedAt;

  const User({
    this.id,
    this.firstName,
    this.lastName,
    this.phoneNumber,
    this.email,
    this.jollyEmail,
    this.country,
    this.personalizations,
    this.createdAt,
    this.updatedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      phoneNumber: json['phone_number'],
      email: json['email'],
      jollyEmail: json['jolly_email'],
      country: json['country'],
      personalizations: json['personalizations'] != null
          ? List<String>.from(json['personalizations'])
          : null,
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      if (firstName != null) 'first_name': firstName?.trim(),
      if (lastName != null) 'last_name': lastName?.trim(),
      if (phoneNumber != null) 'phone_number': phoneNumber?.trim(),
      if (email != null) 'email': email?.trim(),
      if (jollyEmail != null) 'jolly_email': jollyEmail?.trim(),
      if (country != null) 'country': country?.trim(),
      if (personalizations != null) 'personalizations': personalizations,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    };
  }

  User copyWith({
    int? id,
    String? firstName,
    String? lastName,
    String? phoneNumber,
    String? email,
    String? jollyEmail,
    String? country,
    List<String>? personalizations,
    String? createdAt,
    String? updatedAt,
  }) {
    return User(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      email: email ?? this.email,
      jollyEmail: jollyEmail ?? this.jollyEmail,
      country: country ?? this.country,
      personalizations: personalizations ?? this.personalizations,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  bool get isEmpty => this == User.empty;
  bool get isNotEmpty => this != User.empty;

  static const empty = User();

  String get fullName => '${firstName ?? ''} ${lastName ?? ''}'.trim();

  @override
  List<Object?> get props => [
    id,
    firstName,
    lastName,
    phoneNumber,
    email,
    jollyEmail,
    country,
    personalizations,
    createdAt,
    updatedAt,
  ];

  @override
  String toString() {
    return 'User('
        'id: $id, '
        'firstName: $firstName, '
        'lastName: $lastName, '
        'phoneNumber: $phoneNumber, '
        'email: $email, '
        'jollyEmail: $jollyEmail, '
        'country: $country, '
        'personalizations: $personalizations, '
        'createdAt: $createdAt, '
        'updatedAt: $updatedAt)';
  }
}
