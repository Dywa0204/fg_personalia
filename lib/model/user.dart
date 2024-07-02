class User {
  final String idUser;
  final String idKaryawan;
  final bool? status;
  final String? statusText;
  final String nama;
  final String user;
  final String level;
  final int code;
  final String? kode;
  final String? jekel;
  final String? noHp;
  final String? keterangan;
  final String? email;
  final String? tglMasuk;
  final String? mulaiProbation;
  final String? akhirProbation;
  final String? idBank;
  final String? norek;
  final String? gajiPokok;
  final String? idStatusPtkp;
  final String? hiddenStatus;
  final String? jabatan;


  User({
    this.jekel,
    this.noHp,
    this.keterangan,
    this.email,
    this.tglMasuk,
    this.mulaiProbation,
    this.akhirProbation,
    this.idBank,
    this.norek,
    this.gajiPokok,
    this.idStatusPtkp,
    this.hiddenStatus,
    this.jabatan,
    this.kode,
    this.statusText,
    required this.idUser,
    required this.idKaryawan,
    this.status,
    required this.nama,
    required this.user,
    required this.level,
    required this.code
  });

  factory User.fromJsonLogin(Map<String, dynamic> json) {
    User user = new User(
      idUser: json['id_user'],
      idKaryawan: json['id_karyawan'],
      status: json['status'],
      nama: json['nama'],
      user: json['user'],
      level: json['level'],
      code: json['code']
    );
    return user;
  }

  factory User.fromJsonIdentity(Map<String, dynamic> json) {
    User user = new User(
      idUser: json['id'],
      idKaryawan: json['id'],
      statusText: json['status'],
      status: false,
      nama: json['nama'],
      user: json['username'],
      level: json['level'],
      code: json['code'] ?? 0,
      kode: json['kode'],
      jekel: json['jekel'],
      noHp: json['no_hp'],
      keterangan: json['keterangan'],
      email: json['email'],
      mulaiProbation: json['mulai_probation'],
      akhirProbation: json['akhir_probation'],
      tglMasuk: json['tgl_masuk'],
      idBank: json['id_bank'],
      norek: json['norek'],
      gajiPokok: json['gaji_pokok'],
      idStatusPtkp: json['id_status_ptkp'],
      hiddenStatus: json['hidden_status'],
      jabatan: json['jabatan'],
    );
    return user;
  }

  factory User.fromJson(Map<String, dynamic> json) {
    User user = new User(
      idUser: json['idUser'],
      idKaryawan: json['idKaryawan'],
      status: json['status'],
      statusText: json['statusText'],
      nama: json['nama'],
      user: json['user'],
      level: json['level'],
      code: json['code'],
      kode: json['kode'],
      jekel: json['jekel'],
      noHp: json['noHp'],
      keterangan: json['keterangan'],
      email: json['email'],
      mulaiProbation: json['mulaiProbation'],
      akhirProbation: json['akhirProbation'],
      tglMasuk: json['tglMasuk'],
      idBank: json['idBank'],
      norek: json['norek'],
      gajiPokok: json['gajiPokok'],
      idStatusPtkp: json['idStatusPtkp'],
      hiddenStatus: json['hiddenStatus'],
      jabatan: json['jabatan'],
    );
    return user;
  }

  @override
  String toString() {
    return "{\"idUser\":\"$idUser\",\"idKaryawan\":\"$idKaryawan\",\"statusText\":\"$statusText\",\"status\":$status,\"nama\":\"$nama\",\"user\":\"$user\",\"level\":\"$level\",\"code\":$code,"+
    "\"kode\":\"$kode\",\"jekel\":\"$jekel\",\"noHp\":\"$noHp\",\"keterangan\":\"$keterangan\",\"email\":\"$email\",\"tglMasuk\":\"$tglMasuk\","+
    "\"mulaiProbation\":\"$mulaiProbation\",\"akhirProbation\":\"$akhirProbation\",\"idBank\":\"$idBank\",\"norek\":\"$norek\",\"gajiPokok\":\"$gajiPokok\","+
    "\"idStatusPtkp\":\"$idStatusPtkp\",\"hiddenStatus\":\"$hiddenStatus\",\"jabatan\":\"$jabatan\"}";
  }
}