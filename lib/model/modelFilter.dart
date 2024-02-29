class Invoice {
  final String billCode;
  final String customerName;
  final String customerCode;
  final String phone;
  final String startTime;
  final String branchCode;
  final String doctor;
  final Service service;

  Invoice({
    required this.billCode,
    required this.customerName,
    required this.customerCode,
    required this.phone,
    required this.startTime,
    required this.branchCode,
    required this.doctor,
    required this.service,
  });

  factory Invoice.fromJson(Map<String, dynamic> json) {
    return Invoice(
      billCode: json['billCode'] as String,
      customerName: json['customerName'] as String,
      customerCode: json['customerCode'] as String,
      phone: json['phone'] as String,
      startTime: json['startTime'] as String,
      branchCode: json['branchCode'] as String,
      doctor: json['doctor'] as String,
      service: Service.fromJson(json['service'] as Map<String, dynamic>),
    );
  }
}

class Service {
  final String name;
  final int amount;
  final int unitPrice;

  Service({
    required this.name,
    required this.amount,
    required this.unitPrice,
  });

  factory Service.fromJson(Map<String, dynamic> json) {
    return Service(
      name: json['name'] as String,
      amount: json['amount'] as int,
      unitPrice: json['unitPrice'] as int,
    );
  }
}