import 'dart:convert';

class UserInfoModel {
  final String username;
  final String password;
  final String firstName;
  final String lastName;
  final String dateOfBirth;
  final String gender;
  final Map<String, dynamic> palmistryInfo;
  final bool isSynced;
  final String? lastSyncedAt;

  UserInfoModel({
    required this.username,
    required this.password,
    required this.firstName,
    required this.lastName,
    required this.dateOfBirth,
    required this.gender,
    required this.palmistryInfo,
    this.isSynced = false,
    this.lastSyncedAt,
  });

  // Convert to Map for SharedPreferences local storage
  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'password': password,
      'first_name': firstName,
      'last_name': lastName,
      'date_of_birth': dateOfBirth,
      'gender': gender,
      'palmistry_info': palmistryInfo,
      'is_synced': isSynced,
      'last_synced_at': lastSyncedAt,
    };
  }

  // Convert to JSON payload formatted for FastAPI backend server
  Map<String, dynamic> toServerJson() {
    return {
      'username': username,
      'password': password,
      'first_name': firstName,
      'last_name': lastName,
      'date_of_birth': dateOfBirth,
      'gender': gender,
      'palmistry_info': palmistryInfo,
    };
  }

  // Factory constructor to build UserInfoModel from JSON
  factory UserInfoModel.fromJson(Map<String, dynamic> json) {
    Map<String, dynamic> palmData = {};
    if (json['palmistry_info'] != null) {
      if (json['palmistry_info'] is Map) {
        palmData = Map<String, dynamic>.from(json['palmistry_info']);
      } else if (json['palmistry_info'] is String) {
        try {
          palmData =
              Map<String, dynamic>.from(jsonDecode(json['palmistry_info']));
        } catch (_) {}
      }
    }

    return UserInfoModel(
      username: json['username'] ?? '',
      password: json['password'] ?? '',
      firstName: json['first_name'] ?? '',
      lastName: json['last_name'] ?? '',
      dateOfBirth: json['date_of_birth'] ?? '',
      gender: json['gender'] ?? 'مرد',
      palmistryInfo: palmData,
      isSynced: json['is_synced'] ?? false,
      lastSyncedAt: json['last_synced_at'],
    );
  }

  UserInfoModel copyWith({
    String? username,
    String? password,
    String? firstName,
    String? lastName,
    String? dateOfBirth,
    String? gender,
    Map<String, dynamic>? palmistryInfo,
    bool? isSynced,
    String? lastSyncedAt,
  }) {
    return UserInfoModel(
      username: username ?? this.username,
      password: password ?? this.password,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      gender: gender ?? this.gender,
      palmistryInfo: palmistryInfo ?? this.palmistryInfo,
      isSynced: isSynced ?? this.isSynced,
      lastSyncedAt: lastSyncedAt ?? this.lastSyncedAt,
    );
  }
}
