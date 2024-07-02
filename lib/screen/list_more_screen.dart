import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:fgsdm/controller/leave.dart';
import 'package:fgsdm/controller/overtime.dart';
import 'package:fgsdm/controller/salary.dart';
import 'package:fgsdm/model/overtime.dart';
import 'package:fgsdm/model/salary.dart';
import 'package:fgsdm/screen/salary_screen.dart';
import 'package:fgsdm/widget/custom/custom_loading_list.dart';
import 'package:fgsdm/widget/list_item/leave_item.dart';
import 'package:fgsdm/widget/list_item/overtime_item.dart';
import 'package:fgsdm/widget/list_item/salary_item.dart';
import 'package:flutter/material.dart';

import '../constant/custom_colors.dart';
import '../controller/attendance.dart';
import '../model/attendance.dart';
import '../model/leave.dart';
import '../widget/list_item/attendance_item.dart';
import '../widget/responsive/responsive_icon.dart';
import '../widget/responsive/responsive_text.dart';
import 'detail_screen.dart';

enum ListType {
  attendance,
  leave,
  overtime,
  salary
}

extension ListTypeNumber on ListType {
  int get number {
    switch (this) {
      case ListType.attendance:
        return 1;
      case ListType.leave:
        return 2;
      case ListType.overtime:
        return 3;
      case ListType.salary:
        return 4;
    }
  }
}

class ListMoreScreen extends StatefulWidget {
  final String idKaryawan;
  final String title;
  final ListType listType;
  ListMoreScreen({Key? key, required this.idKaryawan, required this.title, required this.listType}) : super(key: key);

  @override
  State<ListMoreScreen> createState() => _ListMoreScreenState();
}

class _ListMoreScreenState extends State<ListMoreScreen> {
  bool _isLoading = false;
  bool _isError = false;
  String _errorMessage = "";
  Widget _filter = Container();
  bool _isFilterOpen = false;

  // ATTENDANCE
  AttendanceController _attendanceController = AttendanceController();
  List<Attendance> _attendanceList = [];
  final List<String> _monthList = [
    'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni', 'Juli',
    'Agustus', 'September', 'Oktober', 'November', 'Desember'
  ];
  final List<int> _yearsList = [];
  int _yearNow = DateTime.now().year;
  int _selectedYear = 0;
  String _selectedMonth = "";

  // LEAVE
  LeaveController _leaveController = LeaveController();
  List<Leave> _leaveList = [];

  // OVERTIME
  OvertimeController _overtimeController = OvertimeController();
  List<Overtime> _overtimeList = [];

  SalaryController _salaryController = SalaryController();
  List<Salary> _salaryList = [];

