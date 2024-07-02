import 'dart:convert';
import 'package:fgsdm/model/leave.dart';
import 'package:fgsdm/model/master_leave.dart';
import 'package:http/http.dart' as http;

import '../constant/environment.dart';

class LeaveController {
  final _baseUrl = BASE_URL;

  static LeaveController instance = LeaveController();

  Future<Leave> resume({required String id_karyawan, String? tahun}) async {
    final response = await http.post(
      Uri.parse("${_baseUrl}Android/cuti/resume"),
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
      final Map<String, dynamic> leaveJson = jsonDecode(response.body);
      final List<dynamic> leaveList = leaveJson['data'];
      List<Leave> list = leaveList.map((att) => Leave.fromJson(att)).toList();
      final Leave leave = Leave.fromJsonAll(leaveJson, list);
      return leave;
    } else {
      print("Get resume leave error: ${response.reasonPhrase}");
      throw "";
    }
  }

  Future<List<MasterLeaveType>> master({String? keyword}) async {
    final response = await http.post(
      Uri.parse("${_baseUrl}Android/cuti/master_jenis_cuti"),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'keyword': keyword ?? '',
      }),
    );

    print("Response body: " + response.body);

    if (response.statusCode == 200) {
      final Map<String, dynamic> leaveJson = jsonDecode(response.body);
      final List<dynamic> leaveList = leaveJson['data'];
      return leaveList.map((att) => MasterLeaveType.fromJson(att)).toList();
    } else {
      print("Get master leave type error: ${response.reasonPhrase}");
      throw "";
    }
  }

  Future<String> add({
    String? id,
    required String id_karyawan,
    String? id_karyawan_pengganti,
    required String tanggal_mulai,
    required String tanggal_selesai,
    required String durasi,
    required String alasan_cuti,
    required String jenis_cuti,
  }) async {
    String requestBody = jsonEncode({
      if (id != null) 'id': id,
      'id_karyawan': id_karyawan,
      'id_karyawan_pengganti': id_karyawan_pengganti ?? "",
      'tanggal_mulai': tanggal_mulai,
      'tanggal_selesai': tanggal_selesai,
      'durasi': durasi,
      'alasan_cuti': alasan_cuti,
      'jenis_cuti': jenis_cuti,
    });

    final response = await http.post(
      Uri.parse("${_baseUrl}Android/cuti/add"),
      headers: {
        'Content-Type': 'application/json',
      },
      body: requestBody,
    );

    print(requestBody);

    if (response.statusCode == 200) {
      try {
        final Map<String, dynamic> leaveJson = jsonDecode(response.body);
        if (leaveJson['status']) return leaveJson['message'];
        else throw leaveJson['message'];
      } catch (e) {
        throw e.toString();
      }
    } else {
      print("Get master leave type error: ${response.reasonPhrase}");
      throw "${response.reasonPhrase}";
    }
  }
}