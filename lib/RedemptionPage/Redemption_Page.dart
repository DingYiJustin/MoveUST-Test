
import 'package:encrypt/encrypt.dart' hide Key;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/RedemptionPage/Encryption.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'dart:convert';




class RedemptionPage extends StatefulWidget {
   final String data;
   const RedemptionPage({Key? key, required this.data}) : super(key: key,);

  @override
  State<RedemptionPage> createState() => _RedemptionPageState();
}

class _RedemptionPageState extends State<RedemptionPage> {
  late List<Widget> redemptionList;


  @override
  void initState() {
    super.initState();
    var result = jsonDecode(widget.data);
    print(result);
    print(result['redemptionList']);
     redemptionList = result['redemptionList'].map((item)=>
            QrImage(
      data: jsonEncode(
          {
            "data": AESEncryption.encryptMsg(jsonEncode(item))
                .getByte(),
          }),
      version: QrVersions.auto,
      size: 100.0,
    ),).toList().cast<Widget>();
    print(redemptionList);
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Center(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.9,
          height: MediaQuery.of(context).size.height * 0.7,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16.0),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                blurRadius: 10,
                spreadRadius: 2,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              SizedBox(height: 24.0),
              Text(
                'My QR Code',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0,
                ),
              ),
              SizedBox(height: 24.0),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(32.0),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16.0),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.3),
                          blurRadius: 10,
                          spreadRadius: 2,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            'Scan the code to redeem',
                            style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 16.0),
                          Column(
                            children: redemptionList,
                          ),
                          SizedBox(height: 16.0),
                          Text(
                            'Coupoun Amount',
                            style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 8.0),
                          Text(
                            '\$5.00',
                            style: TextStyle(
                              fontSize: 24.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 24.0),
                child: Text(
                  'Payment code is valid for 2 minutes',
                  style: TextStyle(fontSize: 12.0),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
