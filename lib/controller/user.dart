import 'dart:convert';
import 'package:fgsdm/constant/environment.dart';
import 'package:http/http.dart' as http;
import '../model/user.dart';

class UserController {
  final _baseUrl = BASE_URL;

  static UserController instance = UserController();

  Future<User> login({required String username, required String password}) async {
    final response = await http.post(
      Uri.parse("${_baseUrl}Android/auth/logmein"),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'username': username,
        'password': password
      }),
    );

    print("Response body: " + response.body);

    if (response.statusCode == 200) {
      final Map<String, dynamic> userJson = jsonDecode(response.body);
      final User user = User.fromJsonLogin(userJson);
      print(user.toString());
      return user;
    } else if (response.statusCode == 401) {
      throw "Gagal Login! Username atau Password salah";
    } else {
      print("Login error: ${response.reasonPhrase}");
      throw "Gagal login! Terjadi kesalahan internal server";
    }
  }

  Future<User> identity({required String idKaryawan}) async {
    final response = await http.post(
      Uri.parse("${_baseUrl}Android/auth/identity"),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'id_karyawan': idKaryawan,
      }),
    );

    print("Response body: " + response.body);

    if (response.statusCode == 200) {
      final Map<String, dynamic> userJson = jsonDecode(response.body);
      final User user = User.fromJsonIdentity(userJson);
      print(user.toString());
      return user;
    } else {
      print("Get identity error: ${response.reasonPhrase}");
      throw "Terjadi kesalahan internal server";
    }
  }

  Future<bool> changeAvatar({required String idKaryawan, required String base64}) async {
    final response = await http.post(
      Uri.parse("${_baseUrl}Android/auth/change_avatar"),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'id_karyawan': idKaryawan,
        'foto': base64
      }),
    );

    print("Response body: " + response.body);

    if (response.statusCode == 200) {
      final Map<String, dynamic> json = jsonDecode(response.body);
      return json["status"];
    } else {
      print("Change Avatar error: ${response.reasonPhrase}");
      throw "Gagal mengubah foto profil! Terjadi kesalahan internal server";
    }
  }
}