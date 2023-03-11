import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/QRScanner.dart';
import 'RedemptionPage/Redemption_Page.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text("MoveUST"),),
        actions: []),
      body:  const QRScanner(),
    );
  }
}



// RedemptionPage(data: jsonEncode({
// "redemptionList":[
// {
// "user_id" : "0001",
// "redemption_time": "2019-09-26T16:17:24+05:00",
// "point": "500"
// },
// {
// "user_id" : "0002",
// "redemption_time": "2019-09-26T16:17:24+05:00",
// "point": "100"
// }
// ]
// })),

