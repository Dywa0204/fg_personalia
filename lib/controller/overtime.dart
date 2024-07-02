import 'dart:convert';
import 'package:fgsdm/model/overtime.dart';
import 'package:http/http.dart' as http;

import '../constant/environment.dart';

class OvertimeController {
  final _baseUrl = BASE_URL;

  static OvertimeController instance = OvertimeController();

  Future<List<Overtime>> resume({required String id_karyawan, String? tahun}) async {
    final response = await http.post(
      Uri.parse("${_baseUrl}Android/lembur/resume"),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'id_karyawan': id_karyawan,
        'tahun' : tahun ?? ''
      }),
    );

    print("Response body: " + response.body);

    if (response.statusCode == 200) {
      final List<dynamic> overtimeList = jsonDecode(response.body);
      return overtimeList.map((att) => Overtime.fromJson(att)).toList();
    } else {
      print("Get resume overtime error: ${response.reasonPhrase}");
      throw "";
    }
  }
  //
  // Future<List<MasterLeaveType>> master({String? keyword}) async {
  //   final response = await http.post(
  //     Uri.parse("${_baseUrl}Android/cuti/master_jenis_cuti"),
  //     headers: {
  //       'Content-Type': 'application/json',
  //     },
  //     body: jsonEncode({
  //       'keyword': keyword ?? '',
  //     }),
  //   );
  //
  //   print("Response body: " + response.body);
  //
  //   if (response.statusCode == 200) {
  //     final Map<String, dynamic> leaveJson = jsonDecode(response.body);
  //     final List<dynamic> leaveList = leaveJson['data'];
  //     return leaveList.map((att) => MasterLeaveType.fromJson(att)).toList();
  //   } else {
  //     print("Get master leave type error: ${response.reasonPhrase}");
  //     throw "";
  //   }
  // }
  //
  Future<String> add({
    String? id,
    required String id_karyawan,
    required String waktu_mulai,
    required String waktu_selesai,
    required String durasi_istirahat,
    required String detail_pekerjaan
  }) async {
    String requestBody = jsonEncode({
      if (id != null) 'id': id,
      'id_karyawan': id_karyawan,
      'waktu_mulai': waktu_mulai,
      'waktu_selesai': waktu_selesai,
      'durasi_istirahat': durasi_istirahat,
      'detail_pekerjaan': detail_pekerjaan
    });

    final response = await http.post(
      Uri.parse("${_baseUrl}Android/lembur/add"),
      headers: {
        'Content-Type': 'application/json',
      },
      body: requestBody,
    );

    print(requestBody);
    print("Get master overtime type error: ${response.body}");

    if (response.statusCode == 200) {
      try {
        final Map<String, dynamic> overtimeJson = jsonDecode(response.body);
        if (overtimeJson['status']) return overtimeJson['message'];
        else throw overtimeJson['message'];
      } catch (e) {
        throw e.toString();
      }
    } else {

      throw "${response.reasonPhrase}";
    }


  }
}