  @override
  void initState() {
    super.initState();

    if (widget.listType == ListType.attendance) _getAttendanceList(id: widget.idKaryawan, month: "", year: 0);
    else if (widget.listType == ListType.leave) _getLeave(idKaryawan: widget.idKaryawan);
    else if (widget.listType == ListType.overtime) _getOvertimes(idKaryawan: widget.idKaryawan);
    else if (widget.listType == ListType.salary) _getSalary(idKaryawan: widget.idKaryawan);

    _selectedYear = _yearNow;
    for (int year = _yearNow; year >= 2001; year--) {
      _yearsList.add(year);
    }
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
                  if (widget.listType == ListType.attendance) InkWell(
                    onTap: () {},
                    child: ResponsiveIcon(Icons.search, color: Colors.black, size: 28),
                  ),
                  SizedBox(width: 8,),
                  InkWell(
                    onTap: () {
                      setState(() {
                        _isFilterOpen = true;
                        if (widget.listType == ListType.attendance) _filter = _attendanceFilter();
                        else if (widget.listType == ListType.leave) _filter = _leaveFilter();
                        else if (widget.listType == ListType.overtime) _filter = _overtimeFilter();
                        else if (widget.listType == ListType.salary) _filter = _salaryFilter();
                      });
                    },
                    child: ResponsiveIcon(Icons.filter_alt, color: Colors.black, size: 28),
                  ),
                ],
              ),
              SizedBox(height: 24,),

              // Filter
              AnimatedSize(
                duration: Duration(milliseconds: 200),
                child: _filter,
              ),

              // Loading
              AnimatedSize(
                duration: Duration(milliseconds: 200),
                child: _isLoading ? Container(
                  margin: EdgeInsets.only(bottom: 24),
                  child: CustomLoadingList(widget.listType != ListType.salary ? "Memperbaharui riwayat..." : "Memperbaharui rekap"),
                ) : Container(),
              ),

              if (widget.listType == ListType.attendance && _attendanceList.isNotEmpty)
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: () => _getAttendanceList(
                      id: widget.idKaryawan,
                      month: _isFilterOpen ? _selectedMonth : "",
                      year: _isFilterOpen ? _selectedYear : 0
                    ),
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

              if (widget.listType == ListType.leave && _leaveList.isNotEmpty)
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: () =>
                      _getLeave(
                        idKaryawan: widget.idKaryawan,
                        year: _isFilterOpen ? _selectedYear : null
                      ),
                    color: CustomColor.primary,
                    backgroundColor: Colors.white,
                    child: ListView.builder(
                      itemCount: _leaveList.length,
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
                          }
                        );
                      },
                    ),
                  ),
                ),

              if (widget.listType == ListType.overtime && _overtimeList.isNotEmpty)
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: () =>
                        _getOvertimes(
                            idKaryawan: widget.idKaryawan,
                            year: _isFilterOpen ? _selectedYear : null
                        ),
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
                                    idKaryawan: widget.idKaryawan,
                                  ))
                              );
                            }
                        );
                      },
                    ),
                  ),
                ),

              if (widget.listType == ListType.salary && _salaryList.isNotEmpty)
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: () =>
                        _getOvertimes(
                            idKaryawan: widget.idKaryawan,
                            year: _isFilterOpen ? _selectedYear : null
                        ),
                    color: CustomColor.primary,
                    backgroundColor: Colors.white,
                    child: ListView.builder(
                      itemCount: _salaryList.length,
                      itemBuilder: (context, index) {
                        final salary = _salaryList[index];
                        return SalaryItem(
                            salary: salary,
                            onClick: (result) {
                              Navigator.of(context).push(
                                  MaterialPageRoute(builder: (context) => SalaryScreen(idkaryawan: widget.idKaryawan, bulan: salary.bulan!,))
                              );
                            }
                        );
                      },
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _getAttendanceList({required String id, String? month, required int year}) async {
    if (month != null) {
      setState(() {
        _isLoading = true;
        _isError = false;
        _errorMessage = "";
      });

      try {
        final _attList = await _attendanceController.resume(
            idKaryawan: id,
            bulan: month.isEmpty && year == 0 ? "" : "${year}-${(_monthList.indexOf(month) + 1).toString()}"
        );
        setState(() {
          _attendanceList = _attList;
          _isLoading = false;
        });
      } catch (error) {
        setState(() {
          _isError = true;
          _errorMessage = error.toString();
          _isLoading = false;
        });
      }
    }
  }

  Widget _attendanceFilter() {
    return Container(
      margin: EdgeInsets.only(bottom: 24),
      child: Row(
        children: [
          Expanded(
            child: DropdownButtonFormField2(
              items: _monthList.map((item) => DropdownMenuItem<String>(
                value: item,
                child: ResponsiveText(
                  item,
                  style: const TextStyle(
                    fontSize: 14,
                  ),
                ),
              )).toList(),
              onChanged: (month) {
                _selectedMonth = month!;
                _getAttendanceList(id: widget.idKaryawan, month: month, year: _selectedYear);
              },
              hint: ResponsiveText("Pilih Bulan"),
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.only(top: 16, bottom: 16, left: 4, right: 16),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                // Add more decoration..
              ),
              dropdownStyleData: DropdownStyleData(
                maxHeight: 300,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          SizedBox(width: 16,),

          Expanded(
            child: DropdownButtonFormField2(
              items: _yearsList.map((item) => DropdownMenuItem<int>(
                value: item,
                child: ResponsiveText(
                  item.toString(),
                  style: const TextStyle(
                    fontSize: 14,
                  ),
                ),
              )).toList(),
              onChanged: (year) {
                _selectedYear = year!;
                _getAttendanceList(id: widget.idKaryawan, month: _selectedMonth.isEmpty ? null : _selectedMonth, year: year);
              },
              hint: ResponsiveText("Pilih Tahun"),
              value: _yearNow,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.only(top: 16, bottom: 16, left: 4, right: 16),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                // Add more decoration..
              ),
              dropdownStyleData: DropdownStyleData(
                maxHeight: 300,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          SizedBox(width: 16,),

          InkWell(
            onTap: () {
              setState(() {
                _selectedMonth = "";
                _selectedYear = 0;
                _filter = Container();
                _isFilterOpen = false;
                _getAttendanceList(id: widget.idKaryawan, month: "", year: 0);
              });
            },
            child: ResponsiveIcon(Icons.cancel, color: CustomColor.gray500, size: 28,),
          )
        ],
      ),
    );
  }



  Future<void> _getLeave({required String idKaryawan, int? year}) async {
    setState(() {
      _isLoading = true;
    });

    try {
      Leave leave = await _leaveController.resume(
        id_karyawan: idKaryawan,
        tahun: year != null ? year.toString() : ""
      );

      setState(() {
        _leaveList = leave.list!;
        _isLoading = false;
      });
    } catch (e) {
      print(e);
    }
  }

  Widget _leaveFilter() {
    return Container(
      margin: EdgeInsets.only(bottom: 24),
      child: Row(
        children: [
          Expanded(
            child: DropdownButtonFormField2(
              items: _yearsList.map((item) => DropdownMenuItem<int>(
                value: item,
                child: ResponsiveText(
                  item.toString(),
                  style: const TextStyle(
                    fontSize: 14,
                  ),
                ),
              )).toList(),
              onChanged: (year) {
                _selectedYear = year!;
                _getLeave(idKaryawan: widget.idKaryawan, year: year);
              },
              hint: ResponsiveText("Pilih Tahun"),
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.only(top: 16, bottom: 16, left: 4, right: 16),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                // Add more decoration..
              ),
              dropdownStyleData: DropdownStyleData(
                maxHeight: 300,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          SizedBox(width: 16,),

          InkWell(
            onTap: () {
              setState(() {
                _selectedYear = 0;
                _filter = Container();
                _isFilterOpen = false;
                _getLeave(idKaryawan: widget.idKaryawan);
              });
            },
            child: ResponsiveIcon(Icons.cancel, color: CustomColor.gray500, size: 28,),
          )
        ],
      ),
    );
  }



  Future<void> _getOvertimes({required String idKaryawan, int? year}) async {
    setState(() {
      _isLoading = true;
    });

    try {
      List<Overtime> list = await _overtimeController.resume(
          id_karyawan: idKaryawan,
          tahun: year != null ? year.toString() : ""
      );

      setState(() {
        _overtimeList = list;
        _isLoading = false;
      });
    } catch (e) {
      print(e);
    }
  }

  Widget _overtimeFilter() {
    return Container(
      margin: EdgeInsets.only(bottom: 24),
      child: Row(
        children: [
          Expanded(
            child: DropdownButtonFormField2(
              items: _yearsList.map((item) => DropdownMenuItem<int>(
                value: item,
                child: ResponsiveText(
                  item.toString(),
                  style: const TextStyle(
                    fontSize: 14,
                  ),
                ),
              )).toList(),
              onChanged: (year) {
                _selectedYear = year!;
                _getOvertimes(idKaryawan: widget.idKaryawan, year: year);
              },
              hint: ResponsiveText("Pilih Tahun"),
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.only(top: 16, bottom: 16, left: 4, right: 16),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                // Add more decoration..
              ),
              dropdownStyleData: DropdownStyleData(
                maxHeight: 300,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          SizedBox(width: 16,),

          InkWell(
            onTap: () {
              setState(() {
                _selectedYear = 0;
                _filter = Container();
                _isFilterOpen = false;
                _getOvertimes(idKaryawan: widget.idKaryawan);
              });
            },
            child: ResponsiveIcon(Icons.cancel, color: CustomColor.gray500, size: 28,),
          )
        ],
      ),
    );
  }



  Future<void> _getSalary({required String idKaryawan, int? year}) async {
    setState(() {
      _isLoading = true;
    });

    try {
      List<Salary> list = await _salaryController.resume(
          id_karyawan: idKaryawan,
      );

      setState(() {
        if (year == null) _salaryList = list;
        else {
          _salaryList = [];
          list.forEach((item) {
            if (item.bulan!.contains(year.toString())) _salaryList.add(item);
          });
        }

        _isLoading = false;
      });
    } catch (e) {
      print(e);
    }
  }

  Widget _salaryFilter() {
    return Container(
      margin: EdgeInsets.only(bottom: 24),
      child: Row(
        children: [
          Expanded(
            child: DropdownButtonFormField2(
              items: _yearsList.map((item) => DropdownMenuItem<int>(
                value: item,
                child: ResponsiveText(
                  item.toString(),
                  style: const TextStyle(
                    fontSize: 14,
                  ),
                ),
              )).toList(),
              onChanged: (year) {
                _selectedYear = year!;
                _getSalary(idKaryawan: widget.idKaryawan, year: year);
              },
              hint: ResponsiveText("Pilih Tahun"),
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.only(top: 16, bottom: 16, left: 4, right: 16),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                // Add more decoration..
              ),
              dropdownStyleData: DropdownStyleData(
                maxHeight: 300,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          SizedBox(width: 16,),

          InkWell(
            onTap: () {
              setState(() {
                _selectedYear = 0;
                _filter = Container();
                _isFilterOpen = false;
                _getSalary(idKaryawan: widget.idKaryawan);
              });
            },
            child: ResponsiveIcon(Icons.cancel, color: CustomColor.gray500, size: 28,),
          )
        ],
      ),
    );
  }
}
