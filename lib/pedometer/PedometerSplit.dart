import 'package:flutter/material.dart';
import 'dart:async';

import 'package:pedometer/pedometer.dart';
import 'locationSetting.dart';
import 'customDialog.dart';



class PedoCheck extends StatefulWidget {
  const PedoCheck({super.key});

  @override
  State<PedoCheck> createState() => PedoCheckState();
}

class PedoCheckState extends State<PedoCheck> {
  late Stream<StepCount> _stepCountStream;
  late Stream<PedestrianStatus> _pedestrianStatusStream;
  String _status = '?', _steps = '?';
  //The counter to check whether the position should be update to lastPos
  int counter = 0;
  //The counter to check whether the lastSteps should be update
  int stepCounter =0;
  //The timer to have a smooth update of step count
  Timer stepTimer = Timer(Duration(seconds: 1),(){});
  //totalSteps moved after starting the app
  int totalSteps = 0;
  //totalSteps presented in the screen
  int totalStepsInScreen = 0;
  //the last total Step walked (today?) retrieved from the pedometer api
  int lastSteps = 0;

  //in order to let it update the lastSteps for the first time
  bool shouldUpdateLastSteps = true;

  late locationSettings loc;
  locationSettings get getLoc => loc; //getter of loc for testing

  //check if it is the first time entering the app today? if yes, init the settings when starting
  bool firstEnter = true;

  //subscripts to cancel the event listener when stop
  late StreamSubscription stepSubscript;
  late StreamSubscription statusSubscript;
  late StreamSubscription locationSubscript;

  //multi start results in multi subscription in location stream, this avoid multi start and multi pause
  bool started = false;

  //since I may manually set the status to stop when user click stop button, I should use 
  //switchStatus to determine whether i should set the status back to walking
  bool switchStatus = false;


  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  Future<void> onStepCount(StepCount event) async {
    
    print('counting steps');

    //if the moving is true
      //add newSteps to the totalSteps
    //if the moving is false
      //if the stepCounter is equal to ten
        //update the last steps otherwise all the steps 
        //after opening the app will be recorded
    if(loc.moving && !shouldUpdateLastSteps){
      int newSteps = event.steps-lastSteps;
      stepTimer.cancel();

      setState(() {
        totalSteps+=newSteps;
        // print("totalSteps:$totalSteps");
        // print("totalStepsInScreen:$totalStepsInScreen");
        totalStepsInScreen = totalSteps;
        lastSteps = event.steps;
        stepCounter = 0;

      });
      
      stepTimer = Timer.periodic(Duration(milliseconds:500), (timer){
        if(_status == 'walking'){
          setState(() {
            // print('++');
            ++totalStepsInScreen;

          });
        }
      });

    }
    else{
      stepTimer.cancel();
      if(shouldUpdateLastSteps){
        shouldUpdateLastSteps = false;
        lastSteps = event.steps;
      }
      if(stepCounter == 10){
        lastSteps = event.steps;
        stepCounter = 0;
      }
      stepCounter++;
      
    }

  }

  void onPedestrianStatusChanged(PedestrianStatus event) {
    print('Pedo Status Change');
    print(event);
    setState(() {
      _status = event.status;
      loc.status = _status;
    });
  }

  void onPedestrianStatusError(error) {
    print('onPedestrianStatusError: $error');
    setState(() {
      _status = 'Pedestrian Status not available';
    });
    showDialog(
          barrierDismissible:false ,
          context: context, builder: (context) {
          return customDialog(OnPress: (){
            print(1);
            Navigator.pop(context);
            }, 
            context: context, buttonText: Text('Cancel',style: TextStyle(fontSize: 18,color: Color.fromRGBO(71, 128, 223, 1) ),), message: Text('There is something wrong with the localization or Pedestrian Status. You can try to restart the App, manually set the localization permission in your Settings or check if your pedometer in your phone is still usable',textAlign: TextAlign.center,style: TextStyle(fontSize: 16, overflow:TextOverflow.visible,fontWeight: FontWeight.w500,)));
        },);
    print(_status);
  }

