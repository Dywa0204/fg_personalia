class Attendance {
  final String? tanggalFull;
  final String? hari;
  final String? tanggal;
  final String? bulan;
  final String? tahun;
  final String? masuk;
  final String? pulang;
  final String? terlambat;
  final String? locationIn;
  final String? locationOut;

  Attendance({
    this.tanggalFull,
    this.hari,
    this.tanggal,
    this.bulan,
    this.tahun,
    this.masuk,
    this.pulang,
    this.terlambat,
    this.locationIn,
    this.locationOut,
  });

  factory Attendance.fromJson(Map<String, dynamic> json) {
    Attendance user = new Attendance(
        tanggalFull: json['tanggal_full'],
        hari: json['hari'],
        tanggal: json['tanggal'],
        bulan: json['bulan'],
        tahun: json['tahun'],
        masuk: json['masuk'],
        pulang: json['pulang'],
        terlambat: json['terlambat'],
        locationIn: json['location_in'],
        locationOut: json['location_out']
    );
    return user;
  }
}