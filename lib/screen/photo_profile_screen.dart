import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'dart:typed_data';

import 'package:fgsdm/utils/general_helper.dart';
import 'package:image/image.dart' as img;
import 'package:fgsdm/widget/bottom_slide_up.dart';
import 'package:flutter/material.dart';
import 'package:hl_image_picker/hl_image_picker.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import '../constant/custom_colors.dart';
import '../controller/user.dart';
import '../model/user.dart';
import '../widget/custom/custom_snackbar.dart';
import '../widget/loading_dialog.dart';
import '../widget/responsive/responsive_container.dart';
import '../widget/responsive/responsive_icon.dart';
import '../widget/responsive/responsive_text.dart';

class PhotoProfileScreen extends StatefulWidget {
  final String? avatar;
  final String gender;
  final String idKaryawan;
  final Function(bool) onClose;
  const PhotoProfileScreen({super.key, this.avatar, required this.gender, required this.idKaryawan, required this.onClose});

  @override
  State<PhotoProfileScreen> createState() => _PhotoProfileScreenState();
}

class _PhotoProfileScreenState extends State<PhotoProfileScreen> {

  late PanelController _slideUpPanelController;

  final _picker = HLImagePicker();
  HLPickerItem? _selectedImage;
  String? _thumbnail;

  UserController _userController = UserController();

  String _imageBase64 = "";
  bool _isLoading = false;
  bool _isAvatar = true;
  bool _isCanDelete = false;
  bool _isEdited = false;

  @override
  void initState() {
    super.initState();

    _isAvatar = widget.avatar != null;

    _isCanDelete = (widget.avatar != null && widget.avatar!.isNotEmpty);

    if (widget.avatar != null && widget.avatar!.isNotEmpty) _initializeUser();
  }

