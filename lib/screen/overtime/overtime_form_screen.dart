import 'dart:convert';

import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:fgsdm/constant/custom_colors.dart';
import 'package:fgsdm/controller/leave.dart';
import 'package:fgsdm/controller/overtime.dart';
import 'package:fgsdm/model/leave.dart';
import 'package:fgsdm/model/master_leave.dart';
import 'package:fgsdm/model/overtime.dart';
import 'package:fgsdm/utils/general_helper.dart';
import 'package:fgsdm/widget/custom/custom_card.dart';
import 'package:fgsdm/widget/custom/custom_form_field.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../widget/custom/custom_button.dart';
import '../../widget/custom/custom_snackbar.dart';
import '../../widget/loading_dialog.dart';
import '../../widget/responsive/responsive_text.dart';

class OvertimeFormScreen extends StatefulWidget {
  final String idKaryawan;
  final Overtime? overtime;
  const OvertimeFormScreen({Key? key, required this.idKaryawan, this.overtime}) : super(key: key);

  @override
  State<OvertimeFormScreen> createState() => _OvertimeFormScreenState();
}

class _OvertimeFormScreenState extends State<OvertimeFormScreen> {
  TextEditingController _startOvertime = TextEditingController();
  TextEditingController _endOvertime = TextEditingController();
  TextEditingController _restDuration = TextEditingController();
  TextEditingController _description = TextEditingController();

  OvertimeController _overtimeController = OvertimeController();

  List<DateTime?> _startDates = [];
  List<DateTime?> _endDates = [];
  Widget _startOvertimeBottomView = Container();
  Widget _endOvertimeBottomView = Container();

  TimeOfDay _startTime = TimeOfDay(hour: 00, minute: 00);
  TimeOfDay _endTime = TimeOfDay(hour: 00, minute: 00);

  @override
  void initState() {
    super.initState();

    if (widget.overtime != null) {
      DateTime startDate = DateTime.parse(widget.overtime!.waktu_mulai!);
      DateTime endDate = DateTime.parse(widget.overtime!.waktu_selesai!);
      _startDates.add(startDate);
      _endDates.add(endDate);
      _startTime = _parseTimeOfDay(widget.overtime!.waktu_mulai!);
      _endTime = _parseTimeOfDay(widget.overtime!.waktu_selesai!);

      _startOvertime.text = GeneralHelper.convertDateTime(widget.overtime!.waktu_mulai!);
      _endOvertime.text = GeneralHelper.convertDateTime(widget.overtime!.waktu_selesai!);
      _restDuration.text = widget.overtime!.durasi_istirahat!;
      _description.text = widget.overtime!.detail_pekerjaan!;
    }
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
                  "Form Pengajuan Lembur",
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
                          hint: "Mulai Lembur",
                          controller: _startOvertime,
                          prefixImage: "start",
                          borderRadius: BorderRadius.circular(16),
                          prefixMargin: 8,
                          type: TextInputType.none,
                          onTap: () {
                            setState(() {
                              _startOvertimeBottomView = _calendarStartLeave();
                              _endOvertimeBottomView = Container();
                            });
                          },
                          bottomView: _startOvertimeBottomView,
                        ),
                        SizedBox(height: 24,),

                        // SELESAI CUTI
                        CustomFormField(
                          backgroundColor: CustomColor.secondary,
                          hint: "Selesai Lembur",
                          controller: _endOvertime,
                          prefixImage: "finish",
                          borderRadius: BorderRadius.circular(16),
                          prefixMargin: 8,
                          type: TextInputType.none,
                          onTap: () {
                            setState(() {
                              _endOvertimeBottomView = _calendarEndLeave();
                              _startOvertimeBottomView = Container();
                            });
                          },
                          bottomView: AnimatedSize(
                            duration: Duration(milliseconds: 200),
                            child: _endOvertimeBottomView,
                          ),
                        ),
                        SizedBox(height: 24,),

                        // DURASI
                        CustomFormField(
                          backgroundColor: CustomColor.secondary,
                          hint: "Durasi Istirahat (Dalam Menit)",
                          controller: _restDuration,
                          prefixImage: "time",
                          borderRadius: BorderRadius.circular(16),
                          prefixMargin: 8,
                          type: TextInputType.number,
                          onTap: () {
                            setState(() {
                              _startOvertimeBottomView = Container();
                              _endOvertimeBottomView = Container();
                            });
                          },
                          onTapOutside: () {
                            setState(() {
                              FocusScope.of(context).unfocus();
                            });
                          },
                        ),
                        SizedBox(height: 24,),

