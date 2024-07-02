import 'package:fgsdm/controller/leave.dart';
import 'package:fgsdm/model/master_leave.dart';
import 'package:fgsdm/model/overtime.dart';
import 'package:fgsdm/utils/general_helper.dart';
import 'package:fgsdm/widget/custom/custom_card.dart';
import 'package:fgsdm/widget/responsive/responsive_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

import '../constant/custom_colors.dart';
import '../model/leave.dart';
import '../widget/responsive/responsive_text.dart';
import 'leave/leave_form_screen.dart';
import 'overtime/overtime_form_screen.dart';

class DetailScreen extends StatefulWidget {
  final String title;
  final bool canEdit;
  final Leave? leave;
  final Overtime? overtime;
  final String? idKaryawan;
  const DetailScreen({Key? key, required this.title, this.leave, required this.canEdit, this.overtime, this.idKaryawan}) : super(key: key);

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  String _leaveType = "Memuat..";

  @override
  void initState() {
    super.initState();

    if (widget.leave != null) _getLeaveType(widget.leave!.id_jenis_cuti!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColor.secondary,
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.all(24),
          child: Column(
            children: [
              Row(
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: ResponsiveIcon(Icons.arrow_back, color: Colors.black, size: 28),
                  ),
                  SizedBox(width: 16,),
                  Expanded(
                    child: ResponsiveText(
                      widget.title,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  SizedBox(width: 16,),
                  if (widget.canEdit) InkWell(
                    onTap: () {
                      if (widget.leave != null) {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => LeaveFormScreen(
                            idKaryawan: widget.leave!.id_karyawan!,
                            leave: widget.leave,
                            selectedType: _leaveType,
                          ))
                        ).then((onValue) {
                          if (onValue != null)
                            if (onValue) {
                              Navigator.of(context).pushReplacement(
                                MaterialPageRoute(builder: (builder) => DetailScreen(
                                  title: widget.title,
                                  canEdit: widget.canEdit,
                                  leave: widget.leave,
                                  idKaryawan: widget.idKaryawan,
                                ))
                              );
                            }
                        });
                      }
                      else if (widget.overtime != null) {
                        Navigator.of(context).push(
                            MaterialPageRoute(builder: (context) => OvertimeFormScreen(idKaryawan: widget.idKaryawan!, overtime: widget.overtime,))
                        ).then((onValue) {
                          if (onValue != null)
                            if (onValue) {
                              Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(builder: (builder) => DetailScreen(
                                    title: widget.title,
                                    canEdit: widget.canEdit,
                                    overtime: widget.overtime,
                                    idKaryawan: widget.idKaryawan,
                                  ))
                              );
                            }
                        });
                      }
                    },
                    child: ResponsiveIcon(Icons.edit, color: Colors.black, size: 28),
                  ),
                ],
              ),
              SizedBox(height: 24,),

              if (widget.leave != null) 
                CustomCard(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        // TOP
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ResponsiveText(
                              "Cuti ${widget.leave?.durasi} Hari",
                              style: TextStyle(fontWeight: FontWeight.w600, color: Colors.black, fontSize: 18),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                            SizedBox(width: 16,),
                            Container(
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color: widget.leave?.status! == "Disetujui" ? CustomColor.success.withOpacity(0.25)
                                      : widget.leave?.status! == "Ditolak" ? CustomColor.error.withOpacity(0.25)
                                      : CustomColor.warn.withOpacity(0.25)
                              ),
                              child: ResponsiveText(
                                widget.leave!.status!,
                                style: TextStyle(
                                  fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    color: widget.leave?.status! == "Disetujui" ? CustomColor.success
                                        : widget.leave?.status! == "Ditolak" ? CustomColor.error
                                        : CustomColor.warn
                                ),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 24,),

                        // TANGGAL MULAI
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ResponsiveText(
                              "Tanggal Mulai",
                              style: TextStyle(fontWeight: FontWeight.w500, color: Colors.black, fontSize: 17),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                            SizedBox(width: 16,),
                            Flexible(
                              fit: FlexFit.loose,
                              child: ResponsiveText(
                                GeneralHelper.convertDate(widget.leave!.tgl_mulai!),
                                style: TextStyle(fontWeight: FontWeight.w600, color: Colors.black, fontSize: 17),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                            ),
                          ],
                        ),

                        // TANGGAL SELESAI
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ResponsiveText(
                              "Tanggal Selesai",
                              style: TextStyle(fontWeight: FontWeight.w500, color: Colors.black, fontSize: 17),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                            SizedBox(width: 16,),
                            Flexible(
                              fit: FlexFit.loose,
                              child: ResponsiveText(
                                GeneralHelper.convertDate(widget.leave!.tgl_selesai!),
                                style: TextStyle(fontWeight: FontWeight.w600, color: Colors.black, fontSize: 17),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                            ),
                          ],
                        ),

                        // JENIS CUTI
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ResponsiveText(
                              "Jenis Cuti",
                              style: TextStyle(fontWeight: FontWeight.w500, color: Colors.black, fontSize: 17),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                            SizedBox(width: 16,),
                            Flexible(
                              fit: FlexFit.loose,
                              child: ResponsiveText(
                                _leaveType,
                                style: TextStyle(fontWeight: FontWeight.w600, color: Colors.black, fontSize: 17),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 16,),

                        // NAMA LENGKAP
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ResponsiveText(
                              "Nama Lengkap",
                              style: TextStyle(fontWeight: FontWeight.w500, color: Colors.black, fontSize: 17),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                            SizedBox(width: 16,),
                            Flexible(
                              fit: FlexFit.loose,
                              child: ResponsiveText(
                                widget.leave!.nama!,
                                style: TextStyle(fontWeight: FontWeight.w600, color: Colors.black, fontSize: 17),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                            ),
                          ],
                        ),

                        // TANGGAL INPUT
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ResponsiveText(
                              "Tanggal Input",
                              style: TextStyle(fontWeight: FontWeight.w500, color: Colors.black, fontSize: 17),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                            SizedBox(width: 16,),
                            Flexible(
                              fit: FlexFit.loose,
                              child: ResponsiveText(
                                "${GeneralHelper.convertDateTime(widget.leave!.waktu_input!)}",
                                style: TextStyle(fontWeight: FontWeight.w600, color: Colors.black, fontSize: 17),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 16,),

                        // KARYAWAN PENGGANTI
                        if (widget.leave!.karyawan_pengganti != null) Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ResponsiveText(
                              "Karyawan Pengganti",
                              style: TextStyle(fontWeight: FontWeight.w500, color: Colors.black, fontSize: 17),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                            SizedBox(width: 16,),
                            Flexible(
                              fit: FlexFit.loose,
                              child: ResponsiveText(
                                widget.leave!.karyawan_pengganti!,
                                style: TextStyle(fontWeight: FontWeight.w600, color: Colors.black, fontSize: 17),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                            ),
                          ],
                        ),

                        // NAMA APPROVAL
                        if (widget.leave!.nama_approval != null) Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ResponsiveText(
                              "Approval",
                              style: TextStyle(fontWeight: FontWeight.w500, color: Colors.black, fontSize: 17),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                            SizedBox(width: 16,),
                            Flexible(
                              fit: FlexFit.loose,
                              child: ResponsiveText(
                                widget.leave!.nama_approval!,
                                style: TextStyle(fontWeight: FontWeight.w600, color: Colors.black, fontSize: 17),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                            ),
                          ],
                        ),

                        // WAKTU APPROVAL
                        if (widget.leave!.waktu_approval != null) Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ResponsiveText(
                              "Waktu Approval",
                              style: TextStyle(fontWeight: FontWeight.w500, color: Colors.black, fontSize: 17),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                            SizedBox(width: 16,),
                            Flexible(
                              fit: FlexFit.loose,
                              child: ResponsiveText(
                                "${GeneralHelper.convertDateTime(widget.leave!.waktu_approval!)}",
                                style: TextStyle(fontWeight: FontWeight.w600, color: Colors.black, fontSize: 17),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 16,),

                        // KETERANGAN
                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(width: 1, color: CustomColor.gray200)
                          ),
                          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ResponsiveText(
                                "Keterangan Cuti",
                                style: TextStyle(fontWeight: FontWeight.w500, color: Colors.black, fontSize: 16),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                              SizedBox(height: 12,),
                              ResponsiveText(
                                widget.leave!.keterangan!,
                                style: TextStyle(fontWeight: FontWeight.w600, color: Colors.black, fontSize: 17),
                              ),
                            ],
                          ),
                        ),

                        SizedBox(height: 16,),

                        // KETERANGAN
                        if (widget.leave!.catatan != null) Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(width: 1, color: CustomColor.gray200)
                          ),
                          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ResponsiveText(
                                "Catatan",
                                style: TextStyle(fontWeight: FontWeight.w500, color: Colors.black, fontSize: 16),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                              SizedBox(height: 12,),
                              ResponsiveText(
                                widget.leave!.catatan!.isNotEmpty ? widget.leave!.catatan! : "Tidak ada catatan",
                                style: TextStyle(fontWeight: FontWeight.w600, color: Colors.black, fontSize: 17),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  )
                ),

              if (widget.overtime != null)
                CustomCard(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          // TOP
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              ResponsiveText(
                                widget.overtime!.total_durasi_lembur != null
                                  ? "Lembur${_convertMinutesToHours(int.parse(widget.overtime!.total_durasi_lembur!))}"
                                  : "Lembur${_getTimeDifference(widget.overtime!.waktu_mulai!, widget.overtime!.waktu_selesai!, widget.overtime!.durasi_istirahat!)}",
                                style: TextStyle(fontWeight: FontWeight.w600, color: Colors.black, fontSize: 18),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                              SizedBox(width: 16,),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  if (widget.overtime?.status_approval_spv == null || widget.overtime?.status_approval_direksi != null) Container(
                                    padding: EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      color: widget.overtime?.status_approval_direksi == null
                                          ? CustomColor.warn.withOpacity(0.25)
                                          : widget.overtime?.status_approval_direksi == "Ditolak"
                                          ? CustomColor.error.withOpacity(0.25)
                                          : CustomColor.success.withOpacity(0.25),
                                    ),
                                    child: ResponsiveText(
                                      widget.overtime?.status_approval_direksi != null ? "${widget.overtime!.status_approval_direksi!} Direksi" : "Pengajuan",
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        color: widget.overtime?.status_approval_direksi == null
                                            ? CustomColor.warn
                                            : widget.overtime?.status_approval_direksi == "Ditolak"
                                            ? CustomColor.error
                                            : CustomColor.success,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                    ),
                                  ),
                                  SizedBox(width: 8),
                                  if (widget.overtime?.status_approval_spv != null) Container(
                                    padding: EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      color: widget.overtime?.status_approval_spv == null
                                          ? CustomColor.warn.withOpacity(0.25)
                                          : widget.overtime?.status_approval_spv == "Ditolak"
                                          ? CustomColor.error.withOpacity(0.25)
                                          : CustomColor.success.withOpacity(0.25),
                                    ),
                                    child: ResponsiveText(
                                      widget.overtime?.status_approval_spv != null ? "${widget.overtime?.status_approval_spv} Manager" : "Pengajuan",
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        color: widget.overtime?.status_approval_spv == null
                                            ? CustomColor.warn
                                            : widget.overtime?.status_approval_spv! == "Ditolak"
                                            ? CustomColor.error
                                            : CustomColor.success,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                    ),
                                  ),
                                ],
                              )

                            ],
                          ),
                          SizedBox(height: 24,),

                          // TANGGAL MULAI
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              ResponsiveText(
                                "Waktu Mulai",
                                style: TextStyle(fontWeight: FontWeight.w500, color: Colors.black, fontSize: 17),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                              SizedBox(width: 16,),
                              Flexible(
                                fit: FlexFit.loose,
                                child: ResponsiveText(
                                  GeneralHelper.convertDateTime(widget.overtime!.waktu_mulai!),
                                  style: TextStyle(fontWeight: FontWeight.w600, color: Colors.black, fontSize: 17),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                              ),
                            ],
                          ),

                          // TANGGAL SELESAI
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              ResponsiveText(
                                "Waktu Selesai",
                                style: TextStyle(fontWeight: FontWeight.w500, color: Colors.black, fontSize: 17),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                              SizedBox(width: 16,),
                              Flexible(
                                fit: FlexFit.loose,
                                child: ResponsiveText(
                                  GeneralHelper.convertDateTime(widget.overtime!.waktu_selesai!),
                                  style: TextStyle(fontWeight: FontWeight.w600, color: Colors.black, fontSize: 17),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                              ),
                            ],
                          ),

                          // ISTIRAHAT
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              ResponsiveText(
                                "Durasi Istirahat",
                                style: TextStyle(fontWeight: FontWeight.w500, color: Colors.black, fontSize: 17),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                              SizedBox(width: 16,),
                              Flexible(
                                fit: FlexFit.loose,
                                child: ResponsiveText(
                                  "${_convertMinutesToHours(int.parse(widget.overtime!.durasi_istirahat!))}",
                                  style: TextStyle(fontWeight: FontWeight.w600, color: Colors.black, fontSize: 17),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 16,),

                          // NAMA LENGKAP
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              ResponsiveText(
                                "Nama Lengkap",
                                style: TextStyle(fontWeight: FontWeight.w500, color: Colors.black, fontSize: 17),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                              SizedBox(width: 16,),
                              Flexible(
                                fit: FlexFit.loose,
                                child: ResponsiveText(
                                  widget.overtime!.nama!,
                                  style: TextStyle(fontWeight: FontWeight.w600, color: Colors.black, fontSize: 17),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                              ),
                            ],
                          ),

                          // TANGGAL INPUT
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              ResponsiveText(
                                "Tanggal Input",
                                style: TextStyle(fontWeight: FontWeight.w500, color: Colors.black, fontSize: 17),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                              SizedBox(width: 16,),
                              Flexible(
                                fit: FlexFit.loose,
                                child: ResponsiveText(
                                  widget.overtime!.waktu_input != null ? "${GeneralHelper.convertDateTime(widget.overtime!.waktu_input!)}" : "-",
                                  style: TextStyle(fontWeight: FontWeight.w600, color: Colors.black, fontSize: 17),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 16,),

                          // WAKTU APPROVAL DIREKSI
                          if (widget.overtime!.waktu_approval_spv != null) Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              ResponsiveText(
                                "Waktu Approval Manager",
                                style: TextStyle(fontWeight: FontWeight.w500, color: Colors.black, fontSize: 17),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                              SizedBox(width: 16,),
                              Flexible(
                                fit: FlexFit.loose,
                                child: ResponsiveText(
                                  widget.overtime!.waktu_approval_spv != null ? "${GeneralHelper.convertDateTime(widget.overtime!.waktu_approval_spv!)}" : "-",
                                  style: TextStyle(fontWeight: FontWeight.w600, color: Colors.black, fontSize: 17),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                              ),
                            ],
                          ),

                          // WAKTU APPROVAL
                          if (widget.overtime!.waktu_approval_direksi != null) Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              ResponsiveText(
                                "Waktu Approval Direksi",
                                style: TextStyle(fontWeight: FontWeight.w500, color: Colors.black, fontSize: 17),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                              SizedBox(width: 16,),
                              Flexible(
                                fit: FlexFit.loose,
                                child: ResponsiveText(
                                  "${GeneralHelper.convertDateTime(widget.overtime!.waktu_approval_direksi!)}",
                                  style: TextStyle(fontWeight: FontWeight.w600, color: Colors.black, fontSize: 17),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 16,),

                          // KETERANGAN
                          Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(width: 1, color: CustomColor.gray200)
                            ),
                            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ResponsiveText(
                                  "Keterangan Lembur",
                                  style: TextStyle(fontWeight: FontWeight.w500, color: Colors.black, fontSize: 16),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                                SizedBox(height: 12,),
                                HtmlWidget(
                                  widget.overtime!.detail_pekerjaan!,
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    )
                )
            ],
          ),
        ),
      ),
    );
  }

