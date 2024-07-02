import 'dart:convert';
import 'package:fgsdm/model/overtime.dart';
import 'package:http/http.dart' as http;

import '../constant/environment.dart';
import '../model/salary.dart';

class SalaryController {
  final _baseUrl = BASE_URL;

  static SalaryController instance = SalaryController();

  Future<List<Salary>> resume({required String id_karyawan}) async {
    final response = await http.post(
      Uri.parse("${_baseUrl}Android/penggajian/resume"),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'id_karyawan': id_karyawan,
      }),
    );

    print("Response body: " + response.body);

    if (response.statusCode == 200) {
      final List<dynamic> salaryList = jsonDecode(response.body);
      return salaryList.map((att) => Salary.fromJson(att)).toList();
    } else {
      print("Get resume salary error: ${response.reasonPhrase}");
      throw "";
    }
  }
}