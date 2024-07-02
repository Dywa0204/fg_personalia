import 'package:fgsdm/constant/custom_colors.dart';
import 'package:fgsdm/controller/leave.dart';
import 'package:fgsdm/controller/overtime.dart';
import 'package:fgsdm/model/overtime.dart';
import 'package:fgsdm/screen/detail_screen.dart';
import 'package:fgsdm/screen/leave/leave_form_screen.dart';
import 'package:fgsdm/screen/overtime/overtime_form_screen.dart';
import 'package:fgsdm/utils/general_helper.dart';
import 'package:fgsdm/widget/custom/custom_card.dart';
import 'package:fgsdm/widget/list_item/leave_item.dart';
import 'package:fgsdm/widget/list_item/overtime_item.dart';
import 'package:flutter/material.dart';
import '../../model/leave.dart';
import '../../model/user.dart';
import '../../widget/custom/custom_loading_list.dart';
import '../../widget/custom/custom_mini_button.dart';
import '../../widget/custom/custom_snackbar.dart';
import '../../widget/responsive/responsive_icon.dart';
import '../../widget/responsive/responsive_text.dart';
import '../list_more_screen.dart';

class OvertimeScreen extends StatefulWidget {
  const OvertimeScreen({Key? key}) : super(key: key);

  @override
  State<OvertimeScreen> createState() => _OvertimeScreenState();
}

class _OvertimeScreenState extends State<OvertimeScreen> {
  User? _user = null;
  List<Overtime> _overtimeList = [];
  OvertimeController _overtimeController = OvertimeController();
  bool _isLoading = true;
  String _idKaryawan = "";

  @override
  void initState() {
    super.initState();

    _initializeUser();
  }

  _initializeUser() async {
    await GeneralHelper.getUserFromPreferences().then((user) async {
      _getOvertime("${user?.idKaryawan}");
      _idKaryawan = "${user?.idKaryawan}";

      setState(() {
        _user = user!;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ResponsiveText(
                "Pengajuan Lembur",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                ),
              ),
              CustomMiniButton(
                onClick: () {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => OvertimeFormScreen(idKaryawan: _idKaryawan))
                  ).then((onValue) {
                    if (onValue != null)
                      if (onValue) _getOvertime(_idKaryawan);
                  });
                },
                color: CustomColor.success.withOpacity(0.3),
                rippleColor: CustomColor.success.withOpacity(0.4),
                borderRadius: 12,
                padding: EdgeInsets.all(12),
                child: Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(4),
                      margin: EdgeInsets.only(right: 10),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: CustomColor.success
                      ),
                      child: ResponsiveIcon(Icons.add, color: Colors.white, size: 24,),
                    ),
                    ResponsiveText(
                      "Ajukan",
                      style: TextStyle(
                        color: CustomColor.success,
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),

          SizedBox(height: 24,),

          CustomCard(
            child: Container(
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Flexible(
                            fit: FlexFit.loose,
                            child: ResponsiveText(
                              "Nama Lengkap",
                              style: TextStyle(fontWeight: FontWeight.w500, color: CustomColor.gray500),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ),
                          Flexible(
                            fit: FlexFit.loose,
                            child: ResponsiveText(
                              _user != null ? _user!.nama : "Napoleon Bonaparte",
                              style: TextStyle(fontWeight: FontWeight.w700, color: Colors.black, fontSize: 17),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ),
                          SizedBox(height: 12,),
                          Flexible(
                            fit: FlexFit.loose,
                            child: ResponsiveText(
                              "Posisi",
                              style: TextStyle(fontWeight: FontWeight.w500, color: CustomColor.gray500),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ),
                          Flexible(
                            fit: FlexFit.loose,
                            child: ResponsiveText(
                              _user != null ? _user!.jabatan! : "-",
                              style: TextStyle(fontWeight: FontWeight.w700, color: Colors.black, fontSize: 17),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 20,),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Flexible(
                            fit: FlexFit.loose,
                            child: ResponsiveText(
                              "ID Karyawan",
                              style: TextStyle(fontWeight: FontWeight.w500, color: CustomColor.gray500),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ),
                          Flexible(
                            fit: FlexFit.loose,
                            child: ResponsiveText(
                              _user != null ? _user!.kode! : "-",
                              style: TextStyle(fontWeight: FontWeight.w700, color: Colors.black, fontSize: 17),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ),
                          SizedBox(height: 12,),
                          Flexible(
                            fit: FlexFit.loose,
                            child: ResponsiveText(
                              "Status",
                              style: TextStyle(fontWeight: FontWeight.w500, color: CustomColor.gray500),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ),
                          Flexible(
                            fit: FlexFit.loose,
                            child: ResponsiveText(
                              _user != null ? _user!.statusText! : "-",
                              style: TextStyle(fontWeight: FontWeight.w700, color: Colors.black, fontSize: 17),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                )
            ),
          ),
          SizedBox(height: 24,),

          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ResponsiveText(
                "Riwayat Lembur",
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
                        title: "Riwayat Lembur",
                        listType: ListType.overtime,
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

          if (!_isLoading)
            Expanded(
              child: RefreshIndicator(
                onRefresh: () => _getOvertime(_idKaryawan),
                color: CustomColor.primary,
                backgroundColor: Colors.white,
                child: ListView.builder(
                  itemCount: _overtimeList.length,
                  itemBuilder: (context, index) {
                    final overtime = _overtimeList[index];
                    return OvertimeItem(
                      overtime: overtime,
                      onClick: (result) {
                        Navigator.of(context).push(
                            MaterialPageRoute(builder: (context) => DetailScreen(
                              title: "Detail Lembur",
                              overtime: result,
                              canEdit: result.status_approval_direksi == null && result.status_approval_spv == null,
                              idKaryawan: _idKaryawan,
                            ))
                        );
                      },
                    );
                  },
                ),
              ),
            ),
        ],
      ),
    );
  }

  Future<void> _getOvertime(String idKaryawan) async {
    setState(() {
      _isLoading = true;
    });

    try {
      List<Overtime> overtimes = await _overtimeController.resume(id_karyawan: idKaryawan);

      setState(() {
        _overtimeList = overtimes;
        _isLoading = false;
      });
    } catch (e) {
      print(e);
      CustomSnackBar.of(context).show(
          message: e.toString(),
          onTop: true,
          showCloseIcon: true,
          prefixIcon: e.toString().contains("koneksi") ? Icons.wifi : Icons.warning,
          backgroundColor: CustomColor.error
      );
    }
  }
}
