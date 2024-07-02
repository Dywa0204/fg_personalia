import 'dart:convert';

import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:fgsdm/constant/custom_colors.dart';
import 'package:fgsdm/controller/leave.dart';
import 'package:fgsdm/model/leave.dart';
import 'package:fgsdm/model/master_leave.dart';
import 'package:fgsdm/utils/general_helper.dart';
import 'package:fgsdm/widget/custom/custom_card.dart';
import 'package:fgsdm/widget/custom/custom_form_field.dart';
import 'package:fgsdm/widget/responsive/responsive_container.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../widget/custom/custom_button.dart';
import '../../widget/custom/custom_snackbar.dart';
import '../../widget/loading_dialog.dart';
import '../../widget/responsive/responsive_image.dart';
import '../../widget/responsive/responsive_text.dart';

class LeaveFormScreen extends StatefulWidget {
  final String idKaryawan;
  final Leave? leave;
  final String? selectedType;
  const LeaveFormScreen({Key? key, required this.idKaryawan, this.leave, this.selectedType}) : super(key: key);

  @override
  State<LeaveFormScreen> createState() => _LeaveFormScreenState();
}

class _LeaveFormScreenState extends State<LeaveFormScreen> {
  TextEditingController _leaveType = TextEditingController();
  TextEditingController _startLeave = TextEditingController();
  TextEditingController _endLeave = TextEditingController();
  TextEditingController _cause = TextEditingController();
  TextEditingController _duration = TextEditingController();

  LeaveController _leaveController = LeaveController();
  List<String> _leaveTypeMasterStr = [];
  List<MasterLeaveType> _leaveTypeMaster = [];
  String _masterHint = "";
  String? _selectedType;

  List<DateTime?> _startDates = [];
  List<DateTime?> _endDates = [];
  Widget _startLeaveBottomView = Container();
  Widget _endLeaveBottomView = Container();

  Widget _durationHint = ResponsiveText(
    "Gunakan tanda titik (.) untuk pecahan koma",
    style: TextStyle(fontSize: 12, color: CustomColor.gray500),
  );

