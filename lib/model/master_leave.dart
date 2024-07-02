class MasterLeaveType{
  final String? id;
  final String? nama;
  final String? keterangan;

  MasterLeaveType({
    this.id,
    this.nama,
    this.keterangan,
  });

  factory MasterLeaveType.fromJson(Map<String, dynamic> json) {
    return MasterLeaveType(
      id: json['id'],
      nama: json['nama'],
      keterangan: json['keterangan'],
    );
  }

  @override
  String toString() {
    return "{\"id\":\"$id\",\"nama\":\"$nama\",\"keterangan\":\"$keterangan\"}";
  }
}