  _initializeUser() async {
    _isLoading = true;
    try {
      User user = await _userController.identity(idKaryawan: widget.idKaryawan);

      setState(() {
        _imageBase64 = user.avatar!.replaceAll("data:image/png;base64,", "");
        _isLoading = false;
      });
    } catch (e) {

    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
          child: BottomSlideUp(
            maxHeight: GeneralHelper.calculateSize(context, 160),
            isScrollable: false,
            child: Row(
              children: [
                _icons(icon: Icons.image, text: "Galeri"),
                _icons(icon: Icons.camera_alt, text: "Kamera"),
              ],
            ),
            body: Column(
              children: [
                Container(
                  padding: EdgeInsets.only(top: 24, bottom: 0, right: 24, left: 24),
                  child: Row(
                    children: [
                      InkWell(
                        onTap: () {
                          widget.onClose(_isEdited);
                          Navigator.of(context).pop();
                        },
                        child: ResponsiveIcon(Icons.arrow_back, color: Colors.white, size: 28),
                      ),
                      SizedBox(width: 16,),
                      Expanded(
                        child: ResponsiveText(
                          "Foto Profil",
                          style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w600,
                              color: Colors.white
                          ),
                        ),
                      ),
                      SizedBox(width: 16,),
                      InkWell(
                        onTap: () {
                          _slideUpPanelController.open();
                        },
                        child: ResponsiveIcon(Icons.edit, color: Colors.white, size: 28),
                      ),
                      if (_isCanDelete) SizedBox(width: 16,),
                      if (_isCanDelete) InkWell(
                        onTap: () {
                          QuickAlert.show(
                            context: context,
                            confirmBtnText: "Oke, Lanjutkan",
                            cancelBtnText: "Batal",
                            type: QuickAlertType.confirm,
                            text: 'Hapus Foto Profil',
                            onConfirmBtnTap: () {
                              Navigator.pop(context);
                              _deleteAvatar();
                            }
                          );
                        },
                        child: ResponsiveIcon(Icons.delete, color: Colors.white, size: 28),
                      ),
                    ],
                  ),
                ),

                Expanded(
                  child: Center(
                    child: Stack(
                      alignment: AlignmentDirectional.center,
                      children: [
                        ResponsiveContainer(
                          height: MediaQuery.of(context).size.width,
                          width: MediaQuery.of(context).size.width,
                          child: _buildImage(),
                        ),
                        if (_isLoading) Container(
                          child: CircularProgressIndicator(
                            color: Colors.white,
                          ),
                          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 30),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.4),
                            borderRadius: BorderRadius.circular(16)
                          ),
                        )
                      ],
                    ),
                  ),
                ),

                Container(
                  padding: EdgeInsets.only(top: 24, bottom: 0, right: 24, left: 24),
                  child: Row(
                    children: [
                      ResponsiveIcon(Icons.arrow_back, color: Colors.black, size: 28),
                      Expanded(
                        child: ResponsiveText(
                          "A",
                          style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w600,
                              color: Colors.black
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            onPanelCreated: (panelController) {
              _slideUpPanelController = panelController;
            },
          )
      ),
    );
  }

  Widget _buildImage() {
    if (_imageBase64.isNotEmpty) {
      return Image.memory(
        base64Decode(_imageBase64),
        fit: BoxFit.fill,
      );
    } else if (_thumbnail != null && _thumbnail!.isNotEmpty) {
      return Image.memory(
        base64Decode(_thumbnail!),
        fit: BoxFit.fill,
      );
    } else if (_selectedImage != null) {
      return Image.file(
        File(_selectedImage!.path),
        width: 150,
        height: 150,
        fit: BoxFit.fill,
      );
    } else if (widget.avatar != null && _isAvatar &&  widget.avatar!.isNotEmpty) {
      return Image.memory(
        base64Decode(widget.avatar!),
        fit: BoxFit.fill,
      );
    } else {
      String imagePath = "assets/images/${widget.gender == "L" ? "male" : "female"}_full.png";
      return Image.asset(
        imagePath,
        width: 150,
        height: 150,
        fit: BoxFit.fill,
      );
    }
  }

  Widget _icons({required IconData icon, required String text}) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.white,
      ),
      height: 86,
      width: 86,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () async {
            try {
              if (text == "Kamera") {
                final image = await _picker.openCamera(
                    cameraOptions: HLCameraOptions(
                        cameraType: CameraType.image
                    )
                );
                await _cropImage(item: image);

              } else {
                final images = await _picker.openPicker(
                  pickerOptions: HLPickerOptions(
                      mediaType: MediaType.image,
                      usedCameraButton: false,
                      maxSelectedAssets: 1
                  ),
                );

                HLPickerItem selected = images.first;
                await _cropImage(item: selected);
              }
            } catch (e) {
              print(e.toString());
            }
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 6),
              ResponsiveIcon(icon, size: 36, color: CustomColor.gray500),
              ResponsiveText(
                text,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: TextStyle(
                  color: CustomColor.gray500,
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

  Future<void> _cropImage({required HLPickerItem item}) async {
    try {
      final image = await _picker.openCropper(item.path,
          cropOptions: HLCropOptions(
              aspectRatio: CropAspectRatio(ratioY: 1, ratioX: 1)
          )
      );
      setState(() {
        _selectedImage = image;
      });
      _convertImageToBase64(image);

    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> _convertImageToBase64(HLPickerItem image) async {
    _slideUpPanelController.close();
    LoadingDialog.of(context).show(message: "Mengupload foto...", isDismissible: true);

    try {
      File imageFile = File(image.path);
      final bytes = await imageFile.readAsBytes();
      String base64 = "data:image/png;base64,${base64Encode(bytes)}";

      final thumbnailByte = await _getThumbnail(image);
      if (thumbnailByte != null) {
        setState(() {
          _thumbnail = base64Encode(thumbnailByte);
        });
        await GeneralHelper.preferences.setString("avatarThumbnail", base64Encode(thumbnailByte));

        bool isSuccess = await _userController.changeAvatar(idKaryawan: widget.idKaryawan, base64: base64);

        LoadingDialog.of(context).hide();
        if (isSuccess) {
          setState(() {
            _thumbnail = null;
            _imageBase64 = "";
            _isCanDelete = true;
            _isEdited = true;
          });

          CustomSnackBar.of(context).show(
            message: "Berhasil mengupload foto",
            onTop: false,
            showCloseIcon: true,
            prefixIcon: Icons.check_circle,
            backgroundColor: CustomColor.success,
            duration: Duration(seconds: 5),
          );
        } else {
          setState(() {
            _thumbnail = null;
            _selectedImage = null;
          });
          CustomSnackBar.of(context).show(
            message: "Gagal mengupload foto",
            onTop: false,
            showCloseIcon: true,
            prefixIcon: Icons.warning,
            backgroundColor: CustomColor.error,
            duration: Duration(seconds: 5),
          );
        }
      } else {
        LoadingDialog.of(context).hide();
        CustomSnackBar.of(context).show(
          message: "Gagal membuat thumbnail",
          onTop: false,
          showCloseIcon: true,
          prefixIcon: Icons.warning,
          backgroundColor: CustomColor.error,
          duration: Duration(seconds: 5),
        );
      }

    } catch (e) {
      LoadingDialog.of(context).hide();
      CustomSnackBar.of(context).show(
        message: "Gagal memuat foto",
        onTop: false,
        showCloseIcon: true,
        prefixIcon: Icons.warning,
        backgroundColor: CustomColor.error,
        duration: Duration(seconds: 5),
      );
    }
  }

  Future<Uint8List?> _getThumbnail(HLPickerItem image) async {
    File imageFile = File(image.path);
    final bytes = await imageFile.readAsBytes();

    img.Image? imageTemp = img.decodeImage(bytes);
    if (imageTemp != null) {
      img.Image thumbnail = img.copyResize(imageTemp, width: 32, height: 32);
      final thumbnailBytes = img.encodeJpg(thumbnail);

      return Uint8List.fromList(thumbnailBytes);
    }
    return null;
  }

  _deleteAvatar() async {
    LoadingDialog.of(context).show(message: "Menghapus foto...", isDismissible: true);
    try {
      bool isSuccess = await _userController.changeAvatar(idKaryawan: widget.idKaryawan, base64: "");

      LoadingDialog.of(context).hide();
      if (isSuccess) {
        await GeneralHelper.preferences.setString("avatarThumbnail", "");

        setState(() {
          _isAvatar = false;
          _imageBase64 = "";
          _thumbnail = null;
          _selectedImage = null;
          _isCanDelete = false;
          _isEdited = true;
        });

        CustomSnackBar.of(context).show(
          message: "Berhasil menghapus foto",
          onTop: false,
          showCloseIcon: true,
          prefixIcon: Icons.check_circle,
          backgroundColor: CustomColor.success,
          duration: Duration(seconds: 5),
        );
      } else {
        CustomSnackBar.of(context).show(
          message: "Gagal menghapus foto",
          onTop: false,
          showCloseIcon: true,
          prefixIcon: Icons.warning,
          backgroundColor: CustomColor.error,
          duration: Duration(seconds: 5),
        );
      }
    } catch (e) {
      LoadingDialog.of(context).hide();
      CustomSnackBar.of(context).show(
        message: "Gagal mebghapus foto",
        onTop: false,
        showCloseIcon: true,
        prefixIcon: Icons.warning,
        backgroundColor: CustomColor.error,
        duration: Duration(seconds: 5),
      );
    }
  }
}
