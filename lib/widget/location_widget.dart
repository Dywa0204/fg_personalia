import 'dart:async';
import 'dart:math';

import 'package:fgsdm/constant/custom_colors.dart';
import 'package:fgsdm/widget/responsive/responsive_image.dart';
import 'package:fgsdm/widget/responsive/responsive_text.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart' as geocoding;
import 'package:location/location.dart';

enum WidgetType {
  overlay,
  addressCard,
  slideUp,
}

extension WidgetTypeNumber on WidgetType {
  int get number {
    switch (this) {
      case WidgetType.overlay:
        return 1;
      case WidgetType.addressCard:
        return 2;
      case WidgetType.slideUp:
        return 3;
    }
  }
}

class LocationWidget extends StatefulWidget {
  final WidgetType widgetType;
  final LocationWidgetController? controller;
  final String? initialLocationStr;
  final String? initialAccuracyStr;
  final String? initialIsMockLocation;
  final String? initialDistanceStr;
  final String? initialCurrentAddress;

  LocationWidget({Key? key,
    required this.widgetType,
    this.controller,
    this.initialLocationStr,
    this.initialAccuracyStr,
    this.initialIsMockLocation,
    this.initialDistanceStr,
    this.initialCurrentAddress,
  }) : super(key: key);

  @override
  State<LocationWidget> createState() => _LocationWidgetState();
}

class _LocationWidgetState extends State<LocationWidget> {
  //define lib
  Location _location = Location();

  //define my location
  late String _locationStr = widget.initialLocationStr ?? "Lat: 0.0, Lng: 0.0";
  late String _accuracyStr = widget.initialAccuracyStr ?? "Akurasi: 9999 Meter";
  late String _isMockLocation = widget.initialIsMockLocation ?? "Lokasi Palsu: Tidak";
  late String _distanceStr = widget.initialDistanceStr ?? "Jarak dengan kantor: 999 Meter";
  late String _currentAddress = widget.initialCurrentAddress ?? "Memuat lokasi...";
  late double _distance = 0;
  late LocationData _currentLocation ;
  late StreamSubscription<LocationData> _locationSubscription;

  //define office location
  //FG loc : -7.703856, 110.350116
  double _officeLat = -7.703856;
  double _officeLng = 110.350116;
  late LocationData _officeLocation;
  double _maxRadius = 20; //in meter
  String _officeLocationStr = "";

  @override
  void initState() {
    super.initState();
    widget.controller?._attach(this);

    _officeLocation = LocationData.fromMap({
      "latitude": _officeLat,
      "longitude": _officeLng
    });
    _officeLocationStr = "Lat: ${_getFixed(_officeLat)}, Lng: ${_getFixed(_officeLng)}";

    _getCurrentLocation();
  }

