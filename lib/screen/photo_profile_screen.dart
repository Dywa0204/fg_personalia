import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'dart:typed_data';

import 'package:fgsdm/utils/general_helper.dart';
import 'package:hl_image_picker_ios/hl_image_picker_ios.dart';
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
import 'package:photo_view/photo_view.dart';

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
  final _pickerIOS = HLImagePickerIOS();
  HLPickerItem? _selectedImage;
  String? _thumbnail;
  String? _thumbnailTemp;

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
      return PhotoView(
        imageProvider: MemoryImage(
          base64Decode(_imageBase64),
        )
      );
    } else if (_thumbnail != null && _thumbnail!.isNotEmpty) {
      return PhotoView(
        imageProvider: MemoryImage(
          base64Decode(_thumbnail!),
        ),
      );
    } else if (_selectedImage != null) {
      return PhotoView(
        imageProvider: FileImage(
          File(_selectedImage!.path),
        ),
      );
    } else if (widget.avatar != null && _isAvatar &&  widget.avatar!.isNotEmpty) {
      return PhotoView(
        imageProvider: MemoryImage(
          base64Decode(widget.avatar!),
        ),
      );
    } else {
      String imagePath = "assets/images/${widget.gender == "L" ? "male" : "female"}_full.png";
      return PhotoView(
        imageProvider: AssetImage(
          imagePath,
        ),
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
                if (Platform.isIOS) {
                  _pickerIOS.openCamera(
                    cameraOptions: HLCameraOptions(
                      compressQuality: 0.4,
                      cameraType: CameraType.image
                    ),
                    cropping: true,
                    cropOptions: const HLCropOptions(
                      aspectRatioPresets: [CropAspectRatioPreset.square],
                    ),
                  ).then((image) {
                    _convertImageToBase64(image);
                    // _cropImage(item: image);
                  });
                } else {
                  _picker.openCamera(
                    cameraOptions: HLCameraOptions(
                      compressQuality: 0.4,
                      cameraType: CameraType.image
                    ),
                    cropping: true,
                    cropOptions: const HLCropOptions(
                      aspectRatioPresets: [CropAspectRatioPreset.square],
                    ),
                  ).then((image) {
                    _convertImageToBase64(image);
                    // _cropImage(item: image);
                  });
                }
              } else {
                if (Platform.isIOS) {
                  _pickerIOS.openPicker(
                    pickerOptions: HLPickerOptions(
                        mediaType: MediaType.image,
                        usedCameraButton: false,
                        maxSelectedAssets: 1
                    ),
                  ).then((images) {
                    HLPickerItem selected = images.first;
                    // _cropImage(item: selected);
                  });
                } else {
                  _picker.openPicker(
                    pickerOptions: HLPickerOptions(
                        mediaType: MediaType.image,
                        usedCameraButton: false,
                        maxSelectedAssets: 1
                    ),
                  ).then((images) {
                    HLPickerItem selected = images.first;
                    // _cropImage(item: selected);
                  });
                }
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

  // Future<void> _cropImage({required HLPickerItem item}) async {
  //   try {
  //     image_cropper.CroppedFile? croppedFile = await image_cropper.ImageCropper().cropImage(
  //       sourcePath: item.path,
  //       uiSettings: [
  //         image_cropper.AndroidUiSettings(
  //           toolbarTitle: 'Crop Foto',
  //           toolbarColor: CustomColor.secondary,
  //           toolbarWidgetColor: Colors.black,
  //           lockAspectRatio: true,
  //           initAspectRatio: image_cropper.CropAspectRatioPreset.square,
  //           aspectRatioPresets: [
  //             image_cropper.CropAspectRatioPreset.square
  //           ],
  //         ),
  //         image_cropper.IOSUiSettings(
  //           title: 'Crop Foto',
  //           aspectRatioPresets: [
  //             image_cropper.CropAspectRatioPreset.square,
  //           ],
  //         ),
  //       ],
  //     );
  //
  //     _selectedImage = HLPickerItem(
  //       path: croppedFile!.path,
  //       id: "", name: "name", mimeType: "mimeType", size: 0, width: 0,
  //       height: 0, type: "type"
  //     );
  //     _convertImageToBase64(_selectedImage!);
  //
  //   } catch (e) {
  //     print(e.toString());
  //   }
  // }

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

        print("ini base : ${base64}");
        bool isSuccess = await _userController.changeAvatar(idKaryawan: widget.idKaryawan, base64: base64);

        LoadingDialog.of(context).hide();
        if (isSuccess) {
          await GeneralHelper.preferences.setString("avatarThumbnail", base64Encode(thumbnailByte));

          setState(() {
            _thumbnail = null;
            _imageBase64 = "";
            _isCanDelete = true;
            _isEdited = true;
            _selectedImage = image;
          });
          GeneralHelper.isProfileUpdate = true;
          _showSnackBar("Berhasil mengupload foto", 2);
        } else {
          setState(() {
            _thumbnail = null;
            _selectedImage = null;
          });
          _showSnackBar("Gagal mengupload foto", 1);
        }
      } else {
        LoadingDialog.of(context).hide();
        _showSnackBar("Gagal membuat thumbnail", 1);
      }

    } catch (e) {
      LoadingDialog.of(context).hide();

      setState(() {
        _thumbnail = _thumbnailTemp;
      });

      _showSnackBar(e.toString().contains("Request Entity Too Large") ? "Gagal! Ukuran foto terlalu besar" : "Gagal memuat foto", 1);
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
        GeneralHelper.isProfileUpdate;

        _showSnackBar("Berhasil mebghapus foto", 2);
      } else {
        _showSnackBar("Gagal mebghapus foto", 1);
      }
    } catch (e) {
      LoadingDialog.of(context).hide();
      _showSnackBar("Gagal mebghapus foto", 1);
    }
  }

  _showSnackBar(String message, int type) {
    CustomSnackBar.of(context).show(
      message: message,
      onTop: false,
      showCloseIcon: true,
      prefixIcon: type == 1 ? Icons.warning : Icons.check_circle,
      backgroundColor: type == 1 ? CustomColor.error : CustomColor.success,
      duration: Duration(seconds: 5),
    );
  }
}
