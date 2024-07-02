import 'package:fgsdm/screen/list_more_screen.dart';
import 'package:fgsdm/widget/list_item/attendance_item.dart';
import 'package:fgsdm/widget/responsive/responsive_image.dart';
import 'package:fgsdm/widget/responsive/responsive_text.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:popover/popover.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

import '../../constant/custom_colors.dart';
import '../../controller/attendance.dart';
import '../../model/attendance.dart';
import '../../utils/general_helper.dart';
import '../../widget/custom/custom_card.dart';
import '../../widget/custom/custom_loading_list.dart';
import '../../widget/custom/custom_mini_button.dart';
import '../../widget/custom/custom_snackbar.dart';
import '../../widget/location_widget.dart';

class AttendanceScreen extends StatefulWidget {
  final Function(String)? onClick;
  final AttendanceScreenController? controller;
  AttendanceScreen({Key? key, this.onClick, this.controller}) : super(key: key);

  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  late String _name = "Napoleon Bonaparte";
  late String _idKaryawan = "0";

  DateTime _dateNow = DateTime.now();
  late String _dateNowStr = "";

  AttendanceController _attendanceController = AttendanceController();
  List<Attendance> _attendanceList = [];
  bool _isLoading = false;
  bool _isError = false;

  LocationWidgetController locationWidgetController = LocationWidgetController();

  @override
  void initState() {
    super.initState();

    _initializeUser();
    _dateNowStr = DateFormat('EEEE, dd MMMM yyyy', 'id_ID').format(_dateNow);

    widget.controller?._attach(this);
  }

