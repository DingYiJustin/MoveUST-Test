import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class RedemptionPage extends StatefulWidget {
  const RedemptionPage({Key? key}) : super(key: key);

  @override
  State<RedemptionPage> createState() => _RedemptionPageState();
}

class _RedemptionPageState extends State<RedemptionPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView(
          children: [
            Center(
              child: QrImage(
                data: "1234567890",
                version: QrVersions.auto,
                size: 200.0,
              ),
            )
          ],
        ),
    );
  }
}
