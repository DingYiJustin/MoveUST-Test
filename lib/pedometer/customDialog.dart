import 'dart:io';

import 'package:flutter/material.dart';
import '../app_theme.dart';

/**
 * Dialog for require location permission
 */

class customDialog extends StatelessWidget {
  customDialog({super.key,required this.onPress, required this.context, this.horizontalPadding, this.verticalPadding, this.buttonText = const Text('Set permission', style:AppTheme.customDialogButton,), this.message= const Text('The app needs permenant location permission to validate your steps in background', textAlign: TextAlign.center, softWrap: true,style: AppTheme.customDialogMessage)} );
  late Function onPress;
  late BuildContext context;
  late double? horizontalPadding;
  late double? verticalPadding;
  late Text buttonText;
  late Text message;


  @override
  Widget build(BuildContext context) {
    horizontalPadding = (horizontalPadding==null)?MediaQuery.of(context).size.width*0.2:horizontalPadding;
    verticalPadding = (verticalPadding == null)?MediaQuery.of(context).size.height*0.3:verticalPadding;
    print(horizontalPadding);
    print(MediaQuery.of(context).size.height);
    print(MediaQuery.of(context).size.width);
    return 
    Material(
    color: const Color.fromARGB(0, 255, 255, 255),
    child:Container(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding!, vertical:verticalPadding!),
      child: Container(
        decoration: BoxDecoration(color: const Color.fromARGB(245, 250, 250, 250),
        borderRadius: BorderRadius.circular(10)
        ),
          child:
          Stack(
            children: [
            
            Align(
              alignment: Alignment.topRight,
              child:IconButton(icon: const Icon(Icons.close_rounded), onPressed: () {  
                    Navigator.pop(context);
            },),),
            Positioned(
              bottom: MediaQuery.of(context).size.height*0.09,
              height: MediaQuery.of(context).size.height*0.16,
              width:(MediaQuery.of(context).size.width-2*horizontalPadding!)*1 ,
                child:
                Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.symmetric(horizontal:MediaQuery.of(context).size.width*0.02), 
                  child: message,
                  ),
            ), 
            Positioned(
              bottom: MediaQuery.of(context).size.height*0.03,
              child: 
              Container(
                  margin: EdgeInsets.symmetric(vertical: (MediaQuery.of(context).size.height-2*verticalPadding!)*0.02),
                  decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 250, 250, 250),
                    border: Border.symmetric(horizontal: BorderSide(color: Colors.black38))),
                  height: (MediaQuery.of(context).size.height-2*verticalPadding!)*0.1,
                  width: (MediaQuery.of(context).size.width-2*horizontalPadding!)*1,
                  child: 
                  InkWell(

                    hoverColor: Colors.grey,
                    
                    // color: Color.fromARGB(255, 239, 239, 239),
                    child: Center(child: buttonText,) ,
                    onTap: () {
                    onPress();
                   },
                  ),

                ),
              ),
            ],
          )
          
        )),
        
    );
  }
}