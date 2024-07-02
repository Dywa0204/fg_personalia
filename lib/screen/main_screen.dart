import 'dart:convert';
import 'package:camera/camera.dart';
import 'package:fgsdm/constant/custom_colors.dart';
import 'package:fgsdm/controller/attendance.dart';
import 'package:fgsdm/model/master_leave.dart';
import 'package:fgsdm/screen/attendance/attendance_screen.dart';
import 'package:fgsdm/screen/home_screen.dart';
import 'package:fgsdm/screen/overtime/overtime_screen.dart';
import 'package:fgsdm/screen/profile_screen.dart';
import 'package:fgsdm/utils/general_helper.dart';
import 'package:fgsdm/widget/location_widget.dart';
import 'package:fgsdm/widget/responsive/responsive_container.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import '../controller/leave.dart';
import '../model/user.dart';
import '../widget/bottom_slide_up.dart';
import '../widget/custom/custom_snackbar.dart';
import '../widget/loading_dialog.dart';
import '../widget/responsive/responsive_icon.dart';
import '../widget/responsive/responsive_image.dart';
import '../widget/responsive/responsive_text.dart';
import 'leave/leave_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  // Camera
  late CameraController _cameraController;

  // Location
  LocationWidgetController _locationWidgetController = LocationWidgetController();

  // Slide Up Panel
  Widget _widgetSlideUp = Container();
  late PanelController _slideUpPanelController;
  final GlobalKey<BottomSlideUpState> _bottomSlideUpKey = GlobalKey<BottomSlideUpState>();

  final AttendanceController _attendanceController = new AttendanceController();
  bool _isAttendanceIN = true;
  String _storedImage = "";
  AttendanceScreenController _attendanceScreenController = AttendanceScreenController();

  LeaveController _leaveController = LeaveController();


  // Navigation
  int _selectedNav = 0;
  final List<Widget> _screens = [
    HomeScreen(),
    LeaveScreen(),
    Container(),
    OvertimeScreen(),
    ProfileScreen(),
  ];

  @override
  void initState() {
    _isAttendanceIN = GeneralHelper.isStatusIN;
    _screens[2] = AttendanceScreen(
      onClick: (attStatus) => { _openSLideUp(attStatus) },
      controller: _attendanceScreenController,
    );
    _getMasterLeaveTypeList();
    super.initState();
  }

  @override
  void dispose() {
    _cameraController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: BottomSlideUp(
        isScrollable: false,
        key: _bottomSlideUpKey,
        onPanelCreated: (panelController) {
          _slideUpPanelController = panelController;
        },
        onPanelClosed: () {
          _cameraController.dispose();
        },
        header: Padding(
          padding: const EdgeInsets.only(bottom: 6, top: 5),
          child: Row(
            children: [
              InkWell(
                onTap: () {
                  _slideUpPanelController.close();
                },
                child: const ResponsiveIcon(Icons.arrow_back, color: Colors.black, size: 32),
              ),
              Expanded(
                child: ResponsiveText(
                  _isAttendanceIN ? "Presensi Masuk" : "Preseni Pulang",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
        headerMore: LocationWidget(
          widgetType: WidgetType.slideUp,
          controller: _locationWidgetController,
        ),
        child: Flexible(
          child: AspectRatio(
            aspectRatio: 9/16,
            child: Container(
              color: Colors.black,
              child: _widgetSlideUp,
            ),
          ),
        ),
        body: Scaffold(
          backgroundColor: CustomColor.secondary,
          body: SafeArea(
            child: Container(
              padding: const EdgeInsets.all(24),
              child: _screens[_selectedNav],
            ),
          ),
          floatingActionButtonAnimator: NoScalingAnimation(),
          floatingActionButton: ResponsiveContainer(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(GeneralHelper.calculateSize(context, 16)),
              color: _selectedNav == 2 ? CustomColor.primary : CustomColor.gray400,
            ),
            width: 90,
            height: 90,
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(GeneralHelper.calculateSize(context, 16)),
                highlightColor: Colors.black.withOpacity(0.2),
                splashColor: Colors.black.withOpacity(0.2),
                onTap: () async {
                  setState(() {
                    _selectedNav = 2;
                  });
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ResponsiveImage("assets/icons/fact_check.png", width: 56, fit: BoxFit.fitWidth),
                    const SizedBox(height: 6),
                    ResponsiveText(
                      "Presensi",
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          bottomNavigationBar: BottomAppBar(
            height: GeneralHelper.calculateSize(context, 96),
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            color: Colors.white,
            elevation: 24,
            shadowColor: Colors.black,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Expanded(child: _navbarResponsiveIcon(
                  index: 0,
                  selectedIndex: _selectedNav,
                  icon: Icons.home_filled,
                  text: "Home",
                  onSelected: () {
                    setState(() {
                      _selectedNav = 0;
                    });
                  },
                )),
                Expanded(child: _navbarResponsiveIcon(
                  index: 1,
                  selectedIndex: _selectedNav,
                  icon: Icons.arrow_circle_up,
                  text: "Cuti",
                  onSelected: () {
                    setState(() {
                      _selectedNav = 1;
                    });
                  },
                )),
                ResponsiveContainer(width: 130,),
                Expanded(child: _navbarResponsiveIcon(
                  index: 3,
                  selectedIndex: _selectedNav,
                  icon: Icons.work_history,
                  text: "Lembur",
                  onSelected: () {
                    setState(() {
                      _selectedNav = 3;
                    });
                  },
                )),
                Expanded(child: _navbarResponsiveIcon(
                  index: 4,
                  selectedIndex: _selectedNav,
                  icon: Icons.person_pin,
                  text: "Profil",
                  onSelected: () {
                    setState(() {
                      _selectedNav = 4;
                    });
                  },
                )),
              ],
            ),
          ),
          floatingActionButtonLocation: CustomFloatingActionButtonLocation(),
        ),
      ),
    );
  }

  Widget _navbarResponsiveIcon({
    required int index,
    required int selectedIndex,
    required IconData icon,
    required String text,
    required VoidCallback onSelected,
  }) {
    final isSelected = index == selectedIndex;
    final color = isSelected ? CustomColor.primary : CustomColor.gray200;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.white,
      ),
      height: 64,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onSelected,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 6),
              ResponsiveIcon(icon, size: 36, color: color),
              ResponsiveText(
                text,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: TextStyle(
                  color: color,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _attendanceSlideUp(Future<void> _initializeControllerFuture) {
    return FutureBuilder(
      future: _initializeControllerFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return CameraPreview(
            _cameraController,
            child: CameraButtonWidget(
              canTap: true,
              toggleCameraLens: _toggleCameraLens,
              takePicture: _takePicture,
              resumeCamera: _resumeCamera,
              sendPicture: _processAttendance,
              cameraController: _cameraController,
            ),
          );
        } else {
          return CameraButtonWidget(
            canTap: false,
            cameraController: _cameraController,
          );
        }
      },
    );
  }

  void _openSLideUp(String attStatus) async {
    _slideUpPanelController.open();

    await GeneralHelper.initializeFirstCamera();
    _cameraController = CameraController(
      GeneralHelper.firstCamera,
      ResolutionPreset.high,
    );

    Future<void> _initializeControllerFuture = _cameraController.initialize();

    setState(() {
      _isAttendanceIN = attStatus == "IN";
      _widgetSlideUp = _attendanceSlideUp(_initializeControllerFuture);
    });
  }

  void _toggleCameraLens() async {
    final lensDirection = _cameraController.description.lensDirection;
    CameraDescription newDescription;
    if(lensDirection == CameraLensDirection.front){
      newDescription = GeneralHelper.availableCamera.firstWhere((description) => description.lensDirection == CameraLensDirection.back);
    }
    else{
      newDescription = GeneralHelper.availableCamera.firstWhere((description) => description.lensDirection == CameraLensDirection.front);
    }

    _cameraController = CameraController(newDescription, ResolutionPreset.high);
    Future<void> _initializeControllerFuture = _cameraController.initialize();

    setState(() {
      _widgetSlideUp = _attendanceSlideUp(_initializeControllerFuture);
    });
  }

  _takePicture() {
    _cameraController.pausePreview();
    _cameraController.takePicture().then((value) {
      value.readAsBytes().then((result) async {
        _storedImage = base64.encode(result);
      });
    });
  }

  _resumeCamera() {
    setState(() {
      _cameraController.resumePreview();
    });
  }

  _processAttendance() async {
    try {
      String? address = _locationWidgetController.getCurrentAddressStr();
      LocationData? locationData = _locationWidgetController.getCurrentLocation();
      User? user = await GeneralHelper.getUserFromPreferences();

      // print("id_karyawan: " + user!.idKaryawan);
      // print("Latitude: ${locationData?.latitude ?? "0.0"}");
      // print("Longitude: ${locationData?.longitude ?? "0.0"}");
      // print("Location: ${address ?? "0.0"}");
      // print("foto: data:image/png;base64,${_storedImage}");

      LoadingDialog.of(context).show(message: "Tunggu Sebentar...", isDismissible: false);

      String attendanceMessage = await _attendanceController.add(
          idKaryawan: user!.idKaryawan,
          latitude: "${locationData?.latitude ?? "0.0"}",
          longitude: "${locationData?.longitude ?? "0.0"}",
          status: "${_isAttendanceIN ? "IN" : "OUT"}",
          location: "${address ?? "Lokasi tidak ditemukan"}",
          foto: "data:image/png;base64,${_storedImage}"
      );
      LoadingDialog.of(context).hide();

      if (!attendanceMessage.isEmpty) {
        CustomSnackBar.of(context).show(
            message: attendanceMessage,
            onTop: true,
            showCloseIcon: true,
            prefixIcon: Icons.check_circle,
            backgroundColor: CustomColor.success,
          duration: Duration(seconds: 5)
        );

        setState(() {
          _isAttendanceIN = !_isAttendanceIN;
        });
        print("status: ${_isAttendanceIN ? "IN" : "OUT"}");
        await GeneralHelper.preferences.setBool("isAttendanceIN", _isAttendanceIN);

        _slideUpPanelController.close();
        _attendanceScreenController.refreshData();
      } else {
        CustomSnackBar.of(context).show(
          message: "Gagal melakukan presensi",
          onTop: true,
          showCloseIcon: true,
          prefixIcon: Icons.warning,
          backgroundColor: CustomColor.error,
          duration: Duration(seconds: 5)
        );
      }

    } catch (error) {
      LoadingDialog.of(context).hide();
      CustomSnackBar.of(context).show(
        message: error.toString(),
        onTop: true,
        showCloseIcon: true,
        prefixIcon: error.toString().contains("koneksi") ? Icons.wifi : Icons.warning,
        backgroundColor: CustomColor.error,
        duration: Duration(seconds: 5)
      );
    }
  }

  _getMasterLeaveTypeList() async {
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      List<MasterLeaveType> list = await _leaveController.master();

      GeneralHelper.listMasterLeaveType = list;
      if (list.length != 0) {
        String masterLeaveJson = "";
        list.forEach((item) {
          masterLeaveJson += "${item.toString()},";
        });

        await preferences.setString("masterLeaveType", "{\"data\":[${masterLeaveJson.substring(0, masterLeaveJson.length - 1)}]}");
      }

    } catch(e) {

    }
  }
}

class CustomFloatingActionButtonLocation extends FloatingActionButtonLocation {
  @override
  Offset getOffset(ScaffoldPrelayoutGeometry scaffoldGeometry) {
    final double fabX = (scaffoldGeometry.scaffoldSize.width - scaffoldGeometry.floatingActionButtonSize.width) / 2;
    final double fabY = scaffoldGeometry.scaffoldSize.height - scaffoldGeometry.floatingActionButtonSize.height - scaffoldGeometry.minInsets.bottom - 20;
    return Offset(fabX, fabY);
  }
}

class NoScalingAnimation extends FloatingActionButtonAnimator {
  @override
  Offset getOffset({required Offset begin, required Offset end, required double progress}) {
    return end;
  }

  @override
  Animation<double> getRotationAnimation({required Animation<double> parent}) {
    return Tween<double>(begin: 1.0, end: 1.0).animate(parent);
  }

  @override
  Animation<double> getScaleAnimation({required Animation<double> parent}) {
    return Tween<double>(begin: 1.0, end: 1.0).animate(parent);
  }
}

class CameraButtonWidget extends StatefulWidget {
  final bool canTap;
  final VoidCallback? toggleCameraLens;
  final VoidCallback? takePicture;
  final VoidCallback? resumeCamera;
  final VoidCallback? sendPicture;
  final CameraController cameraController;

  CameraButtonWidget({Key? key,
    required this.canTap,
    this.toggleCameraLens,
    required this.cameraController,
    this.takePicture,
    this.resumeCamera,
    this.sendPicture
  }) : super(key: key);

  @override
  State<CameraButtonWidget> createState() => _CameraButtonWidgetState();
}

class _CameraButtonWidgetState extends State<CameraButtonWidget> {
  int _flashMode = 0;
  IconData _flashIcon = Icons.flash_off;
  late double _buttonSize = 86;
  late Widget _leftButton;
  late Widget _rightButton;
  late Widget _centerButton;

  @override
  void initState() {
    super.initState();
    _leftButton = _toggleCameraButton();
    if (widget.cameraController.description.lensDirection == CameraLensDirection.back) {
      _rightButton = _flashButton();
    } else {
      _rightButton = _voidButton();
    }
    _centerButton = _takePictureButton();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          color: Colors.black.withOpacity(0.5),
          padding: const EdgeInsets.only(bottom: 48, top: 24),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _leftButton,
              _centerButton,
              _rightButton
            ],
          ),
        ),
      ],
    );
  }

  Widget _okeButton() {
    return InkWell(
      onTap: () {
        if (widget.sendPicture != null) widget.sendPicture!();
      },
      child: ResponsiveContainer(
        width: 86,
        height: 86,
        child: AnimatedContainer(
          decoration: BoxDecoration(
            border: Border.all(width: 6, color: CustomColor.success),
            borderRadius: BorderRadius.all(Radius.circular(43)),
          ),
          width: _buttonSize,
          height: _buttonSize,
          duration: Duration(milliseconds: 150),
          child: ResponsiveIcon(Icons.check_circle, size: 64, color: CustomColor.success),
        ),
      ),
    );
  }

  Widget _takePictureButton() {
    return InkWell(
      onTap: () {
        setState(() {
          _leftButton = _cancelPreviewButton();
          _rightButton = _voidButton();
          _centerButton = _okeButton();
        });
        if (widget.takePicture != null) widget.takePicture!();
      },
      child: ResponsiveContainer(
        width: 86,
        height: 86,
        child: AnimatedContainer(
          decoration: BoxDecoration(
            border: Border.all(width: 6, color: Colors.white),
            borderRadius: BorderRadius.all(Radius.circular(43)),
          ),
          width: _buttonSize,
          height: _buttonSize,
          duration: Duration(milliseconds: 150),
          child: ResponsiveIcon(Icons.camera, size: 64, color: Colors.white),
        ),
      ),
    );
  }

  Widget _voidButton() {
    return ResponsiveContainer(
      width: 86,
      height: 86,
    );
  }

  Widget _flashButton() {
    return InkWell(
      onTap: () {
        if (widget.canTap) {
          setState(() {
            if (_flashMode == 0) {
              widget.cameraController.setFlashMode(FlashMode.torch);
              _flashIcon = Icons.flash_on;
              _flashMode = 1;
            } else if (_flashMode == 1) {
              widget.cameraController.setFlashMode(FlashMode.off);
              _flashIcon = Icons.flash_off;
              _flashMode = 0;
            }
            _rightButton = _flashButton();
          });
        }
      },
      child: ResponsiveContainer(
        width: 86,
        height: 86,
        child: ResponsiveIcon(_flashIcon, size: 32, color: Colors.white),
      ),
    );
  }

  Widget _cancelPreviewButton() {
    return InkWell(
      onTap: () {
        if (widget.canTap) {
          setState(() {
            _leftButton = _toggleCameraButton();
            if (widget.cameraController.description.lensDirection == CameraLensDirection.back) {
              _rightButton = _flashButton();
            } else {
              _rightButton = _voidButton();
            }
            _centerButton = _takePictureButton();
          });
          if (widget.resumeCamera != null) widget.resumeCamera!();
        }
      },
      child: ResponsiveContainer(
        width: 86,
        height: 86,
        child: ResponsiveIcon(Icons.cancel, size: 48, color: CustomColor.error),
      ),
    );
  }

  Widget _toggleCameraButton() {
    return InkWell(
      onTap: () {
        if (widget.canTap) {
          if (widget.toggleCameraLens != null) widget.toggleCameraLens!();
        }
      },
      child: ResponsiveContainer(
        width: 86,
        height: 86,
        child: ResponsiveIcon(Icons.cameraswitch_outlined, size: 32, color: Colors.white),
      ),
    );
  }
}

