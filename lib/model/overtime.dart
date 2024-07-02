class Overtime {
  final String? id;
  final String? nama;
  final String? kode;
  final String? jabatan;
  final String? waktu_input;
  final String? waktu_mulai;
  final String? waktu_selesai;
  final String? durasi_istirahat;
  final String? total_durasi_lembur;
  final String? detail_pekerjaan;
  final String? status_approval_spv;
  final String? waktu_approval_spv;
  final String? status_approval_direksi;
  final String? waktu_approval_direksi;

  Overtime({
    this.id,
    this.waktu_input,
    this.nama,
    this.kode,
    this.jabatan,
    this.waktu_mulai,
    this.waktu_selesai,
    this.durasi_istirahat,
    this.total_durasi_lembur,
    this.detail_pekerjaan,
    this.status_approval_spv,
    this.waktu_approval_spv,
    this.status_approval_direksi,
    this.waktu_approval_direksi,
  });

  factory Overtime.fromJson(Map<String, dynamic> json) {
    return Overtime(
      id: json['id'],
      waktu_input: json['waktu_input'],
      nama: json['nama'],
      kode: json['kode'],
      jabatan: json['jabatan'],
      waktu_mulai: json['waktu_mulai'],
      waktu_selesai: json['waktu_selesai'],
      durasi_istirahat: json['durasi_istirahat'],
      total_durasi_lembur: json['total_durasi_lembur'],
      detail_pekerjaan: json['detail_pekerjaan'],
      status_approval_spv: json['status_approval_spv'],
      waktu_approval_spv: json['waktu_approval_spv'],
      status_approval_direksi: json['status_approval_direksi'],
      waktu_approval_direksi: json['waktu_approval_direksi'],
    );
  }

  @override
  String toString() {
    return '{id: $id, waktu_input: $waktu_input, nama: $nama, kode: $kode, jabatan: $jabatan, '
        'waktu_mulai: $waktu_mulai, waktu_selesai: $waktu_selesai, durasi_istirahat: $durasi_istirahat, '
        'total_durasi_lembur: $total_durasi_lembur, detail_pekerjaan: $detail_pekerjaan, '
        'status_approval_spv: $status_approval_spv, waktu_approval_spv: $waktu_approval_spv, '
        'status_approval_direksi: $status_approval_direksi, waktu_approval_direksi: $waktu_approval_direksi}';
  }
}
