import 'package:flutter/material.dart';

class MyGridView extends StatelessWidget {
  const MyGridView({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    //

    return Stack( children: [
      Positioned(
        top: 20,
        child: Container(
        width: MediaQuery.of(context).size.width,
        height: 100,
        alignment: Alignment.center,
        color: Colors.amberAccent, child: Text('second guider area'),))
      ,
      GridView.builder(gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2,mainAxisSpacing: 10,crossAxisSpacing: 10), itemBuilder: (context, index){
      return Container(
        alignment: Alignment.center,
        decoration: BoxDecoration( 
          border: Border.all(color: Colors.amber),
          borderRadius: BorderRadius.circular(10)
        ),
        child: Text("I am the ${index}th Grid"),
      );
    }, itemCount: null,)]);

    // return Container(padding:EdgeInsets.all(10), child: GridView.builder(gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2,mainAxisSpacing: 10,crossAxisSpacing: 10), itemBuilder: (context, index){
    //   return Container(
    //     alignment: Alignment.center,
    //     decoration: BoxDecoration( 
    //       border: Border.all(color: Colors.amber),
    //       borderRadius: BorderRadius.circular(10)
    //     ),
    //     child: Text("I am the ${index}th Grid"),
    //   );
    // }, itemCount: null,));




    //maxCrossAxisExtent (横轴子元素的最大长度)
    // return GridView.extent(maxCrossAxisExtent: 40,children: [
    //   Icon(Icons.access_alarm_rounded),
    //   Icon(Icons.access_alarm_rounded),
    //   Icon(Icons.access_alarm_rounded),
    //   Icon(Icons.access_alarm_rounded),
    //   Icon(Icons.access_alarm_rounded),
    //   Icon(Icons.access_alarm_rounded),
    //   Icon(Icons.access_alarm_rounded),
    //   Icon(Icons.access_alarm_rounded),
    //   Icon(Icons.access_alarm_rounded),
    //   Icon(Icons.access_alarm_rounded),
    //   Icon(Icons.access_alarm_rounded),
    //   Icon(Icons.access_alarm_rounded),
    //   Icon(Icons.access_alarm_rounded),
    //   Icon(Icons.access_alarm_rounded),Icon(Icons.access_alarm_rounded),
    //   Icon(Icons.access_alarm_rounded),
    //   Icon(Icons.access_alarm_rounded),
    //   Icon(Icons.access_alarm_rounded),
    //   Icon(Icons.access_alarm_rounded),
    //   Icon(Icons.access_alarm_rounded),
    //   Icon(Icons.access_alarm_rounded),Icon(Icons.access_alarm_rounded),
    //   Icon(Icons.access_alarm_rounded),
    //   Icon(Icons.access_alarm_rounded),
    //   Icon(Icons.access_alarm_rounded),
    //   Icon(Icons.access_alarm_rounded),
    //   Icon(Icons.access_alarm_rounded),
    //   Icon(Icons.access_alarm_rounded),]);



    //crossAxisCount一行有多少个子元素
    // return GridView.count(crossAxisCount: 6,children: [
    //   Icon(Icons.access_alarm_rounded),
    //   Icon(Icons.access_alarm_rounded),
    //   Icon(Icons.access_alarm_rounded),
    //   Icon(Icons.access_alarm_rounded),
    //   Icon(Icons.access_alarm_rounded),
    //   Icon(Icons.access_alarm_rounded),
    //   Icon(Icons.access_alarm_rounded),
    //   Icon(Icons.access_alarm_rounded),
    //   Icon(Icons.access_alarm_rounded),
    //   Icon(Icons.access_alarm_rounded),
    //   Icon(Icons.access_alarm_rounded),
    //   Icon(Icons.access_alarm_rounded),
    //   Icon(Icons.access_alarm_rounded),
    //   Icon(Icons.access_alarm_rounded),Icon(Icons.access_alarm_rounded),
    //   Icon(Icons.access_alarm_rounded),
    //   Icon(Icons.access_alarm_rounded),
    //   Icon(Icons.access_alarm_rounded),
    //   Icon(Icons.access_alarm_rounded),
    //   Icon(Icons.access_alarm_rounded),
    //   Icon(Icons.access_alarm_rounded),Icon(Icons.access_alarm_rounded),
    //   Icon(Icons.access_alarm_rounded),
    //   Icon(Icons.access_alarm_rounded),
    //   Icon(Icons.access_alarm_rounded),
    //   Icon(Icons.access_alarm_rounded),
    //   Icon(Icons.access_alarm_rounded),
    //   Icon(Icons.access_alarm_rounded),

    // ],);
  }
}
