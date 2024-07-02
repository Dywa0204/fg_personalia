import 'package:fgsdm/model/overtime.dart';
import 'package:fgsdm/model/salary.dart';
import 'package:flutter/material.dart';

import '../../constant/custom_colors.dart';
import '../../utils/general_helper.dart';
import '../custom/custom_card.dart';
import '../responsive/responsive_icon.dart';
import '../responsive/responsive_text.dart';

class SalaryItem extends StatelessWidget {
  final Salary salary;
  final Function(Salary) onClick;
  const SalaryItem({Key? key, required this.salary, required this.onClick}) : super(key: key);

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
              onClick(salary);
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
                          "Periode ${GeneralHelper.convertDate(salary.bulan!)}",
                          style: TextStyle(fontWeight: FontWeight.w500, color: CustomColor.gray500),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                        SizedBox(height: 3,),
                        ResponsiveText(
                          salary.kode_payroll!,
                          style: TextStyle(fontWeight: FontWeight.w600, color: Colors.black, fontSize: 20),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                        SizedBox(height: 6,),
                        ResponsiveText(
                          "Issued ${GeneralHelper.convertDateTime(salary.waktu_input!)}",
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
                      Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: CustomColor.success.withOpacity(0.25),
                        ),
                        child: ResponsiveText(
                          salary.id_status_ptkp!,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: CustomColor.success,
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
