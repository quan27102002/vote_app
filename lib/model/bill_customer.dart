class BillCustomer {
  String? hoTen;
  String? maBenhNhan;
  String? dienThoaiDD;
  String? maHoaDon;
  String? thoiGianKham;
  String? coSoKham;
  String? bacSyPhuTrach;
  String? tenDichVu;
  int? soLuong;
  double? donGia;
  String? maCoSo;

  BillCustomer(
      {this.hoTen,
      this.maBenhNhan,
      this.dienThoaiDD,
      this.maHoaDon,
      this.thoiGianKham,
      this.coSoKham,
      this.bacSyPhuTrach,
      this.tenDichVu,
      this.soLuong,
      this.donGia,
      this.maCoSo});

  BillCustomer.fromJson(Map<String, dynamic> json) {
    hoTen = json['HoTen'];
    maBenhNhan = json['MaBenhNhan'];
    dienThoaiDD = json['DienThoaiDD'];
    maHoaDon = json['MaHoaDon'];
    thoiGianKham = json['ThoiGianKham'];
    coSoKham = json['CoSoKham'];
    bacSyPhuTrach = json['BacSyPhuTrach'];
    tenDichVu = json['TenDichVu'];
    soLuong = json['SoLuong'];
    donGia = json['DonGia'];
    maCoSo = json['MaCoSo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['HoTen'] = this.hoTen;
    data['MaBenhNhan'] = this.maBenhNhan;
    data['DienThoaiDD'] = this.dienThoaiDD;
    data['MaHoaDon'] = this.maHoaDon;
    data['ThoiGianKham'] = this.thoiGianKham;
    data['CoSoKham'] = this.coSoKham;
    data['BacSyPhuTrach'] = this.bacSyPhuTrach;
    data['TenDichVu'] = this.tenDichVu;
    data['SoLuong'] = this.soLuong;
    data['DonGia'] = this.donGia;
    data['MaCoSo'] = this.maCoSo;
    return data;
  }
}
