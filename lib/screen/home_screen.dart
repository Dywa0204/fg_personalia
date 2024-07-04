import 'package:fgsdm/constant/custom_colors.dart';
import 'package:fgsdm/controller/home.dart';
import 'package:fgsdm/model/home.dart';
import 'package:fgsdm/utils/general_helper.dart';
import 'package:fgsdm/widget/responsive/responsive_text.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../model/leave.dart';
import '../model/overtime.dart';
import '../widget/custom/custom_card.dart';
import '../widget/custom/custom_loading_list.dart';
import '../widget/custom/custom_snackbar.dart';
import '../widget/list_item/leave_item.dart';
import '../widget/list_item/overtime_item.dart';
import '../widget/responsive/responsive_image.dart';
import 'detail_screen.dart';
import 'list_more_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late String _name = "Napoleon Bonaparte";
  late String _idKaryawan = "1";
  late String _level = "Karyawan";
  bool _isLoading = false;

  HomeController _homeController = HomeController();
  List<Leave> _leaveList = [];
  List<Overtime> _overtimeList = [];
  String _leaveLeft = "";
  String _nextPayment = "0";

  DateTime _dateNow = DateTime.now();
  late String _dateNowStr = "";

  @override
  void initState() {
    super.initState();

    _initializeUser();
    _dateNowStr = DateFormat('EEEE, dd MMMM yyyy', 'id_ID').format(_dateNow);
  }

  _initializeUser() async {
    await GeneralHelper.getUserFromPreferences().then((value) {
      _getHomeContent("${value?.idKaryawan}", "${value?.level}");

      setState(() {
        _name = value!.nama;
        _idKaryawan = value.idKaryawan;
        _level = value.level;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ResponsiveText(
                      "Selamat Datang",
                      textAlign: TextAlign.start,
                      style: TextStyle(
                          color: CustomColor.gray500,
                          fontWeight: FontWeight.w600,
                          fontSize: 18
                      ),
                    ),
                    ResponsiveText(
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      _name,
                      textAlign: TextAlign.start,
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w700,
                          fontSize: 24
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
                    ),
                  ],
                ),
              ),
              SizedBox(width: 24,),
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(32)),
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.all(Radius.circular(32)),
                    onTap: () {},
                    child: ResponsiveImage("assets/icons/notification.png"),
                  ),
                ),
              )
            ],
          ),
          SizedBox(height: 36,),

          CustomCard(
            padding: EdgeInsets.all(20),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Flexible(
                        fit: FlexFit.loose,
                        child: ResponsiveText(
                          "Gajian",
                          style: TextStyle(fontWeight: FontWeight.w500, color: CustomColor.gray500),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ),
                      Flexible(
                        fit: FlexFit.loose,
                        child: ResponsiveText(
                          !_isLoading ? "${_nextPayment} Hari Lagi" : "...",
                          style: TextStyle(fontWeight: FontWeight.w600, color: Colors.black, fontSize: 28),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ),
                      Flexible(
                        fit: FlexFit.loose,
                        child: ResponsiveText(
                          int.parse(_nextPayment) >= 10 ? "Harus semangat kerja!" : "Tetap semangat kerja!",
                          style: TextStyle(fontWeight: FontWeight.w500, color: CustomColor.gray500),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  color: CustomColor.gray500,
                  width: 1,
                  height: 48,
                ),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Flexible(
                        fit: FlexFit.loose,
                        child: ResponsiveText(
                          "Sisa",
                          style: TextStyle(fontWeight: FontWeight.w500, color: CustomColor.gray500),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ),
                      Flexible(
                        fit: FlexFit.loose,
                        child: ResponsiveText(
                          !_isLoading ? _leaveLeft : "...",
                          style: TextStyle(fontWeight: FontWeight.w600, color: Colors.black, fontSize: 28),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ),
                      Flexible(
                        fit: FlexFit.loose,
                        child: ResponsiveText(
                          "Cuti Tahunan",
                          style: TextStyle(fontWeight: FontWeight.w500, color: CustomColor.gray500),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 32,),

          // Loading
          AnimatedSize(
            duration: Duration(milliseconds: 200),
            child: _isLoading ? Container(
              margin: EdgeInsets.only(bottom: 24),
              child: CustomLoadingList("Memperbaharui usulan..."),
            ) : Container(),
          ),

          if (!_isLoading)
            Expanded(
            child: RefreshIndicator(
              onRefresh: () => _getHomeContent(_idKaryawan, _level),
              color: CustomColor.primary,
              backgroundColor: Colors.white,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ResponsiveText(
                          "Usulan Cuti",
                          textAlign: TextAlign.start,
                          style: TextStyle(
                              color: CustomColor.gray700,
                              fontWeight: FontWeight.w600,
                              fontSize: 24
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.of(context).push(
                                MaterialPageRoute(builder: (context) => ListMoreScreen(
                                  idKaryawan: _idKaryawan,
                                  title: "Riwayat Cuti",
                                  listType: ListType.leave,
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
                    ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: _leaveList.length > 5 ? 5 : _leaveList.length,
                      itemBuilder: (context, index) {
                        final leave = _leaveList[index];
                        return LeaveItem(
                          leave: leave,
                          onClick: (result) {
                            Navigator.of(context).push(
                                MaterialPageRoute(builder: (context) => DetailScreen(
                                  title: "Detail Cuti",
                                  leave: result,
                                  canEdit: result.status!.contains("Pengajuan"),
                                ))
                            );
                          },
                        );
                      },
                    ),

                    SizedBox(height: 32,),

                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ResponsiveText(
                          "Usulan Lembur",
                          textAlign: TextAlign.start,
                          style: TextStyle(
                              color: CustomColor.gray700,
                              fontWeight: FontWeight.w600,
                              fontSize: 24
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
                    ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: _overtimeList.length > 5 ? 5 : _overtimeList.length,
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
                    )
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Future<void> _getHomeContent(String idKaryawan, String level) async {
    setState(() {
      _isLoading = true;
    });

    try {
      Home home = await _homeController.home(idKaryawan: idKaryawan, level: level);

      setState(() {
        _leaveList = home.usulan_cuti!;
        _overtimeList = home.usulan_lembur!;
        _leaveLeft = home.sisa_cuti_tahunan!;
        _nextPayment = _getPaymentCountdown(home.next_gajian!);
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

  String _getPaymentCountdown(String next) {
    Map<String, int> monthMap = {
      "Jan": 1,
      "Feb": 2,
      "Mar": 3,
      "Apr": 4,
      "May": 5,
      "Jun": 6,
      "Jul": 7,
      "Aug": 8,
      "Sep": 9,
      "Oct": 10,
      "Nov": 11,
      "Dec": 12
    };

    List<String> parts = next.split(' ');
    String monthStr = parts[0];
    int day = int.parse(parts[1]);
    int year = int.parse(parts[2]);

    List<String> timeParts = parts[3].split(':');
    int hour = int.parse(timeParts[0]);
    int minute = int.parse(timeParts[1]);
    int second = int.parse(timeParts[2]);

    int month = monthMap[monthStr]!;

    // Create DateTime object
    DateTime nextDate = DateTime(year, month, day, hour, minute, second);
    DateTime dateNow = DateTime.now();

    Duration duration = nextDate.difference(dateNow);

    return duration.inDays.toString();
  }
}
