import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/QRScanner.dart';
import 'package:flutter_application_1/app_theme.dart';
import 'package:flutter_application_1/pedometer/Pedometer.dart';
import 'RedemptionPage/Redemption_Page.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text("MoveUST"),),
        actions: []),
      body:  const PedoCheck(),
      drawer: Drawer(child: 
      ListView(
        children: [
          UserAccountsDrawerHeader(accountName: Text("User Name"), accountEmail: Text("xxxxxx@xxx.xxx")),
          InkWell(
            child: const ListTile(title: Text('Redemption',style: AppTheme.customDialogButton,),),
            onTap: (){
              Navigator.pushNamed(context, "/Redemp");
            }
          )
        ],
      ),),
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

