import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:flutter_share/flutter_share.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';

import '../constant/custom_colors.dart';
import '../widget/custom/custom_snackbar.dart';
import '../widget/responsive/responsive_icon.dart';
import '../widget/responsive/responsive_text.dart';

class SalaryScreen extends StatefulWidget {
  final String idkaryawan;
  final String bulan;
  const SalaryScreen({Key? key, required this.idkaryawan, required this.bulan}) : super(key: key);

  @override
  State<SalaryScreen> createState() => _SalaryScreenState();
}

class _SalaryScreenState extends State<SalaryScreen> {
  late File? Pfile;
  bool isLoading = false;

  Future<void> loadNetwork() async {
    setState(() {
      isLoading = true;
    });
    var url = 'https://personalia.farmagitechs.co.id/Transaksi/printing/cetak_slip_gaji_pdf/${widget.bulan}/${widget.idkaryawan}';
    final response = await http.get(Uri.parse(url));
    final bytes = response.bodyBytes;
    final filename = basename(url);
    final dir = await getApplicationDocumentsDirectory();
    var file = File('${dir.path}/$filename');
    await file.writeAsBytes(bytes, flush: true);
    setState(() {
      Pfile = file;
    });

    print(Pfile);
    setState(() {
      isLoading = false;
    });
  }

  Future<void> downloadFile(BuildContext context) async {
    try {
      await FlutterShare.shareFile(
        title: 'Download Slip Gaji',
        filePath: Pfile!.path,
      );
    } catch (e) {
      print('Error sharing file: $e');
      CustomSnackBar.of(context).show(
          message: e.toString(),
          onTop: true,
          showCloseIcon: true,
          prefixIcon: e.toString().contains("koneksi") ? Icons.wifi : Icons.warning,
          backgroundColor: CustomColor.error
      );
    }
  }

  @override
  void initState() {
    loadNetwork();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColor.secondary,
      body: SafeArea(
        child: Container(
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.only(top: 24, bottom: 0, right: 24, left: 24),
                child: Row(
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
                        "Slip Gaji",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    // SizedBox(width: 16,),
                    // InkWell(
                    //   onTap: () {
                    //     downloadFile(context);
                    //   },
                    //   child: ResponsiveIcon(Icons.download, color: Colors.black, size: 28),
                    // ),
                  ],
                ),
              ),
              SizedBox(height: 24,),

              Expanded(
                child: isLoading
                        ? Center(child: CircularProgressIndicator())
                        : Container(
                      child: PDFView(
                        autoSpacing: false,
                        filePath: Pfile?.path,
                      ),
                    ),
              )
            ],
          ),
        ),
      ),
    );
  }

}
