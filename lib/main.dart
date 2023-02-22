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







import 'package:flutter/material.dart';
import 'home.dart';


String formatDate(DateTime d) {
  return d.toString().substring(0, 19);
  
}





void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Home(),
    );
  }
}


