import 'leave.dart';
import 'overtime.dart';

class Home {
  final List<Leave>? usulan_cuti;
  final List<Overtime>? usulan_lembur;
  final String? sisa_cuti_tahunan;
  final String? next_gajian;

  Home({this.usulan_cuti, this.usulan_lembur, this.sisa_cuti_tahunan, this.next_gajian});

  factory Home.fromJson(List<Leave> listLeave, List<Overtime> listOvertime, String leaveLeft, String nextPayment) {
    return Home(
      usulan_cuti: listLeave,
      usulan_lembur: listOvertime,
      sisa_cuti_tahunan: leaveLeft,
      next_gajian: nextPayment
    );
  }
}