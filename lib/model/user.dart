class UserModel {
  final String? id;
  final String? fullName;
  final String? emailAddress;
  final String? phoneNumber;
  final String? avatar;
  final String? myCv;
  final String? location;
  final String? role;
  final String? joinDate;

  UserModel({
    this.id,
    this.fullName,
    this.emailAddress,
    this.phoneNumber,
    this.avatar,
    this.myCv,
    this.location,
    this.role,
    this.joinDate,
  });

  factory UserModel.fromJson(Map<String, dynamic>? json) {
    return UserModel(
      id: json?['id'] as String?,
      fullName: json?['full_name'] as String?,
      emailAddress: json?['email_address'] as String?,
      phoneNumber: json?['phone_number'] as String?,
      avatar: json?['avatar'] as String?,
      myCv: json?['my_cv'] as String?,
      location: json?['location'] as String?,
      role: json?['role'] as String?,
      joinDate: json?['joined_date'] as String?,
    );
  }
}