  void onStepCountError(error) {
    print('onStepCountError: $error');
    setState(() {
      _steps = 'Step Count not available';
    });
    showDialog(
          barrierDismissible:false ,
          context: context, builder: (context) {
          return customDialog(OnPress: (){
            print(2);
            Navigator.pop(context);
            }, 
            context: context, buttonText: Text('Cancel',style: TextStyle(fontSize: 18,color: Color.fromRGBO(71, 128, 223, 1) ),), message: Text('There is something wrong with the localization or Pedestrian count. You can try to restart the App, manually set the localization permission in your Settings or check if your pedometer in your phone is still usable',textAlign: TextAlign.center,style: TextStyle(fontSize: 16, overflow:TextOverflow.visible,fontWeight: FontWeight.w500,)));
    },);
  }


  Future<void> initPlatformState() async {

    _pedestrianStatusStream = Pedometer.pedestrianStatusStream;


    statusSubscript = _pedestrianStatusStream
        .listen(onPedestrianStatusChanged);
    statusSubscript.onError(onPedestrianStatusError);
    statusSubscript.pause();

    loc = locationSettings(setParentState: setState, status: _status);
    // print('1');
    try{
      await loc.initialSettings(context);
    }catch(e){
      showDialog(
          barrierDismissible:false ,
          context: context, builder: (context) {
          return customDialog(OnPress: (){
            print(3);
            Navigator.pop(context);
            }, 
            context: context, buttonText: Text('Cancel',style: TextStyle(fontSize: 18,color: Color.fromRGBO(71, 128, 223, 1) ),), message: Text('It seems that there is something wrong with the localization. You can try to restart the App or manually set the localization permission in your Settings',textAlign: TextAlign.center,style: TextStyle(fontSize: 16, overflow:TextOverflow.visible,fontWeight: FontWeight.w500,)));
        },);
    }
    // print("object");
    

    // _stepCountStream = Pedometer.stepCountStream;
    // stepSubscript=_stepCountStream.listen(onStepCount);
    // stepSubscript.onError(onStepCountError);
    // stepSubscript.pause();

    // locationSubscript =loc.location.onLocationChanged.listen(loc.onLocationChange);
    // locationSubscript.onError((error){
    //     //When user doesnot "allow location checking forever", the error will occur
    //     //in this case, we should warn the user that their step won't update.
    //     print('Location Update Error: $error');
    //   }
    // );
    // locationSubscript.pause();
    
    if (!mounted) return;
  }

