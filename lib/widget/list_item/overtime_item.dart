import 'package:fgsdm/model/overtime.dart';
import 'package:flutter/material.dart';

import '../../constant/custom_colors.dart';
import '../../utils/general_helper.dart';
import '../custom/custom_card.dart';
import '../responsive/responsive_icon.dart';
import '../responsive/responsive_text.dart';

class OvertimeItem extends StatelessWidget {
  final Overtime overtime;
  final Function(Overtime) onClick;
  const OvertimeItem({Key? key, required this.overtime, required this.onClick}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 20),
      child: CustomCard(
        padding: EdgeInsets.all(0),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              onClick(overtime);
            },
            borderRadius: BorderRadius.circular(16),
            highlightColor: CustomColor.gray50,
            splashColor: CustomColor.gray50,
            child: Container(
              padding: EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ResponsiveText(
                          overtime.total_durasi_lembur != null
                              ? "Lembur${convertMinutesToHours(int.parse(overtime.total_durasi_lembur!))}"
                              : "Lembur${_getTimeDifference(overtime.waktu_mulai!, overtime.waktu_selesai!, overtime.durasi_istirahat!)}",
                          style: TextStyle(fontWeight: FontWeight.w500, color: CustomColor.gray400),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                        SizedBox(height: 3,),
                        ResponsiveText(
                          "Mulai: ${GeneralHelper.convertDateTime(overtime.waktu_mulai!)}",
                          style: TextStyle(fontWeight: FontWeight.w600, color: Colors.black, fontSize: 18),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                        ResponsiveText(
                          "Selesai: ${GeneralHelper.convertDateTime(overtime.waktu_selesai!)}",
                          style: TextStyle(fontWeight: FontWeight.w600, color: Colors.black, fontSize: 18),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                        SizedBox(height: 6,),
                        ResponsiveText(
                          "Istirahat ${overtime.durasi_istirahat} Menit",
                          style: TextStyle(fontWeight: FontWeight.w500, color: CustomColor.gray500),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (overtime.status_approval_spv == null || overtime.status_approval_direksi != null) Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: overtime.status_approval_direksi == null
                              ? CustomColor.warn.withOpacity(0.25)
                              : overtime.status_approval_direksi! == "Ditolak"
                              ? CustomColor.error.withOpacity(0.25)
                              : CustomColor.success.withOpacity(0.25),
                        ),
                        child: ResponsiveText(
                          overtime.status_approval_direksi != null ? overtime.status_approval_direksi! + " Direksi" : "Pengajuan",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: overtime.status_approval_direksi == null
                                ? CustomColor.warn
                                : overtime.status_approval_direksi! == "Ditolak"
                                ? CustomColor.error
                                : CustomColor.success,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ),
                      SizedBox(height: 4),
                      if (overtime.status_approval_spv != null) Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: overtime.status_approval_spv == null
                              ? CustomColor.warn.withOpacity(0.25)
                              : overtime.status_approval_spv! == "Ditolak"
                              ? CustomColor.error.withOpacity(0.25)
                              : CustomColor.success.withOpacity(0.25),
                        ),
                        child: ResponsiveText(
                          overtime.status_approval_spv != null ? overtime.status_approval_spv! + " Manager" : "Pengajuan",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: overtime.status_approval_spv == null
                                ? CustomColor.warn
                                : overtime.status_approval_spv! == "Ditolak"
                                ? CustomColor.error
                                : CustomColor.success,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ),
                      SizedBox(height: 6),
                      Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          color: CustomColor.gray50,
                        ),
                        child: ResponsiveIcon(
                          Icons.arrow_forward_ios_rounded,
                          size: 16,
                          color: CustomColor.gray400,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  String convertMinutesToHours(int minutes) {
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