  @override
  void initState() {
    super.initState();

    print(widget.leave);
    if (widget.leave != null) {
      DateTime startDate = DateTime.parse(widget.leave!.tgl_mulai!);
      DateTime endDate = DateTime.parse(widget.leave!.tgl_selesai!);
      _startDates.add(startDate);
      _endDates.add(endDate);

      _startLeave.text = GeneralHelper.convertDate(widget.leave!.tgl_mulai!);
      _endLeave.text = GeneralHelper.convertDate(widget.leave!.tgl_selesai!);
      _duration.text = widget.leave!.durasi!;
      _cause.text = widget.leave!.keterangan!;
      _leaveType.text = widget.selectedType!;
    }

    _getMasterLeaveTypeFromPreferences();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColor.secondary,
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.all(24),
          child: CustomCard(
            padding: EdgeInsets.all(24),
            child: Column(
              children: [
                ResponsiveText(
                  "Form Pengajuan Cuti",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 32,),

                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [

                        // MULAI CUTI
                        CustomFormField(
                          backgroundColor: CustomColor.secondary,
                          hint: "Mulai Cuti",
                          controller: _startLeave,
                          prefixImage: "start",
                          borderRadius: BorderRadius.circular(16),
                          prefixMargin: 8,
                          type: TextInputType.none,
                          onTap: () {
                            setState(() {
                              _startLeaveBottomView = _calendarStartLeave();
                              _endLeaveBottomView = Container();
                            });
                          },
                          bottomView: _startLeaveBottomView,
                        ),
                        SizedBox(height: 24,),

                        // SELESAI CUTI
                        CustomFormField(
                          backgroundColor: CustomColor.secondary,
                          hint: "Selesai Cuti",
                          controller: _endLeave,
                          prefixImage: "finish",
                          borderRadius: BorderRadius.circular(16),
                          prefixMargin: 8,
                          type: TextInputType.none,
                          onTap: () {
                            setState(() {
                              _endLeaveBottomView = _calendarEndLeave();
                              _startLeaveBottomView = Container();
                            });
                          },
                          bottomView: AnimatedSize(
                            duration: Duration(milliseconds: 200),
                            child: _endLeaveBottomView,
                          ),
                        ),
                        SizedBox(height: 24,),

                        // DURASI
                        CustomFormField(
                          backgroundColor: CustomColor.secondary,
                          hint: "Durasi Cuti",
                          controller: _duration,
                          prefixImage: "time",
                          borderRadius: BorderRadius.circular(16),
                          prefixMargin: 8,
                          type: TextInputType.number,
                          onTap: () {
                            setState(() {
                              _startLeaveBottomView = Container();
                              _endLeaveBottomView = Container();
                            });
                          },
                          onChange: (value) {
                            _setDurationHint(double.parse(value) <= 0);
                          },
                          onTapOutside: () {
                            setState(() {
                              FocusScope.of(context).unfocus();
                            });
                          },
                          bottomView: _durationHint,
                        ),
                        SizedBox(height: 24,),

                        // JENIS CUTI
                        Container(
                          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(16)),
                            color: CustomColor.secondary,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ResponsiveContainer(
                                    margin: EdgeInsets.only(top: 6),
                                    width: 42,
                                    height: 42,
                                    child: ResponsiveImage("assets/icons/category.png"),
                                  ),
                                  Expanded(child: DropdownButtonFormField2<String>(
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.symmetric(vertical: 8),
                                      border: InputBorder.none,
                                      label: Container(
                                        padding: EdgeInsets.only(left: 22),
                                        child: ResponsiveText(
                                          'Jenis Cuti',
                                          style: TextStyle(
                                              color: CustomColor.gray500,
                                              fontWeight: FontWeight.w400
                                          ),
                                        ),
                                      ),
                                      // prefixIcon: ResponsiveContainer(
                                      //   margin: EdgeInsets.only(top: 4, bottom: 4, right: 4),
                                      //   width: 32,
                                      //   height: 32,
                                      //   child: ResponsiveImage("assets/icons/category.png"),
                                      // ),
                                      // Add more decoration..
                                    ),
                                    isExpanded: true,
                                    onMenuStateChange: (isOpen) {
                                      if (isOpen) {
                                        // _getMasterLeaveTypeList();
                                      }
                                    },
                                    value: _selectedType,
                                    items: _leaveTypeMasterStr.map((item) => DropdownMenuItem<String>(
                                      value: item,
                                      child: ResponsiveText(item, style: TextStyle(color: Colors.black),),
                                    )).toList(),
                                    onChanged: (value) {
                                      _leaveType.text = value!;
                                      MasterLeaveType? master = _getMasterLeaveType(value);
                                      setState(() {
                                        _masterHint = master != null ? master.keterangan! : "";
                                      });
                                    },
                                    buttonStyleData: ButtonStyleData(
                                      padding: EdgeInsets.only(right: 8),
                                    ),
                                    dropdownStyleData: DropdownStyleData(
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(16),
                                          color: Colors.white
                                      ),
                                    ),
                                    menuItemStyleData: MenuItemStyleData(
                                      padding: EdgeInsets.symmetric(horizontal: 16),
                                    ),
                                  )),
                                ],
                              ),
                              AnimatedSize(
                                duration: Duration(milliseconds: 200),
                                child: _masterHint.isNotEmpty ? ResponsiveText(
                                  _masterHint,
                                  style: TextStyle(fontSize: 12, color: CustomColor.gray500),
                                ) : Container(),
                              )
                            ],
                          ),
                        ),
                        SizedBox(height: 24,),

                        // ALASAN CUTI
                        CustomFormField(
                          backgroundColor: CustomColor.secondary,
                          hint: "Alasan Cuti",
                          controller: _cause,
                          prefixImage: "pencil",
                          borderRadius: BorderRadius.circular(16),
                          prefixMargin: 8,
                          minLines: 1,
                          maxLines: 8,
                          type: TextInputType.multiline,
                          onTap: () {
                            setState(() {
                              _startLeaveBottomView = Container();
                              _endLeaveBottomView = Container();
                            });
                          },
                          onTapOutside: () {
                            setState(() {
                              FocusScope.of(context).unfocus();
                            });
                          },
                        ),
                        SizedBox(height: 24,),
                      ],
                    ),
                  ),
                ),

                SizedBox(height: 24,),
                Row(
                  children: [
                    Expanded(
                      child: CustomButton(
                        onClick: () async {
                          Navigator.of(context).pop();
                        },
                        rippleColor: CustomColor.error.withOpacity(0.35),
                        iconSize: 32,
                        text: "Batal",
                        prefixImage: "cancel",
                        textColor: CustomColor.error,
                        color: CustomColor.error.withOpacity(0.25),
                        borderRadius: 16,
                        textAlign: TextAlign.start,
                      ),
                    ),
                    SizedBox(width: 20,),
                    Expanded(
                      child: CustomButton(
                        onClick: () {
                          _sendData();
                        },
                        rippleColor: CustomColor.success.withOpacity(0.35),
                        iconSize: 32,
                        text: "Kirim",
                        prefixImage: "send",
                        textColor: CustomColor.success,
                        color: CustomColor.success.withOpacity(0.25),
                        borderRadius: 16,
                        textAlign: TextAlign.start,
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _calendarStartLeave() {
    return CalendarDatePicker2(
        config: CalendarDatePicker2Config(),
        value: _startDates,
        onValueChanged: (dates) {
          _startDates = dates;
          _startLeave.text = GeneralHelper.convertDate(dates[0].toString());

          setState(() {
            if (_startDates.length > 0 && _endDates.length > 0) {
              int durationInDay = _calculateBusinessDays(_startDates[0]!, _endDates[0]!);
              if (durationInDay <= 0) {
                _duration.text = "";
                _setDurationHint(true);
              } else {
                _duration.text = durationInDay.toString();
                _setDurationHint(false);
              }
            }
          });
        }
    );
  }

  Widget _calendarEndLeave() {
    return CalendarDatePicker2(
        config: CalendarDatePicker2Config(),
        value: _endDates,
        onValueChanged: (dates) {
          _endDates = dates;
          _endLeave.text = GeneralHelper.convertDate(dates[0].toString());

          setState(() {
            if (_startDates.length > 0 && _endDates.length > 0) {
              int durationInDay = _calculateBusinessDays(_startDates[0]!, _endDates[0]!);
              if (durationInDay <= 0) {
                _duration.text = "";
                _setDurationHint(true);
              } else {
                _duration.text = durationInDay.toString();
                _setDurationHint(false);
              }
            }
          });
        }
    );
  }

  _getMasterLeaveTypeFromPreferences() async {
    _leaveTypeMaster = await GeneralHelper.listMasterLeaveType;
    if (_leaveTypeMaster.length > 0) {
      _leaveTypeMaster.forEach((item) {
        if (item.id!.isNotEmpty) _leaveTypeMasterStr.add(item.nama!);
      });
      if (widget.leave != null) {
        setState(() {
          _selectedType = widget.selectedType;
        });
      }
    } else {
      _getMasterLeaveTypeList();
    }
  }

  _getMasterLeaveTypeList() async {
    try {
      List<MasterLeaveType> list = await _leaveController.master();
      _leaveTypeMaster = list;
      _leaveTypeMasterStr = [];
      list.forEach((item) {
        if (item.id!.isNotEmpty) _leaveTypeMasterStr.add(item.nama!);
      });
      if (widget.leave != null) {
        setState(() {
          _selectedType = widget.selectedType;
        });
      }
    } catch(e) {
      _leaveTypeMaster = GeneralHelper.listMasterLeaveType;
      if (_leaveTypeMaster.length > 0) {
        _leaveTypeMaster.forEach((item) {
          if (item.id!.isNotEmpty) _leaveTypeMasterStr.add(item.nama!);
        });
        if (widget.leave != null) {
          setState(() {
            _selectedType = widget.selectedType;
          });
        }
      } else {
        SharedPreferences preferences = await SharedPreferences.getInstance();
        String master = preferences.getString("masterLeaveType") ?? "";
        if (master.isNotEmpty) {
          final Map<String, dynamic> masterJson = jsonDecode(master);
          final List<dynamic> masterList = masterJson['data'];
          _leaveTypeMaster = masterList.map((att) => MasterLeaveType.fromJson(att)).toList();
          if (widget.leave != null) {
            setState(() {
              _selectedType = widget.selectedType;
            });
          }
        } else {
          _leaveTypeMaster = [];
        }
      }
    }
  }

  _setDurationHint(bool isWarn) {
    setState(() {
      if (isWarn) {
        _durationHint = ResponsiveText(
          "Durasi cuti harus lebih besar dari 0, cek kembali tanggal yang diinputkan",
          style: TextStyle(fontSize: 12, color: CustomColor.error),
        );
      } else {
        _durationHint = ResponsiveText(
          "Gunakan tanda titik (.) untuk pecahan koma",
          style: TextStyle(fontSize: 12, color: CustomColor.gray500),
        );
      }
    });
  }

  MasterLeaveType? _getMasterLeaveType(String type) {
    for (MasterLeaveType master in _leaveTypeMaster) {
      if (master.nama == type) {
        return master;
      }
    }
    return null;
  }

  _sendData() async {
    setState(() {
      _endLeaveBottomView = Container();
      _startLeaveBottomView = Container();
    });

    String leaveType = _getMasterLeaveType(_leaveType.text)?.id ?? "";

    if (_startLeave.text.isNotEmpty && _endLeave.text.isNotEmpty && _duration.text.isNotEmpty &&
        leaveType.isNotEmpty && _cause.text.isNotEmpty) {
      LoadingDialog.of(context).show(message: "Tunggu Sebentar...", isDismissible: true);

      try {
        String startDate = GeneralHelper.convertDate(_startDates[0].toString(), format: "dd/MM/yyyy");
        String endDate = GeneralHelper.convertDate(_endDates[0].toString(), format: "dd/MM/yyyy");

        print("startDate: " + startDate);
        print("endDate: " + endDate);
        print("duration: " + _duration.text);
        print("leaveType: " + leaveType);
        print("cause: " + _cause.text);
        // String message = "Berhasil";
        // await Future.delayed(Duration(seconds: 2));

        String message = await _leaveController.add(
          id: widget.leave != null ? widget.leave?.id : null,
          id_karyawan: widget.idKaryawan,
          tanggal_mulai: startDate,
          tanggal_selesai: endDate,
          durasi: _duration.text,
          alasan_cuti: _cause.text,
          jenis_cuti: leaveType
        );

        LoadingDialog.of(context).hide();

        CustomSnackBar.of(context).show(
            duration: Duration(seconds: 6),
            message: message,
            onTop: true,
            showCloseIcon: true,
            prefixIcon: message.contains("Berhasil") ? Icons.check : Icons.warning,
            backgroundColor: message.contains("Berhasil") ? CustomColor.success : CustomColor.error
        );

        if (message.contains("Berhasil")) {
          Navigator.of(context).pop(true);
        }
      } catch (e) {
        LoadingDialog.of(context).hide();
        CustomSnackBar.of(context).show(
            message: e.toString(),
            onTop: true,
            showCloseIcon: true,
            prefixIcon: Icons.warning,
            backgroundColor: CustomColor.error
        );
      }
    } else {
      CustomSnackBar.of(context).show(
          message: "Harap isi semua kolom",
          onTop: true,
          showCloseIcon: true,
          prefixIcon: Icons.warning,
          backgroundColor: CustomColor.error
      );
    }
  }

  int _calculateBusinessDays(DateTime start, DateTime end) {
    int businessDays = 0;
    DateTime currentDate = start;

    while (currentDate.isBefore(end) || currentDate.isAtSameMomentAs(end)) {
      if (currentDate.weekday != DateTime.saturday && currentDate.weekday != DateTime.sunday) {
        businessDays++;
      }
      currentDate = currentDate.add(Duration(days: 1));
    }

    return businessDays;
  }
}
