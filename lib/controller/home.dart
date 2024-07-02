import 'dart:convert';
import 'package:fgsdm/model/leave.dart';
import 'package:fgsdm/model/master_leave.dart';
import 'package:fgsdm/model/overtime.dart';
import 'package:http/http.dart' as http;

import '../constant/environment.dart';
import '../model/home.dart';

class HomeController {
  final _baseUrl = BASE_URL;

  static HomeController instance = HomeController();

  Future<Home> home({required String idKaryawan, required String level}) async {
    final response = await http.post(
      Uri.parse("${_baseUrl}Android/auth/home"),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'id_karyawan': idKaryawan,
        'level' : level
      }),
    );

    print("Response body: " + response.body);

    if (response.statusCode == 200) {
      final Map<String, dynamic> homeJson = jsonDecode(response.body);

      final List<dynamic> leave = homeJson['usulan_cuti'];
      List<Leave> leaveList = leave.map((att) => Leave.fromJson(att)).toList();

      final List<dynamic> overtime = homeJson['usulan_lembur'];
      List<Overtime> overtimeList = overtime.map((att) => Overtime.fromJson(att)).toList();

      String leaveLeft = homeJson['sisa_cuti_tahunan'];
      String next = homeJson['next_gajian'];

      return Home(
          usulan_cuti: leaveList,
          usulan_lembur: overtimeList,
          sisa_cuti_tahunan: leaveLeft,
          next_gajian: next
      );
    } else {
      print("Get home content error: ${response.reasonPhrase}");
      throw "";
    }
  }
}