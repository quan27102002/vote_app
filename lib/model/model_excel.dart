class HoaDon {
  final String id;
  final String customerName;
  final String customerCode;
  final String branchCode;
  final String branchAddress;
  final String phone;
  final int billCode;
  final String startTime;
  final String doctor;
  final String serviceName;
  final int amount;
  final int unitPrice;
  final int level;
  final String levelName;
  final List<Comment> comments;
  final String otherComment;

  HoaDon({
    required this.id,
    required this.customerName,
    required this.customerCode,
    required this.branchCode,
    required this.branchAddress,
    required this.phone,
    required this.billCode,
    required this.startTime,
    required this.doctor,
    required this.serviceName,
    required this.amount,
    required this.unitPrice,
    required this.level,
    required this.levelName,
    required this.comments,
    required this.otherComment,
  });

  factory HoaDon.fromJson(Map<String, dynamic> json) {
    List<Comment> comments = [];
    if (json['comment'] != null) {
      comments = (json['comment'] as List)
          .map((comment) => Comment.fromJson(comment))
          .toList();
    }

    return HoaDon(
      id: json['id'],
      customerName: json['customerName'],
      customerCode: json['customerCode'],
      branchCode: json['branchCode'],
      branchAddress: json['branchAddress'],
      phone: json['phone'],
      billCode: json['billCode'],
      startTime: json['startTime'],
      doctor: json['doctor'],
      serviceName: json['serviceName'],
      amount: json['amount'],
      unitPrice: json['unitPrice'],
      level: json['level'],
      levelName: json['levelName'],
      comments: comments,
      otherComment: json['otherComment'],
    );
  }
}

class Comment {
  final String id;
  final String content;

  Comment({required this.id, required this.content});

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      id: json['id'],
      content: json['content'],
    );
  }
}
