import 'package:flutter/material.dart';

class MyListView extends StatelessWidget {
  MyListView({super.key}){
    for(int i = 0; i<20; i++){
      list.add(
        "I am $i th data"
      );
    }
  }
  List<String> list=[];

  List<Widget> _initListData(){
    List<Widget> list = [];
    for(int i = 0; i<20; i++){
      list.add(
        Container(
          padding: EdgeInsets.all(8),
          height: 40,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black)),
          child: Text('i am $i container'),
          
        )
      );
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

  //动态列表


  // return ListView(
  //   children: _initListData(),
  // );

  return ListView.builder(itemCount: list.length,itemBuilder: (context,index){
    return Container(child: Text(list[index]),);
  });
  }



  //静态列表
  //   return SizedBox(height:120, child: ListView(
  //     scrollDirection: Axis.horizontal,
  //     padding: const EdgeInsets.all(8),
  //     children: <Widget>[
  //       // ListTile(
  //       //   leading: Icon(Icons.home),
  //       //   title: Text('Home'),),
  //       // Divider(),
  //       // ListTile(
  //       //   leading: Icon(Icons.payment, color: Colors.green,),
  //       //   title: Text('payment'),),
  //       // Divider(),
  //       // ListTile(
  //       //   leading: Icon(Icons.assignment, color: Colors.red,),
  //       //   title: Text('All Order'),
  //       //   trailing: Icon(Icons.chevron_right_outlined),
  //       //   ),
  //       // Divider(),
        


  //       Container(
  //         width: 120,
  //         decoration: const BoxDecoration(
  //           color: Colors.red
  //         ),
  //       ),
  //       Container(
  //         width: 120,
  //         decoration: const BoxDecoration(
  //           color: Colors.amber
  //         ),
  //       ),        Container(
  //         width: 120,
  //         decoration: const BoxDecoration(
  //           color: Colors.yellow
  //         ),
  //       ),        Container(
  //         width: 120,
  //         decoration: const BoxDecoration(
  //           color: Colors.blue
  //         ),
  //       ),        Container(
  //         width: 120,
  //         decoration: const BoxDecoration(
  //           color: Colors.blueAccent
  //         ),
  //       ),

  //     ],
  //   ));
  // }

}