  @override
  @override
  Widget build(BuildContext context) {
    switch(widget.widgetType) {
      case WidgetType.overlay:
        return Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Flexible(
                child: ResponsiveText(_currentAddress, textAlign: TextAlign.start, overflow: TextOverflow.ellipsis, maxLines: 2,),
              ),
              SizedBox(height: 16,),
              Row(
                children: [
                  ResponsiveText("Lokasi kantor", textAlign: TextAlign.start,),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(left: 8.0),
                      child: ResponsiveText(_officeLocationStr, textAlign: TextAlign.end,),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  ResponsiveText("Lokasi Anda", textAlign: TextAlign.start,),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(left: 8.0),
                      child: ResponsiveText(_locationStr, textAlign: TextAlign.end,),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  ResponsiveText("Jarak dg kantor", textAlign: TextAlign.start,),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(left: 8.0),
                      child: ResponsiveText(_distanceStr, textAlign: TextAlign.end,),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  ResponsiveText("Akurasi GPS", textAlign: TextAlign.start,),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(left: 8.0),
                      child: ResponsiveText(_accuracyStr, textAlign: TextAlign.end,),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  ResponsiveText("Lokasi palsu", textAlign: TextAlign.start,),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(left: 8.0),
                      child: ResponsiveText(_isMockLocation, textAlign: TextAlign.end,),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      case WidgetType.addressCard:
        return Flexible(
          child: ResponsiveText(
            _currentAddress,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600
            ),
          ),
        );
      case WidgetType.slideUp:
        return Container(
          width: double.infinity,
          height: 120,
          margin: EdgeInsets.symmetric(vertical: 16),
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(8)),
              color: CustomColor.primary
          ),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ResponsiveImage(
                    "assets/icons/pin.png",
                    width: 24,
                    height: 24,
                  ),
                  SizedBox(width: 8,),
                  Flexible(
                    child: ResponsiveText(
                      _currentAddress, textAlign: TextAlign.start,
                      overflow: TextOverflow.ellipsis, maxLines: 2,
                      style: TextStyle(
                          color: Colors.white
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16,),
              Row(
                children: [
                  Flexible(
                    child: ResponsiveText(
                      "Lokasi Anda: ${_locationStr}", textAlign: TextAlign.start,
                      overflow: TextOverflow.ellipsis, maxLines: 1,
                      style: TextStyle(fontSize: 12, color: Colors.white),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: ResponsiveText(
                      "Jarak dg kantor: ${_distanceStr}", textAlign: TextAlign.start,
                      overflow: TextOverflow.ellipsis, maxLines: 1,
                      style: TextStyle(fontSize: 12, color: Colors.white),
                    ),
                  ),
                  Flexible(
                    child: ResponsiveText(
                      "Akurasi GPS: ${_accuracyStr}", textAlign: TextAlign.end,
                      overflow: TextOverflow.ellipsis, maxLines: 1,
                      style: TextStyle(fontSize: 12, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      default:
        return Container();
    }
  }


  _getCurrentLocation() async {
    _locationSubscription = _location.onLocationChanged.listen((location) async {
      await _setLocation(location);
    });
  }

  Future<void> _setLocation(LocationData location) async {
    _currentLocation = location;
    _distance = _getDistance(destination: location);

    _getCurrentAddress(_distance);

    String _yourLat = location.latitude != null ? "${_getFixed(location.latitude!)}" : "0.0";
    String _yourLng = location.longitude != null ? "${_getFixed(location.longitude!)}" : "0.0";

    setState(() {
      _locationStr = "Lat: ${_yourLat}, Lng: ${_yourLng}";
      _accuracyStr = "${_getFixed(location.accuracy!, fractionDigits: 2)} Meter";
      _isMockLocation = "${location.isMock ?? false ? "Ya" : "Tidak"}";
      _distanceStr = "${_getFixed(_distance >= 1000 ? _distance / 1000 : _distance, fractionDigits: 2)} ${_distance < 1000 ? "Meter" : "KM"}";
    });
  }

  _getCurrentAddress(double distance) {
    setState(() {
      geocoding.placemarkFromCoordinates(_currentLocation.latitude!, _currentLocation.longitude!).then((value) {
        String subLocality = value[0].subLocality != null ? "${value[0].subLocality?.replaceAll("Dusun ", "").replaceAll("Desa ", "")}, " : "";
        String locality = value[0].locality != null ? "${value[0].locality?.replaceAll("Kecamatan ", "")}, " : "";
        String subAdministrative = value[0].subAdministrativeArea != null ? "${value[0].subAdministrativeArea?.replaceAll("Kabupaten ", "")}, " : "";
        String administrative = value[0].administrativeArea != null ? "${value[0].administrativeArea?.replaceAll("Provinsi ", "")}" : "";
        String address = "${subLocality}${locality}${subAdministrative}${subAdministrative}${administrative}";
        address = distance > _maxRadius ? address : "Kantor, ${address}";

        _currentAddress = address;
      }).catchError((onError) {
        _currentAddress = "Lokasi tidak ditemukan";
      });
    });
  }

  double _getDistance({required LocationData destination}) {
    double distance = sqrt(
        ( pow((_officeLocation.latitude! - destination.latitude!), 2) )
        +
        ( pow((_officeLocation.longitude! - destination.longitude!), 2) )
    ) / 360 * 40075017;

    return distance;
  }

  stopListening() {
    _locationSubscription.cancel();
  }

  @override
  void dispose() {
    stopListening();
    super.dispose();
  }

  String _getFixed(double num, {int? fractionDigits}) {
    return num.toStringAsFixed(fractionDigits ?? 4);
  }

  String _getLocationStr() {
    return _locationStr;
  }

  String _getAccuracyStr() {
    return _accuracyStr;
  }

  String _getIsMockLocation() {
    return _isMockLocation;
  }

  String _getDistanceStr() {
    return _distanceStr;
  }

  String _getCurrentAddressStr() {
    return _currentAddress;
  }
}

class LocationWidgetController {
  _LocationWidgetState? _state;

  void _attach(_LocationWidgetState state) {
    _state = state;
  }

  void _detach() {
    _state = null;
  }

  LocationData? getCurrentLocation() {
    return _state?._currentLocation;
  }

  String? getLocationStr() {
    return _state?._getLocationStr();
  }

  String? getAccuracyStr() {
    return _state?._getAccuracyStr();
  }

  String? getIsMockLocation() {
    return _state?._getIsMockLocation();
  }

  String? getDistanceStr() {
    return _state?._getDistanceStr();
  }

  String? getCurrentAddressStr() {
    return _state?._getCurrentAddressStr();
  }
}