  _getLeaveType(String type) async {
    List<MasterLeaveType> list = GeneralHelper.listMasterLeaveType;

    if (list.length > 0) {
      _changeMasterType(list, type);
    } else {
      try {
        LeaveController _leaveController = LeaveController();
        list = await _leaveController.master();
        _changeMasterType(list, type);
      } catch (e) {
        setState(() {
          _leaveType = "Tidak diketahui";
        });
      }
    }
  }

  _changeMasterType(List<MasterLeaveType> list, String type) {
    for (MasterLeaveType master in list) {
      if (master.id == type) {
        setState(() {
          _leaveType = master.nama!;
        });
        break;
      }
    }
  }

  String _convertMinutesToHours(int minutes) {
    final int hours = minutes ~/ 60;
    final int remainingMinutes = minutes % 60;

    return '${hours > 0 ? " ${hours} jam" : ""}${remainingMinutes > 0 ? " ${remainingMinutes.toString()} menit" : ""}';
  }

  _getTimeDifference(String startTime, String endTime, String rest) {
    DateTime start = DateTime.parse(startTime);
    DateTime end = DateTime.parse(endTime);

    Duration duration = end.difference(start);
    Duration durationAfter = duration - Duration(minutes: int.parse(rest));

    int hours = durationAfter.inHours;
    int remainingMinutes = durationAfter.inMinutes.remainder(60);

    return '${hours > 0 ? " ${hours} jam" : ""}${remainingMinutes > 0 ? " ${remainingMinutes.toString()} menit" : ""}';
  }
}