  void startListening(){
    if(!started){
      if(switchStatus){
        setState(() {
          _status = 'walking';
        });
        switchStatus = false;
      }
      

      // _pedestrianStatusStream = Pedometer.pedestrianStatusStream;
      // statusSubscript = _pedestrianStatusStream
      //     .listen(onPedestrianStatusChanged);
      // statusSubscript.onError(onPedestrianStatusError);
      statusSubscript.resume();

      _stepCountStream = Pedometer.stepCountStream;
      stepSubscript=_stepCountStream.listen(onStepCount);
      stepSubscript.onError(onStepCountError);
      // stepSubscript.pause();

      locationSubscript =loc.location.onLocationChanged.listen(loc.onLocationChange);
      locationSubscript.onError((error){
          //When user doesnot "allow location checking forever", the error will occur
          //in this case, we should warn the user that their step won't update.
          print('Location Update Error: $error');
          showDialog(
          barrierDismissible:false ,
          context: context, builder: (context) {
          return customDialog(OnPress: (){
            print(4);
            Navigator.pop(context);
            }, 
            context: context, buttonText: Text('Cancel',style: TextStyle(fontSize: 18,color: Color.fromRGBO(71, 128, 223, 1) ),), 
            message: Text('It seems that there is something wrong with the localization. You can try to restart the App or manually set the localization permission in your Settings',textAlign: TextAlign.center,style: TextStyle(fontSize: 16, overflow:TextOverflow.visible,fontWeight: FontWeight.w500,)));
        },);
        }
      );
      // locationSubscript.pause();
      started = true;
      if (!mounted) return;
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    stepTimer.cancel();
    loc.positionTimer.cancel();

  }

  @override
  Widget build(BuildContext context) {

          // build while testing
  //         return MaterialApp(home:Center(
  //         child: Column(
  //           mainAxisAlignment: MainAxisAlignment.center,
  //           children: <Widget>[
  //             Text(
  //               'Steps taken:',
  //               style: TextStyle(fontSize: 30),
  //             ),
  //             Text(
  //               totalStepsInScreen.toString(),
  //               style: TextStyle(fontSize: 60),
  //             ),
  //             Divider(
  //               height: 100,
  //               thickness: 0,
  //               color: Colors.white,
  //             ),
  //             Text(
  //               'Pedestrian status:',
  //               style: TextStyle(fontSize: 30),
  //             ),
  //             Icon(
  //               _status == 'walking'
  //                   ? Icons.directions_walk
  //                   : _status == 'stopped'
  //                       ? Icons.accessibility_new
  //                       : Icons.error,
  //               size: 100,
  //             ),
  //             Center(
  //               child: Text(
  //                 _status,
  //                 style: _status == 'walking' || _status == 'stopped'
  //                     ? TextStyle(fontSize: 30)
  //                     : TextStyle(fontSize: 20, color: Colors.red),
  //               ),
  //             ) ,
  //             Center(
  //               child: Text(
  //                 'Distance Walked: ${loc.totalDist}',
  //                 style: TextStyle(fontSize: 30),
  //               ),
  //             ),
  //             Row(
  //               mainAxisAlignment: MainAxisAlignment.spaceAround,
  //               children: [
  //                 ElevatedButton(onPressed: (){
  //                   print('START');
  //                   startListening();
  //                 }, child: Text('Start', style: TextStyle(fontSize: 20),)),
  //                 ElevatedButton(onPressed: (){
  //                     print("STOP");
  //                     if(started){
  //                       statusSubscript.pause();
  //                       stepSubscript.cancel();
  //                       locationSubscript.cancel();
  //                       setState(() {
  //                         if(_status == 'walking'){
  //                           _status = 'stopped';
  //                           switchStatus = true;
  //                         }
  //                         shouldUpdateLastSteps = true;
  //                         started = false;

  //                       });
  //                     }
  //                 }, child: Text('Stop', style: TextStyle(fontSize: 20),))

  //               ],
  //             ),
              
  //           ],
  //         ),
  //       ));
  // }
    return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Steps taken:',
                style: TextStyle(fontSize: 30),
              ),
              Text(
                totalStepsInScreen.toString(),
                style: TextStyle(fontSize: 60),
              ),
              Divider(
                height: 100,
                thickness: 0,
                color: Colors.white,
              ),
              Text(
                'Pedestrian status:',
                style: TextStyle(fontSize: 30),
              ),
              Icon(
                _status == 'walking'
                    ? Icons.directions_walk
                    : _status == 'stopped'
                        ? Icons.accessibility_new
                        : Icons.error,
                size: 100,
              ),
              Center(
                child: Text(
                  _status,
                  style: _status == 'walking' || _status == 'stopped'
                      ? TextStyle(fontSize: 30)
                      : TextStyle(fontSize: 20, color: Colors.red),
                ),
              ) ,
              Divider(
                height: 20,
                thickness: 0,
                color: Colors.white,
              ),
              Center(
                child: 
                Column(
                  children: [Text('Distance Walked:',style: TextStyle(fontSize: 30),),
                  Text('${loc.totalDist.toStringAsFixed(1)}m',style: TextStyle(fontSize: 30),)
                ],
                )
                
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(onPressed: (){
                    print('START');

                    startListening();
                  }, child: Text('Start', style: TextStyle(fontSize: 20),)),
                  ElevatedButton(onPressed: (){
                      print("STOP");
                      if(started){
                        statusSubscript.pause();
                        stepSubscript.cancel();
                        locationSubscript.cancel();
                        setState(() {
                          if(_status == 'walking'){
                            _status = 'stopped';
                            switchStatus = true;
                          }
                          shouldUpdateLastSteps = true;
                          started = false;

                        });
                      }
                  }, child: Text('Stop', style: TextStyle(fontSize: 20),))

                ],
              ),
              
            ],
          ),
        );
  }
}