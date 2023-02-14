import 'package:flutter/material.dart';
import 'dart:async';

import 'package:pedometer/pedometer.dart';
import 'package:geolocator/geolocator.dart';

import 'dart:math' show cos, sqrt, asin;


class PedoCheck extends StatefulWidget {
  const PedoCheck({super.key});

  @override
  State<PedoCheck> createState() => _PedoCheckState();
}

class _PedoCheckState extends State<PedoCheck> {
  late Stream<StepCount> _stepCountStream;
  late Stream<PedestrianStatus> _pedestrianStatusStream;
  String _status = '?', _steps = '?';
  //The last previous position updated
  late Position lastPos;
  //If the position is 40 meters away compared to the last position, the moving is true
  bool moving = false; 
  //The counter to check whether the position should be update to lastPos
  int counter = 0;
  //The counter to check whether the lastSteps should be update
  int stepCounter =0;
  //The timer to set the moving to false after it has been set to true
  Timer positionTimer = Timer(Duration(days: 1), (){});
  //totalSteps moved after starting the app
  int totalSteps = 0;
  //the last total Step walked (today?) retrieved from the pedometer api
  int lastSteps = 0;

  bool shouldUpdateLastSteps = true;

  double lastDist = 0;
  //the last position recorded
  late Position prePos;
  //the totalDistance the user traveled since last update
  double totalDistSinceLastUpdate = 0;
  

  final LocationSettings locationSettings =  const LocationSettings(
      accuracy: LocationAccuracy.bestForNavigation,
      distanceFilter: 0,
    );
  /// Determine the current position of the device.
  ///
  /// When the location services are not enabled or permissions
  /// are denied the `Future` will return an error.
  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the 
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale 
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }
    
    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately. 
      return Future.error(
        'Location permissions are permanently denied, we cannot request permissions.');
    } 

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.best);
  }

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  Future<void> onStepCount(StepCount event) async {
    //如果moving是true的话，
      //减去上次stepcount的数字
      //将增加的数字赋值到总到步数上
      //将这次stepcount到数字赋值到_step上
    //如果moving是false
      //将这次stepcount到数字赋值到_step上
    print('counting steps');

    //if the moving is true
      //add newSteps to the totalSteps
    //if the moving is false
      //if the stepCounter is equal to ten
        //update the last steps otherwise all the steps 
        //after opening the app will be recorded
    if(moving){
      int newSteps = event.steps-lastSteps;
      setState(() {
        totalSteps+=newSteps;
        lastSteps = event.steps;
        stepCounter = 0;

      });
    }
    else{
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

    // Position position = await _determinePosition();
    // double dist = convertLatLonToDistance(position, lastPos);
    // print(dist);
    // if(dist>=5){
    //   print('the position is updating:'+dist.toString());
    //   int newSteps = event.steps-lastSteps;
    //   setState(() {
    //     totalSteps+=newSteps;
    //     lastSteps = event.steps;
    //     lastPos = position;

    //   });
    // }
    // else{
    //   lastSteps = event.steps;
    // }

    // print(event);
    // setState(() {
    //   _steps = event.steps.toString();
    // });
  }

  void onPedestrianStatusChanged(PedestrianStatus event) {
    print(event);
    setState(() {
      _status = event.status;
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


  double convertLatLonToDistance(Position position, Position lastPos){
    var p = 0.017453292519943295;
            var c = cos;
            var a = 0.5 - c((position.latitude - lastPos.latitude) * p)/2 + 
                  c(lastPos.latitude * p) * c(position.latitude * p) * 
                  (1 - c((position.longitude - lastPos.longitude) * p))/2;
            var dist = 12742 * asin(sqrt(a))*1000;
    return dist;
            
  }

  Future<void> initPlatformState() async {
    lastPos = await _determinePosition();
    prePos = lastPos;

    _pedestrianStatusStream = Pedometer.pedestrianStatusStream;
    _pedestrianStatusStream
        .listen(onPedestrianStatusChanged)
        .onError(onPedestrianStatusError);

    _stepCountStream = Pedometer.stepCountStream;
    _stepCountStream.listen(onStepCount).onError(onStepCountError);

    
    //positionStream to determine whether the user is moving
    StreamSubscription<Position> positionStream = Geolocator.getPositionStream(locationSettings: locationSettings).listen(
        (Position? position) {
            if(position == null){
              print('position is null');
              return;
            }

            //change lat lon location distance to distance in meters
              // double dist = convertLatLonToDistance(position, lastPos);
              // print('last distance:$lastDist');
            
            //change lat lon location distance to distance in meters
              double distToPre = convertLatLonToDistance(position, prePos);

              prePos = position;

            //if the distance between the last recorded position and the current position is bigger than 4, 
            //we update the lastPos to prevent that the distance away exceed 40 after several calls when not moving
              print("distToPre1:$distToPre");
              if(distToPre >= 4.0){
                  print('distToPre2:$distToPre');
                  totalDistSinceLastUpdate=0;
                  distToPre = 0;
                  print('Update LAST POSITION');
                  lastPos = position;
              }

              totalDistSinceLastUpdate+=distToPre;
              print("distToPre3:$distToPre");
              print('totalDist:$totalDistSinceLastUpdate');


            //if distance update cross bigger than 3 or -3 , we update the lastPos 
            //to prevent that the distance away exceed 40 after several calls when not moving
              // if((dist - lastDist)>=3 ||(dist - lastDist)<-3 ){
              //   print('distance:$dist');
              //   print('last distance:$lastDist');
              //   dist = 0;
              //   print('Update LAST POSITION');
              //   lastPos = position;
              // }
              // lastDist = dist;
            
            //if counter is equals to 35, we update the lastPos 
            //to prevent that the distance away exceed 40 meters when not moving
              // if(counter == 35){
              //   lastPos = position;
              //   print('UPDATE LAST POSITIOn');
              //   counter = 1;
              // }
              // else{
              //   counter++;
              // }
            // print('counter:'+counter.toString());
            // print('currentLastPosition:'+lastPos.latitude.toString()+','+lastPos.longitude.toString());
            // print("currentPosition:"+position.latitude.toString()+","+position.longitude.toString());
            // print(dist);

            //if distance away is greater than 40, we assume that the user is truely walking
            //then we set the moving to true and set the timer
            //if(dist >= 40){
            if(totalDistSinceLastUpdate>=40){
              lastDist = 0;
              lastPos = position;
              distToPre = 0;
              totalDistSinceLastUpdate = 0;
              //API检测distacnce的有问题，使用ios bestnavigator最好检测精度在十以上
              //print('distance:$dist');

              print('Location is updating:');
              positionTimer.cancel();
              if(!moving){
                moving = true;
              }
              positionTimer = Timer.periodic(Duration(seconds: 30),(timer){
                if(moving){
                  moving=false;
                  timer.cancel();
                }
                else{
                  timer.cancel();
                }
              });
              print(position == null ? 'Unknown' : '${position.latitude.toString()}, ${position.longitude.toString()}');
            }
        });
        positionStream.onError((error){
          //When user doesnot allow location checking forever, the error will occur
          //in this case, we should warn the user that their step won't update.
          shouldUpdateLastSteps = true;
          print('Location Update Error: $error');
        });
    
    if (!mounted) return;
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
                totalSteps.toString(),
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
              )
            ],
          ),
        );
  }
}