                        // ALASAN CUTI
                        CustomFormField(
                          backgroundColor: CustomColor.secondary,
                          hint: "Detail Pekerjaan",
                          controller: _description,
                          prefixImage: "pencil",
                          borderRadius: BorderRadius.circular(16),
                          prefixMargin: 8,
                          minLines: 1,
                          maxLines: 8,
                          type: TextInputType.multiline,
                          onTap: () {
                            setState(() {
                              _startOvertimeBottomView = Container();
                              _endOvertimeBottomView = Container();
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
    return Column(
      children: [
        CalendarDatePicker2(
        config: CalendarDatePicker2Config(),
          value: _startDates,
          onValueChanged: (dates) {
          _startDates = dates;
          _startOvertime.text = "${GeneralHelper.convertDate(dates[0].toString())} - ${_startTime.hour < 10 ? "0" : ""}${_startTime.hour}:${_startTime.minute < 10 ? "0" : ""}${_startTime.minute}";
          }
        ),
        SizedBox(height: 8,),
        CustomButton(
          onClick: () async {
            final TimeOfDay? time = await showTimePicker(
              context: context,
              initialTime: _startTime,
              initialEntryMode: TimePickerEntryMode.input
            );
            if (time != null) {
              setState(() {
                _startTime = time;
              });
              _startOvertime.text = "${GeneralHelper.convertDate(_startDates[0].toString())} - ${_startTime.hour < 10 ? "0" : ""}${_startTime.hour}:${_startTime.minute < 10 ? "0" : ""}${_startTime.minute}";
            }
          },
          fontSize: 14,
          borderRadius: 16,
          text: "Pilih waktu",
        ),
        SizedBox(height: 8,),
      ],
    );
  }

  Widget _calendarEndLeave() {
    return Column(
      children: [
        CalendarDatePicker2(
            config: CalendarDatePicker2Config(),
            value: _endDates,
            onValueChanged: (dates) {
              _endDates = dates;
              _endOvertime.text = "${GeneralHelper.convertDate(dates[0].toString())} - ${_endTime.hour < 10 ? "0" : ""}${_endTime.hour}:${_endTime.minute < 10 ? "0" : ""}${_endTime.minute}";;
            }
        ),
        SizedBox(height: 8,),
        CustomButton(
          onClick: () async {
            final TimeOfDay? time = await showTimePicker(
                context: context,
                initialTime: _endTime,
                initialEntryMode: TimePickerEntryMode.input
            );
            if (time != null) {
              setState(() {
                _endTime = time;
              });
              _endOvertime.text = "${GeneralHelper.convertDate(_endDates[0].toString())} - ${_endTime.hour < 10 ? "0" : ""}${_endTime.hour}:${_endTime.minute < 10 ? "0" : ""}${_endTime.minute}";
            }
          },
          fontSize: 14,
          borderRadius: 16,
          text: "Pilih waktu",
        ),
        SizedBox(height: 8,),
      ],
    );
  }

  _sendData() async {
    setState(() {
      _startOvertimeBottomView = Container();
      _endOvertimeBottomView = Container();
    });

    if (_startOvertime.text.isNotEmpty && _endOvertime.text.isNotEmpty &&
        _restDuration.text.isNotEmpty && _description.text.isNotEmpty) {
      LoadingDialog.of(context).show(message: "Tunggu Sebentar...", isDismissible: true);

      try {
        String startDate = "${GeneralHelper.convertDate(_startDates[0].toString(), format: "dd/MM/yyyy")} ${_startTime.hour < 10 ? "0" : ""}${_startTime.hour}:${_startTime.minute < 10 ? "0" : ""}${_startTime.minute}";
        String endDate = "${GeneralHelper.convertDate(_endDates[0].toString(), format: "dd/MM/yyyy")} ${_endTime.hour < 10 ? "0" : ""}${_endTime.hour}:${_endTime.minute < 10 ? "0" : ""}${_endTime.minute}";

        print("startDate: " + startDate);
        print("endDate: " + endDate);
        print("rest duration: " + _restDuration.text);
        print("desc: " + _description.text);
        // String message = "Berhasil";
        // await Future.delayed(Duration(seconds: 2));

        String message = await _overtimeController.add(
          id: widget.overtime != null ? widget.overtime?.id : null,
          id_karyawan: widget.idKaryawan,
          waktu_mulai: startDate,
          waktu_selesai: endDate,
          durasi_istirahat: _restDuration.text,
          detail_pekerjaan: _description.text,
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

  TimeOfDay _parseTimeOfDay(String dateTimeString) {
    String timePart = dateTimeString.split(' ')[1];

    List<String> timeComponents = timePart.split(':');
    int hour = int.parse(timeComponents[0]);
    int minute = int.parse(timeComponents[1]);

    return TimeOfDay(hour: hour, minute: minute);
  }
}
