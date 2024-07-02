import 'dart:convert';
import 'package:fgsdm/constant/environment.dart';
import 'package:fgsdm/model/attendance.dart';
import 'package:http/http.dart' as http;

class AttendanceController {
  final _baseUrl = BASE_URL;

  static AttendanceController instance = AttendanceController();

  Future<String> add({
    required String idKaryawan,
    required String latitude,
    required String longitude,
    required String status,
    required String location,
    required String foto,
  }) async {
    final response = await http.post(
      Uri.parse("${_baseUrl}Android/presensi/add"),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'id_karyawan': idKaryawan,
        'latitude': latitude,
        'longitude': longitude,
        'status': status,
        'location': location,
        'foto': foto,
      }),
    );

    print("Response body: " + response.body);

    if (response.statusCode == 200) {
      return jsonDecode(response.body)["message"];
    } else {
      print("Add attendance error: ${response.reasonPhrase}");
      throw "Gagal presensi!, terjadi kesalahan internal server";
    }
  }

  Future<List<Attendance>> resume({
    required String idKaryawan,
    required String bulan
  }) async {
    final response = await http.post(
      Uri.parse("${_baseUrl}Android/presensi/resume"),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'id_karyawan': idKaryawan,
        'bulan': bulan
      }),
    );

    print("Response body: " + response.body);

    if (response.statusCode == 200) {
      final Map<String, dynamic> attendanceJson = jsonDecode(response.body);
      final List<dynamic> attendanceList = attendanceJson['result'];
      return attendanceList.map((att) => Attendance.fromJson(att)).toList();
    } else {
      print("Get resume attendance error: ${response.reasonPhrase}");
      throw "";
    }
  }
}