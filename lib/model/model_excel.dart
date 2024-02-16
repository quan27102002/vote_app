// ignore_for_file: public_member_api_docs, sort_constructors_first


class HoaDon {
  final String? hoTen;
  final String? maBenhNhan;
  final String? dienThoaidD;
  final int? maHoaDon;
  final String? thoiGianKham;
  final String? coSoKham;
  final String? bacSyPhuTrach;
  final String? tenDichVu;
  final int? soLuong;
  final double? donGia;
  final String? maCoSo;

  HoaDon({
    required this.maCoSo,
    required this.hoTen,
    required this.maBenhNhan,
    required this.dienThoaidD,
    required this.maHoaDon,
    required this.thoiGianKham,
    required this.coSoKham,
    required this.bacSyPhuTrach,
    required this.tenDichVu,
    required this.soLuong,
    required this.donGia,
  });

  factory HoaDon.fromJson(Map<String, dynamic> json) {
    return HoaDon(
      hoTen: json['HoTen'],
      maBenhNhan: json['MaBenhNhan'],
      dienThoaidD: json['DienThoaiDD'],
      maHoaDon: json['MaHoaDon'],
      thoiGianKham: json['ThoiGianKham'],
      coSoKham: json['CoSoKham'],
      bacSyPhuTrach: json['BacSyPhuTrach'],
      tenDichVu: json['TenDichVu'],
      soLuong: json['SoLuong'],
      donGia: json['DonGia'], 
      maCoSo: json['MaCoSo'],
    );
  }

  HoaDon copyWith({
    String? hoTen,
    String? maBenhNhan,
    String? dienThoaidD,
    int? maHoaDon,
    String? thoiGianKham,
    String? coSoKham,
    String? bacSyPhuTrach,
    String? tenDichVu,
    int? soLuong,
    double? donGia,
     String? maCoSo
  }) {
    return HoaDon(
      hoTen: hoTen ?? this.hoTen,
      maBenhNhan: maBenhNhan ?? this.maBenhNhan,
      dienThoaidD: dienThoaidD ?? this.dienThoaidD,
      maHoaDon: maHoaDon ?? this.maHoaDon,
      thoiGianKham: thoiGianKham ?? this.thoiGianKham,
      coSoKham: coSoKham ?? this.coSoKham,
      bacSyPhuTrach: bacSyPhuTrach ?? this.bacSyPhuTrach,
      tenDichVu: tenDichVu ?? this.tenDichVu,
      soLuong: soLuong ?? this.soLuong,
      donGia: donGia ?? this.donGia, 
      maCoSo: maCoSo ?? this.maCoSo,
    );
  }
}
