import 'package:fgsdm/model/attendance.dart';
import 'package:fgsdm/widget/responsive/responsive_container.dart';
import 'package:flutter/material.dart';

import '../../constant/custom_colors.dart';
import '../../utils/general_helper.dart';
import '../custom/custom_card.dart';
import '../responsive/responsive_image.dart';
import '../responsive/responsive_text.dart';

class AttendanceItem extends StatelessWidget {
  final Attendance attendance;
  
  const AttendanceItem({Key? key, required this.attendance}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 20),
      child: CustomCard(
        borderRadius: 20,
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ResponsiveContainer(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(GeneralHelper.calculateSize(context, 18))),
                    color: CustomColor.primary,
                  ),
                  padding: EdgeInsets.all(4),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ResponsiveText(
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        attendance.hari!,
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                            height: 1.1
                        ),
                        textAlign: TextAlign.center,
                      ),
                      ResponsiveText(
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        attendance.tanggal!,
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            fontSize: 40,
                            height: 1.1
                        ),
                        textAlign: TextAlign.center,
                      ),
                      ResponsiveText(
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        attendance.bulan!,
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                            height: 1.1
                        ),
                        textAlign: TextAlign.center,
                      )
                    ],
                  ),
                ),
                SizedBox(width: 16), // Add some spacing between the container and the text
                IntrinsicWidth(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ResponsiveText(
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        attendance.masuk!,
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: attendance.masuk! == "00:00" ? CustomColor.gray100 : CustomColor.gray700,
                            fontSize: 44,
                            height: 1
                        ),
                        textAlign: TextAlign.start,
                      ),
                      Divider(color: CustomColor.gray200, thickness: 2,),
                      ResponsiveText(
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        attendance.pulang!,
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color:  attendance.pulang! == "00:00" ? CustomColor.gray100 : CustomColor.gray700,
                            fontSize: 44,
                            height: 1
                        ),
                        textAlign: TextAlign.start,
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Stack(
                        children: [
                          Opacity(
                            opacity: 0,
                            child: ResponsiveText(
                              "0",
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 44,
                                  height: 1
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ResponsiveText(
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  "Presensi masuk",
                                  style: TextStyle(
                                      color: CustomColor.gray500,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 18,
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
                                        attendance.locationIn!.isEmpty ? "-" : attendance.locationIn!,
                                        style: TextStyle(
                                            color: Colors.black,
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
                      Divider(color: CustomColor.gray200, thickness: 2),
                      Stack(
                        children: [
                          Opacity(
                            opacity: 0,
                            child: ResponsiveText(
                              "0",
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 44,
                                  height: 1
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ResponsiveText(
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  "Presensi pulang",
                                  style: TextStyle(
                                      color: CustomColor.gray500,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 18,
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
                                        attendance.locationOut!.isEmpty ? "-" : attendance.locationOut!,
                                        style: TextStyle(
                                            color: Colors.black,
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
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 12,),
            CustomCard(
              padding: EdgeInsets.all(4),
              color: _getAttendanceAlert(attendance.masuk!, attendance.pulang!, attendance.terlambat!).color.withOpacity(0.2),
              child: ResponsiveText(
                _getAttendanceAlert(attendance.masuk!, attendance.pulang!, attendance.terlambat!).message,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                    color: _getAttendanceAlert(attendance.masuk!, attendance.pulang!, attendance.terlambat!).color
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  AttendanceAlert _getAttendanceAlert(String masuk, String keluar, String lateStr) {
    String message = "";
    Color color = CustomColor.warn;

    if (masuk == "00:00" && keluar == "00:00") {
      message = "Tidak presensi"; color = CustomColor.error;
    } else {
      if (masuk == "00:00") {
        message = "Tidak presensi masuk"; color = CustomColor.error;
      } else {
        message = lateStr.isNotEmpty ? "Terlambat ${lateStr}" : "Tepat waktu";
        color = lateStr.isNotEmpty ? CustomColor.warn : CustomColor.success;
        if (keluar == "00:00") {
          message = "${message}, belum presesnsi pulang";
        } else {
          DateTime timeIn = DateTime.parse("2024-01-01 $masuk:00");
          DateTime timeOut = DateTime.parse("2024-01-01 $keluar:00");
          Duration difference = timeOut.difference(timeIn);

          int hours = difference.inHours;
          int minutes = difference.inMinutes % 60;

          message = "${message}, berangkat ${hours} jam ${minutes} menit";
        }
      }
    }

    return AttendanceAlert(message: message, color: color);
  }
}

class AttendanceAlert {
  final String message;
  final Color color;

  AttendanceAlert({required this.message, required this.color});
}
