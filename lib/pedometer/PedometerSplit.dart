import 'package:flutter/material.dart';
import 'dart:async';

import 'package:pedometer/pedometer.dart';
import 'locationSetting.dart';



class PedoCheck extends StatefulWidget {
  const PedoCheck({super.key});

  @override
  State<PedoCheck> createState() => _PedoCheckState();
}

class _PedoCheckState extends State<PedoCheck> {
  late Stream<StepCount> _stepCountStream;
  late Stream<PedestrianStatus> _pedestrianStatusStream;
  String _status = '?', _steps = '?';
  //The counter to check whether the position should be update to lastPos
  int counter = 0;
  //The counter to check whether the lastSteps should be update
  int stepCounter =0;
  //The timer to have a smooth update of step count
  Timer stepTimer = Timer(Duration(days: 1),(){});
  //totalSteps moved after starting the app
  int totalSteps = 0;
  //totalSteps presented in the screen
  int totalStepsInScreen = 0;
  //the last total Step walked (today?) retrieved from the pedometer api
  int lastSteps = 0;

  //in order to let it update the lastSteps for the first time
  bool shouldUpdateLastSteps = true;

  late locationSettings loc;

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
    print(_status);
  }

  void onStepCountError(error) {
    print('onStepCountError: $error');
    setState(() {
      _steps = 'Step Count not available';
    });
  }


  Future<void> initPlatformState() async {
    loc = locationSettings(setParentState: setState, status: _status);
    await loc.initalSettings(context);

    _pedestrianStatusStream = Pedometer.pedestrianStatusStream;
    statusSubscript = _pedestrianStatusStream
        .listen(onPedestrianStatusChanged);
    statusSubscript.onError(onPedestrianStatusError);
    statusSubscript.pause();

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
        }
      );
      // locationSubscript.pause();
      started = true;
      if (!mounted) return;
    }
  }

  @override
  Widget build(BuildContext context) {
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
              Center(
                child: Text(
                  'Distance Walked: ${loc.totalDist}',
                  style: TextStyle(fontSize: 30),
                ),
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