  _initializeUser() async {
    await GeneralHelper.getUserFromPreferences().then((value) {
      _getAttendanceList("${value?.idKaryawan}");
      _idKaryawan = "${value?.idKaryawan}";

      setState(() {
        if (value != null) {
          String _nameTmp = value.nama;
          if (_nameTmp.length > 20) {
            List<String> _nameArr = _nameTmp.split(" ");
            if (_nameArr.length > 1) _name = "${_nameArr[0]} ${_nameArr[1]}";
            else _name = _nameArr[0];
          } else {
            _name = _nameTmp;
          }
        }
      });

    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ResponsiveText(
                  "Presensi",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                ResponsiveText(
                  _dateNowStr,
                  textAlign: TextAlign.start,
                  style: TextStyle(
                      color: CustomColor.gray500,
                      fontWeight: FontWeight.w600,
                      fontSize: 16
                  ),
                )
              ],
            ),
            Container(
                width: MediaQuery.of(context).size.width * 0.48,
                child: CustomMiniButton(
                  padding: EdgeInsets.all(12),
                  borderRadius: 100,
                  child: Row(
                    children: [
                      ResponsiveImage("assets/icons/pin.png",
                        width: 16,
                        height: 16,
                      ),
                      SizedBox(width: 6,),
                      LocationWidget(
                        widgetType: WidgetType.addressCard,
                        controller: locationWidgetController,
                      )
                    ],
                  ),
                  onClickWithContext: (thisContext) {
                    showPopover(
                        width: MediaQuery.of(context).size.width * 0.75,
                        height: 220,
                        direction: PopoverDirection.bottom,
                        context: thisContext,
                        bodyBuilder: (thisContext) => LocationWidget(
                          widgetType: WidgetType.overlay,
                          initialLocationStr: locationWidgetController.getLocationStr(),
                          initialAccuracyStr: locationWidgetController.getAccuracyStr(),
                          initialDistanceStr: locationWidgetController.getDistanceStr(),
                          initialCurrentAddress: locationWidgetController.getCurrentAddressStr(),
                          initialIsMockLocation: locationWidgetController.getIsMockLocation(),
                        )
                    );
                  },
                )
            ),
          ],
        ),
        SizedBox(height: 36,),

        Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              child: CustomCard(
                padding: EdgeInsets.all(0),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.all(Radius.circular(16)),
                    onTap: () {
                      _openSlideUp("IN");
                    },
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              ResponsiveImage("assets/icons/att_in.png", width: 42, height: 42,),
                              SizedBox(width: 8,),
                              Flexible(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ResponsiveText(
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                      "Presensi Masuk",
                                      style: TextStyle(
                                          color: CustomColor.gray700,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 16,
                                          height: 1.1
                                      ),
                                    ),
                                    SizedBox(height: 3,),
                                    Row(
                                      children: [
                                        ResponsiveImage("assets/icons/pin_blue.png", width: 16, height: 16,),
                                        SizedBox(width: 2,),
                                        Flexible(
                                          child: ResponsiveText(
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
                                            _isLoading ? "-" : _attendanceList.isNotEmpty ? _attendanceList[0].locationIn ?? "-" : "-",
                                            style: TextStyle(
                                                color: CustomColor.gray500,
                                                fontWeight: FontWeight.w500,
                                                fontSize: 13,
                                                height: 1.2
                                            ),
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                          SizedBox(height: 16,),
                          Container(
                            child: ResponsiveText(
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              _isLoading ? "00:00" : _attendanceList.isNotEmpty ? _attendanceList[0].masuk ?? "00:00" : "00:00",
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: _isLoading ?
                                  CustomColor.gray100  :
                                  _attendanceList.isNotEmpty && _attendanceList[0].masuk! == "00:00" ? CustomColor.gray100 : CustomColor.primary,
                                  fontSize: 48,
                                  height: 1
                              ),
                              textAlign: TextAlign.start,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(width: GeneralHelper.calculateSize(context, 24),),
            Expanded(
              child: CustomCard(
                padding: EdgeInsets.all(0),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.all(Radius.circular(16)),
                    onTap: () {
                      _openSlideUp("OUT");
                    },
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              ResponsiveImage("assets/icons/att_out.png", width: 42, height: 42,),
                              SizedBox(width: 8,),
                              Flexible(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ResponsiveText(
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                      "Presensi Pulang",
                                      style: TextStyle(
                                          color: CustomColor.gray700,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 16,
                                          height: 1.1
                                      ),
                                    ),
                                    SizedBox(height: 3,),
                                    Row(
                                      children: [
                                        ResponsiveImage("assets/icons/pin_blue.png", width: 16, height: 16,),
                                        SizedBox(width: 2,),
                                        Flexible(
                                          child: ResponsiveText(
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
                                            _isLoading ? "-" : _attendanceList.isNotEmpty ? _attendanceList[0].locationOut ?? "-" : "-",
                                            style: TextStyle(
                                                color: CustomColor.gray500,
                                                fontWeight: FontWeight.w500,
                                                fontSize: 13,
                                                height: 1.2
                                            ),
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                          SizedBox(height: 16,),
                          Container(
                            child: ResponsiveText(
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              _isLoading ? "00:00" : _attendanceList.isNotEmpty ? _attendanceList[0].pulang ?? "00:00" : "00:00",
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: _isLoading ?
                                  CustomColor.gray100  :
                                  _attendanceList.isNotEmpty && _attendanceList[0].pulang! == "00:00" ? CustomColor.gray100 : CustomColor.primary,
                                  fontSize: 48,
                                  height: 1
                              ),
                              textAlign: TextAlign.start,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 36,),

        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ResponsiveText(
              "Riwayat Presensi",
              textAlign: TextAlign.start,
              style: TextStyle(
                  color: CustomColor.gray700,
                  fontWeight: FontWeight.w600,
                  fontSize: 20
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => ListMoreScreen(
                    idKaryawan: _idKaryawan,
                    title: "Riwayat Presensi",
                    listType: ListType.attendance,
                  ))
                );
              },
              child: ResponsiveText(
                "Lihat Semua",
                textAlign: TextAlign.start,
                style: TextStyle(
                    color: CustomColor.accentBlue,
                    fontWeight: FontWeight.w600,
                    fontSize: 18
                ),
              ),
            )
          ],
        ),
        SizedBox(height: 16,),

        // Loading
        AnimatedSize(
          duration: Duration(milliseconds: 200),
          child: _isLoading ? Container(
            margin: EdgeInsets.only(bottom: 24),
            child: CustomLoadingList("Memperbaharui riwayat..."),
          ) : Container(),
        ),

        if (_attendanceList.isNotEmpty)
          Expanded(
            child: RefreshIndicator(
              onRefresh: () => _getAttendanceList(_idKaryawan),
              color: CustomColor.primary,
              backgroundColor: Colors.white,
              child: ListView.builder(
                itemCount: _attendanceList.length,
                itemBuilder: (context, index) {
                  final attendance = _attendanceList[index];
                  return AttendanceItem(attendance: attendance);
                },
              ),
            ),
          ),
      ],
    );
  }

  Future<void> _getAttendanceList(String id) async {
    setState(() {
      _isLoading = true;
      _isError = false;
    });

    try {
      final _attList = await _attendanceController.resume(
          idKaryawan: id,
          bulan: ""
      );
      setState(() {
        _attendanceList = _attList;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isError = true;
        _isLoading = false;
      });
      CustomSnackBar.of(context).show(
          message: e.toString(),
          onTop: true,
          showCloseIcon: true,
          prefixIcon: e.toString().contains("koneksi") ? Icons.wifi : Icons.warning,
          backgroundColor: CustomColor.error
      );
    }
  }

  void _refreshData() {
    _getAttendanceList(_idKaryawan);
  }

  void _openSlideUp(String state) {
    if (locationWidgetController.getCurrentAddressStr()!.contains("Memuat lokasi")) {
      _showStillLoadDialog();
    } else if (locationWidgetController.getCurrentAddressStr()!.contains("Lokasi tidak ditemukan")) {
      _showUnknownDialog();
    } else {
      if (locationWidgetController.getCurrentAddressStr()!.contains("Kantor")) {
        if (widget.onClick != null) {
          widget.onClick!(state);
        }
      }
      else {
        if (GeneralHelper.isUseAlert) {
          QuickAlert.show(
              context: context,
              confirmBtnText: "Oke, Lanjutkan",
              type: QuickAlertType.warning,
              text: 'Anda berada di luar radius kantor',
              onConfirmBtnTap: () {
                Navigator.pop(context);
                if (widget.onClick != null) {
                  widget.onClick!(state);
                }
              }
          );
        } else {
          if (widget.onClick != null) {
            widget.onClick!(state);
          }
        }
      }
    }
  }

  void _showStillLoadDialog() {
    QuickAlert.show(
        context: context,
        confirmBtnText: "Oke",
        type: QuickAlertType.error,
        title: "Masih memuat lokasi",
        text: 'Harap tunggu sebentar, pastikan Anda terhubung dengan internet..',
    );
  }

  void _showUnknownDialog() {
    QuickAlert.show(
      context: context,
      confirmBtnText: "Oke",
      type: QuickAlertType.error,
      title: "Lokasi tidak ditemukan",
      text: 'Periksa kembali koneksi internet Anda..',
    );
  }
}

class AttendanceScreenController {
  _AttendanceScreenState? _state;

  void _attach(_AttendanceScreenState state) {
    _state = state;
  }

  void _detach() {
    _state = null;
  }

  void refreshData() {
    _state?._refreshData();
  }
}

