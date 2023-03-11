import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:ui';

import 'package:encrypt/encrypt.dart' hide Key;
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/RedemptionPage/Encryption.dart';
import 'package:flutter_application_1/RedemptionPage/Redemption.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class QRScanner extends StatefulWidget {
  const QRScanner({Key? key}) : super(key: key);

  @override
  State<QRScanner> createState() => _QRScannerState();
}

class _QRScannerState extends State<QRScanner> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  late Redemption redemptionInfo;
  Barcode? result;
  QRViewController? controller;
  bool checked=false;
  late double windowWidth;
  late double windowHeight;

  @override
  void initState() {
    print('ads');

    super.initState();
  }

  String createRedemptionInfo(String? result){
    print(result);
    try{
        var data = jsonDecode(result!)['data'];
        print(data);
        var decryptedResult = jsonDecode(AESEncryption.decryptMsg(Encrypted(Uint8List.fromList(data.cast<int>()))));
        print(decryptedResult);
        redemptionInfo = Redemption(decryptedResult['user_id'], decryptedResult['redemption_time'], decryptedResult['point']);
        print(redemptionInfo);
        print(redemptionInfo.point);
        return redemptionInfo.getPoint();
    }catch(e){return "loading...";}
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    log('${DateTime.now().toIso8601String()}_onPermissionSet $p');
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('no Permission')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    windowWidth = MediaQuery.of(context).size.width;
    windowHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 5,
            child: QRView(
              key: qrKey,
              overlay: QrScannerOverlayShape(cutOutSize: 200,borderWidth: 0),
              onQRViewCreated: _onQRViewCreated,
              onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
            ),
          ),
          Expanded(
            flex: 1,
            child: Center(
              child: (result != null)
                  ? Text(
                    'Redemption_Point: ${createRedemptionInfo(result!.code)}')
                  : Text('Scan a code'),
            ),
          ),
      //   AlertDialog(
      //   title: const Text('AlertDialog Title'),
      //   alignment: Alignment.center,
      //   content: SingleChildScrollView(
      //     child: ListBody(
      //       children: const <Widget>[
      //         Text('This is a demo alert dialog.'),
      //         Text('Would you like to approve of this message?'),
      //       ],
      //     ),
      //   ),
      //   actions: <Widget>[
      //     TextButton(
      //       child: const Text('Approve'),
      //       onPressed: () {
      //         Navigator.of(context).pop();
      //       },
      //     ),
      //   ],
      // ),
        ],
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      print(scanData);
      print('----------------------------');
      setState(() {
        print(scanData!.code);
        result = scanData;
      });
    });
    print('---------------  -------------');
  }

  @override
  void dispose() {
    print('dispose');
    controller?.dispose();
    super.dispose();
  }
}
