class Salary {
  final String? id;
  final String? nama;
  final String? kode;
  final String? status;
  final String? id_status_ptkp;
  final String? keterangan;
  final String? bulan;
  final String? kode_payroll;
  final String? waktu_input;

  Salary({
    this.id,
    this.nama,
    this.kode,
    this.status,
    this.id_status_ptkp,
    this.keterangan,
    this.bulan,
    this.kode_payroll,
    this.waktu_input,
  });

  factory Salary.fromJson(Map<String, dynamic> json) {
    return Salary(
      id: json['id'],
      nama: json['nama'],
      kode: json['kode'],
      status: json['status'],
      id_status_ptkp: json['id_status_ptkp'],
      keterangan: json['keterangan'],
      bulan: json['bulan'],
      kode_payroll: json['kode_payroll'],
      waktu_input: json['waktu_input'],
    );
  }

  @override
  String toString() {
    return 'Salary{id: $id, nama: $nama, kode: $kode, status: $status, id_status_ptkp: $id_status_ptkp, '
        'keterangan: $keterangan, bulan: $bulan, kode_payroll: $kode_payroll, waktu_input: $waktu_input}';
  }
}
