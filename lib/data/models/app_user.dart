class AppUser {
  final String id;
  final String fullName;
  final String email;
  final String phone;
  final String tranzgoId;
  final String profileImageUrl;
  final String referralCode;
  final String role;
  final String status;

  const AppUser({
    required this.id,
    required this.fullName,
    required this.email,
    required this.phone,
    required this.tranzgoId,
    required this.profileImageUrl,
    required this.referralCode,
    required this.role,
    required this.status,
  });

  factory AppUser.fromJson(Map<String, dynamic> json) {
    return AppUser(
      id: json['id']?.toString() ?? '',
      fullName: json['fullName']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      phone: json['phone']?.toString() ?? '',
      tranzgoId: json['tranzgoId']?.toString() ?? '',
      profileImageUrl: json['profileImageUrl']?.toString() ?? '',
      referralCode: json['referralCode']?.toString() ?? '',
      role: json['role']?.toString() ?? '',
      status: json['status']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fullName': fullName,
      'email': email,
      'phone': phone,
      'tranzgoId': tranzgoId,
      'profileImageUrl': profileImageUrl,
      'referralCode': referralCode,
      'role': role,
      'status': status,
    };
  }
}
