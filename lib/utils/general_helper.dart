import 'dart:convert';
import 'dart:io' show Platform;

import 'package:camera/camera.dart';
import 'package:fgsdm/constant/environment.dart';
import 'package:fgsdm/model/master_leave.dart';
import 'package:flutter/cupertino.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/user.dart';

class GeneralHelper {
  static late CameraDescription firstCamera;
  static late List<CameraDescription> availableCamera;
  static encrypt.Key key = encrypt.Key.fromUtf8(ENCRYPT_KEY);
  static encrypt.IV iv = encrypt.IV.fromUtf8(ENCRYPT_IV);
  static encrypt.Encrypter encryptor = encrypt.Encrypter(encrypt.AES(key));
  static late SharedPreferences preferences;
  static late bool isStatusIN;
  static late List<MasterLeaveType> listMasterLeaveType;
  static late double scalingFactorDivide = 500;
  static late double scalingPercentage;
  static bool isSettingUpdate = false;
  static bool isProfileUpdate = false;
  static bool isUseAlert = true;

  static Future<void> initializeApp() async {
    preferences = await SharedPreferences.getInstance();
    await initializeDateFormatting('id_ID', null);
    isStatusIN = await GeneralHelper.preferences.getBool('isAttendanceIN') ?? true;

    String master = preferences.getString("masterLeaveType") ?? "";
    if (master.isNotEmpty) {
      final Map<String, dynamic> masterJson = jsonDecode(master);
      final List<dynamic> masterList = masterJson['data'];
      listMasterLeaveType = masterList.map((att) => MasterLeaveType.fromJson(att)).toList();
    }

    scalingPercentage = preferences.getDouble("scalingFactor") ?? 100;
    scalingFactorDivide = 500 * (200 - scalingPercentage) / 100;

    isUseAlert = preferences.getBool("isUseAlert") ?? true;
  }

  static Future<void> initializeFirstCamera() async {
    availableCamera = await availableCameras();
    firstCamera = Platform.isAndroid ? availableCamera.last : availableCamera.first;
    await requestLocationPermission();
  }

  static Future<String> encryptText(String plainText) async {
    return await encryptor.encrypt(plainText, iv: iv).base64;
  }

  static Future<String> decryptText(String cipherText) async {
    return await encryptor.decrypt(encrypt.Encrypted.fromBase64(cipherText), iv: iv);
  }

  static Future<User?> getUserFromPreferences() async {
    String userToken = await GeneralHelper.preferences.getString('userToken') ?? "";

    if (!userToken.isEmpty) {
      String decryptedUser = await GeneralHelper.decryptText(userToken);

      final Map<String, dynamic> userJson = jsonDecode(decryptedUser);
      User user = User.fromJson(userJson);

      return user;
    } else {
      return null;
    }
  }

  static Future<void> requestLocationPermission() async {
    Location location = new Location();

    bool _serviceEnabled;
    PermissionStatus _permissionGranted;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }
  }

  static String convertDate(String dateString, {String? format}) {
    DateTime dateTime = DateTime.parse(dateString);
    DateFormat dateFormat = DateFormat(format ?? 'd MMMM yyyy', 'id_ID');
    String formattedDate = dateFormat.format(dateTime);

    return formattedDate;
  }

  static String convertDateTime(String dateString) {
    DateTime dateTime = DateTime.parse(dateString);
    DateFormat dateFormat = DateFormat('d MMMM yyyy - HH:mm', 'id_ID');
    String formattedDate = dateFormat.format(dateTime);

    return formattedDate;
  }

  static double calculateSize(BuildContext context, double size) {
    double baseSize = size;
    double screenWidth = MediaQuery.of(context).size.width;
    double scalingFactor = screenWidth / scalingFactorDivide;
    double result = baseSize * scalingFactor;
    return result < size ? result : size;
  }

  static setScalingSize(double percentage) async {
    preferences = await SharedPreferences.getInstance();
    scalingFactorDivide = 500 * (200 - percentage) / 100;
    scalingPercentage = percentage;

    preferences.setDouble("scalingFactor", percentage);
  }

  static setUseAlert(bool isUse) async {
    isUseAlert = isUse;

    preferences = await SharedPreferences.getInstance();
    preferences.setBool("isUseAlert", isUse);
  }
}