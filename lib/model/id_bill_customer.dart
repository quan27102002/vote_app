class BillIdUser {
  String? id;
  String? billCode;
  List<Service>? service;

  BillIdUser({this.id, this.billCode, this.service});

  BillIdUser.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    billCode = json['billCode'];
    if (json['service'] != null) {
      service = <Service>[];
      json['service'].forEach((v) {
        service!.add(new Service.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['billCode'] = this.billCode;
    if (this.service != null) {
      data['service'] = this.service!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Service {
  String? name;
  String? doctor;
  int? amount;
  int? unitPrice;

  Service({this.name, this.doctor, this.amount, this.unitPrice});

  Service.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    doctor = json['doctor'];
    amount = json['amount'];
    unitPrice = json['unitPrice'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['doctor'] = this.doctor;
    data['amount'] = this.amount;
    data['unitPrice'] = this.unitPrice;
    return data;
  }
}
