// import 'package:flutter/material.dart';
// import 'package:flutter_application_1/Wrap.dart';
// import 'fonts.dart';
// import 'ListView.dart';
// import 'GridView.dart';

// void main(List<String> args) {
//   runApp(MaterialApp(
//     home: Scaffold(
      
//       drawer: const Drawer(
//         backgroundColor: Colors.amber),
//       appBar: AppBar(
//         // leading: Icon(Icons.select_all_outlined),
//         title: const Text('hello flutter'),
//       ),
//       body:MyWrap() // ListView(children: const [MyApp(), Mybtn(), ],) ,
//     ),
//   ));
// }

// class MyApp extends StatelessWidget{
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     // TODO: implement build
//     return Center(
//         child: Container(
//             alignment: Alignment.center, //配置容器内元素的å方位
//             width: 200,
//             height:200,
//             decoration: const BoxDecoration(color: Colors.amber),
//             child: const Text('first app, i am a widget haha')));
//   }
// }


// class Mybtn extends StatelessWidget{
//   const Mybtn({super.key});

//   @override
//   Widget build(BuildContext context) {
//     // TODO: implement build
//     return Container(
      
//       transform: Matrix4.translationValues(-20, 0, 0),
//       alignment: Alignment.center,
//       width: 200,
//       height: 40,
//       margin: const EdgeInsets.all(8),
//       decoration: BoxDecoration(
//         color:Colors.blueGrey,
//         borderRadius: BorderRadius.circular(10)
//        ),
//       child: const Icon(PersonalizedFont.book, color: Colors.amber, size: 40,),);
//   }

// }







import 'dart:convert';

import 'package:flutter/material.dart';
import 'home.dart';

import 'package:flutter/services.dart';
import 'RedemptionPage/Redemption_Page.dart';



String formatDate(DateTime d) {
  return d.toString().substring(0, 19);
  
}





void main() {
  //disable the rotation of the screen
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
    .then((_) {
      runApp(MyApp());
    });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // home: Home(),
      initialRoute: '/',
      routes: {
        // When navigating to the "/" route, build the FirstScreen widget.
        '/': (context) => const Home(),
        // When navigating to the "/second" route, build the SecondScreen widget.
        '/Redemp': (context) => RedemptionPage(data: jsonEncode({
                                "redemptionList":[
                                {
                                "user_id" : "0001",
                                "redemption_time": "2019-09-26T16:17:24+05:00",
                                "point": "500"
                                },
                                {
                                "user_id" : "0002",
                                "redemption_time": "2019-09-26T16:17:24+05:00",
                                "point": "100"
                                }
                                ]
                                })),
      },
    );
  }
}


