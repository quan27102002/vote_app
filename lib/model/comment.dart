class ListComment {
  int? id;
  String? type;
  Detail? detail;

  ListComment({this.id, this.type, this.detail});

  ListComment.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    type = json['type'];
    detail =
        json['detail'] != null ? new Detail.fromJson(json['detail']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['type'] = this.type;
    if (this.detail != null) {
      data['detail'] = this.detail!.toJson();
    }
    return data;
  }
}

class Detail {
  String? s0;
  String? s1;
  String? s2;

  Detail({this.s0, this.s1, this.s2});

  Detail.fromJson(Map<String, dynamic> json) {
    s0 = json['0'];
    s1 = json['1'];
    s2 = json['2'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['0'] = this.s0;
    data['1'] = this.s1;
    data['2'] = this.s2;
    return data;
  }
}
