class ReadUsers {
  final String displayName;
  final String email;
  final String userName;
  final String code;
  final String branchAddress;
  final String userRole;
  final String userStatus;
  final DateTime createdOn;

  ReadUsers({
    required this.displayName,
    required this.email,
    required this.userName,
    required this.code,
    required this.branchAddress,
    required this.userRole,
    required this.userStatus,
    required this.createdOn,
  });

  factory ReadUsers.fromJson(Map<String, dynamic> json) {
    return ReadUsers(
      displayName: json['displayName'],
      email: json['email'],
      userName: json['userName'],
      code: json['code'],
      branchAddress: json['branchAddress'],
      userRole: json['userRole'],
      userStatus: json['userStatus'],
      createdOn: DateTime.parse(json['createdOn']),
    );
  }
}
