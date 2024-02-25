class BillIdUser {
  String? id;
  String? doctor;
  int? billCode;
  Service? service;

  BillIdUser({this.id, this.doctor, this.billCode, this.service});

  BillIdUser.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    doctor = json['doctor'];
    billCode = json['billCode'];
    service =
        json['service'] != null ? new Service.fromJson(json['service']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['doctor'] = this.doctor;
    data['billCode'] = this.billCode;
    if (this.service != null) {
      data['service'] = this.service!.toJson();
    }
    return data;
  }
}

class Service {
  String? name;
  int? amount;
  int? unitPrice;

  Service({this.name, this.amount, this.unitPrice});

  Service.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    amount = json['amount'];
    unitPrice = json['unitPrice'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['amount'] = this.amount;
    data['unitPrice'] = this.unitPrice;
    return data;
  }
}
