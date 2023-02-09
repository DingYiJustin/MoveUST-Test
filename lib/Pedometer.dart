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
  late Position lastPos;
  bool moving = false;
  Timer positionTimer = Timer(Duration(days: 1), (){});
  int totalSteps = 0;
  int lastSteps = 0;
  

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

  void onStepCount(StepCount event) {
    //如果moving是true的话，
      //减去上次stepcount的数字
      //将增加的数字赋值到总到步数上
      //将这次stepcount到数字赋值到_step上
    //如果moving是false
      //将这次stepcount到数字赋值到_step上
    if(moving){
      int newSteps = event.steps-lastSteps;
      setState(() {
        totalSteps+=newSteps;
        lastSteps = event.steps;

      });
    }
    else{
      lastSteps = event.steps;
    }

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

  Future<void> initPlatformState() async {
    _pedestrianStatusStream = Pedometer.pedestrianStatusStream;
    _pedestrianStatusStream
        .listen(onPedestrianStatusChanged)
        .onError(onPedestrianStatusError);

    _stepCountStream = Pedometer.stepCountStream;
    _stepCountStream.listen(onStepCount).onError(onStepCountError);

    
    lastPos = await _determinePosition();
    StreamSubscription<Position> positionStream = Geolocator.getPositionStream(locationSettings: locationSettings).listen(
        (Position? position) {
            if(position == null){
              print('position is null');
              return;
            }
            var p = 0.017453292519943295;
            var c = cos;
            var a = 0.5 - c((position.latitude - lastPos.latitude) * p)/2 + 
                  c(lastPos.latitude * p) * c(position.latitude * p) * 
                  (1 - c((position.longitude - lastPos.longitude) * p))/2;
            var dist = 12742 * asin(sqrt(a))*1000;
            lastPos = position;
            
            print(dist);
            if(dist >= 10){
              //API检测distacnce的有问题，使用ios bestnavigator最好检测精度在十以上
              print('distance:$dist');

              print('Location is updating:');
              positionTimer.cancel();
              if(!moving){
                moving = true;
              }
              positionTimer = Timer.periodic(Duration(seconds: 5),(timer){
                if(moving){
                  moving=false;
                }
                else{
                  timer.cancel();
                }
              });
              print(position == null ? 'Unknown' : '${position.latitude.toString()}, ${position.longitude.toString()}');
            }
        });
        positionStream.onError((error){
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