class Leave {
  final String? id;
  final String? waktu_input;
  final String? id_karyawan;
  final String? id_karyawan_pengganti;
  final String? tgl_mulai;
  final String? tgl_selesai;
  final String? durasi;
  final String? keterangan;
  final String? id_jenis_cuti;
  final String? status;
  final String? id_karyawan_approval;
  final String? waktu_approval;
  final String? catatan;
  final String? nama;
  final String? karyawan_pengganti;
  final String? nama_approval;
  final String? durasi_cuti;
  final String? sisa_cuti_tahunan;
  final List<Leave>? list;

  Leave({
    this.id,
    this.waktu_input,
    this.id_karyawan,
    this.id_karyawan_pengganti,
    this.tgl_mulai,
    this.tgl_selesai,
    this.durasi,
    this.keterangan,
    this.id_jenis_cuti,
    this.status,
    this.id_karyawan_approval,
    this.waktu_approval,
    this.catatan,
    this.nama,
    this.karyawan_pengganti,
    this.nama_approval,
    this.durasi_cuti,
    this.sisa_cuti_tahunan,
    this.list
  });

  factory Leave.fromJson(Map<String, dynamic> json) {
    return Leave(
      id: json['id'],
      waktu_input: json['waktu_input'],
      id_karyawan: json['id_karyawan'],
      id_karyawan_pengganti: json['id_karyawan_pengganti'],
      tgl_mulai: json['tgl_mulai'],
      tgl_selesai: json['tgl_selesai'],
      durasi: json['durasi'],
      keterangan: json['keterangan'],
      id_jenis_cuti: json['id_jenis_cuti'],
      status: json['status'],
      id_karyawan_approval: json['id_karyawan_approval'],
      waktu_approval: json['waktu_approval'],
      catatan: json['catatan'],
      nama: json['nama'],
      karyawan_pengganti: json['karyawan_pengganti'],
      nama_approval: json['nama_approval'],
      durasi_cuti: json['durasi_cuti'],
    );
  }

  factory Leave.fromJsonAll(Map<String, dynamic> json, List<Leave> listLeave) {
    return Leave(
      list: listLeave,
      sisa_cuti_tahunan: json['sisa_cuti_tahunan']
    );
  }

  @override
  String toString() {
    return '{id: $id, waktu_input: $waktu_input, id_karyawan: $id_karyawan, '
        'id_karyawan_pengganti: $id_karyawan_pengganti, tgl_mulai: $tgl_mulai, '
        'tgl_selesai: $tgl_selesai, durasi: $durasi, keterangan: $keterangan, '
        'id_jenis_cuti: $id_jenis_cuti, status: $status, '
        'id_karyawan_approval: $id_karyawan_approval, '
        'waktu_approval: $waktu_approval, catatan: $catatan, '
        'nama: $nama, karyawan_pengganti: $karyawan_pengganti, '
        'nama_approval: $nama_approval, durasi_cuti: $durasi_cuti'
        '}';
  }
}
