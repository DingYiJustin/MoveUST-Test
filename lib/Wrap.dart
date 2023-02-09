import 'package:flutter/material.dart';

class MyWrap extends StatelessWidget {
  const MyWrap({super.key});

  List<Widget> generateBtns(){
    List<Widget> returned = [];
    for(int i = 0; i< 100; i++){
      returned.add(ContextBtn("BTN $i", onpress: (){}));
    }
    return returned;
  }


  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    return Padding( 

      padding: EdgeInsets.all(10),
      child:Wrap(
      alignment: WrapAlignment.spaceAround,
      direction: Axis.horizontal,
      spacing: 2,
      runSpacing: 10,
      children: generateBtns(),
    ));
  }

}


class ContextBtn extends StatelessWidget{
  String text;
  void Function()? onpress;

  ContextBtn(this.text,{super.key, required this.onpress});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return ElevatedButton(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(Colors.black12),
        foregroundColor: MaterialStateProperty.all(Colors.black54)
      ),
      onPressed: onpress, child: Text(text));
  }

}

