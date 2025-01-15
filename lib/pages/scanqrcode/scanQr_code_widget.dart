import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart'; // Permission handling package
import 'package:trivia_2/pages/party/party_widget.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class ScanQRCodeWidget extends StatefulWidget {
  final String userId;

  const ScanQRCodeWidget({super.key, required this.userId});

  @override
  _ScanQRCodeWidgetState createState() => _ScanQRCodeWidgetState();
}

class _ScanQRCodeWidgetState extends State<ScanQRCodeWidget> {
  late var qrCode;
  QRViewController? controller;
  String? scannedPartyId;
  File? _photo;
  final ImagePicker _picker = ImagePicker();

  Future imgFromGallery() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _photo = File(pickedFile.path);
        _onQRViewCreated;
      } else {
        print('No image selected.');
      }
    });
  }

  Future imgFromCamera() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);

    setState(() {
      if (pickedFile != null) {
        _photo = File(pickedFile.path);
        _onQRViewCreated;
      } else {
        print('No image selected.');
      }
    });
  }

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  // Callback when the QR view is created
  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        scannedPartyId = scanData.code; // Save the scanned partyId
      });
      if (scannedPartyId != null) {
        // Navigate to the PartyWidget after scan
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => PartyWidget(
              userId: widget.userId, // Use the actual userId from widget
              partyId: scannedPartyId!, // Pass the scanned partyId
            ),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Scan QR Code")),
        body: SingleChildScrollView(
            child: Column(children: [
          Padding(
              padding: EdgeInsetsDirectional.fromSTEB(24, 14, 24, 0),
              child: Container(
                width: MediaQuery.of(context).size.height * 0.6,
                height: MediaQuery.of(context).size.height * 0.5,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(
                      16.0), // Adjust the border radius as needed

                  child: MobileScanner(
                      fit: BoxFit.cover,
                      onDetect: (barcode, args) {
                        if (barcode.rawValue == null) {
                          debugPrint('Failed to scan Barcode');
                        } else {
                          qrCode = barcode.rawValue!;
                          debugPrint('Barcode found! $qrCode');
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return Dialog(
                                backgroundColor: Colors
                                    .transparent, // Transparent background
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      10.0), // Rounded corners
                                ),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.all(16.0),
                                        child: Text('Found QR code'),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.all(16.0),
                                        child: Text('Barcode found! $qrCode'),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          TextButton(
                                            child: Text('Continue'),
                                            onPressed: () {
                                              if (qrCode != '') {
                                                _onQRViewCreated;
                                              } else {}
                                              print(qrCode);
                                            },
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        }
                        ;

                        //launchUrlString(code);
                      }),
                ),
              )),
          SizedBox(
            height: 32,
          ),
        ])));
  }
}
