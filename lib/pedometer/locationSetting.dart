import 'dart:async';
// import 'dart:js';
// import 'dart:js';

import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'dart:math' show cos, sqrt, asin;
import 'package:permission_handler/permission_handler.dart' as pm;


class locationSettings{

  locationSettings({required this.setParentState, required this.status});

  late Function setParentState;
  //The last previous position updated
  late LocationData lastPos;
  //the last position recorded
  late LocationData prePos;
  //the totalDistance the user traveled since last update
  double totalDist = 0;
  //the totalDistance since last position (lastPos) update
  double totalDistSinceLastUpdate = 0; 
  //determined whether the user have moved distance recorded since last position (lastPos) update
  bool moved = false;
  //If the position is 30 meters away compared to the last position, the moving is true
  bool moving = false; 

  late Location location;

  late String status;

  Timer positionTimer = Timer(const Duration(seconds: 1), (){});

  Future<void> initalSettings(BuildContext context) async {
    lastPos = await _getPermission(context);
    prePos = lastPos;
    print('init prePos');
    location.enableBackgroundMode(enable: true);
    return;

  }

  // void test(){
  //   throw Exception('aaa');
  // }
  
  Future<LocationData> _getPermission(BuildContext context) async{
    // test();

    if(await pm.Permission.location.isPermanentlyDenied){
          showDialog(
            barrierDismissible:false ,
            context: context, builder: (context) {
            return Container(
              padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width*0.2, vertical: MediaQuery.of(context).size.height*0.3),
              child: Container(
                decoration: BoxDecoration(color: Colors.white,
                borderRadius: BorderRadius.circular(10)
                ),
                  child:Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [Container(padding: EdgeInsets.all(MediaQuery.of(context).size.width*0.02), child: Text('The app needs permenant location permission to validate your steps in background',textAlign: TextAlign.center,),),
                    ElevatedButton(onPressed: (){
                      pm.openAppSettings();
                      Navigator.pop(context);

                    }, child: Text('Set Permission') )
                  ],)
                )
                
            );
          },);
    }

    location = new Location();
    bool _serviceEnabled;
    bool _serviceAlwaysEnabled;
    pm.PermissionStatus _permissionGranted;
    LocationData _locationData;


    _serviceAlwaysEnabled =await pm.Permission.locationAlways.isGranted;
    if(!_serviceAlwaysEnabled){
      _serviceEnabled = await pm.Permission.locationWhenInUse.isGranted;
      if(!_serviceEnabled){
        _serviceEnabled = await pm.Permission.locationWhenInUse.request().isGranted;
      }

      if(_serviceEnabled){
        _serviceAlwaysEnabled = await pm.Permission.locationAlways.request().isGranted;
        if(!_serviceAlwaysEnabled){
          print('no alway');
          // The user opted to never again see the permission request dialog for this
          // app. The only way to change the permission's status now is to let the
          // user manually enable it in the system settings.
          showDialog(
            barrierDismissible:false ,
            context: context, builder: (context) {
            return Container(
              padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width*0.2, vertical: MediaQuery.of(context).size.height*0.3),
              child: Container(
                decoration: BoxDecoration(color: Colors.white,
                borderRadius: BorderRadius.circular(10)
                ),
                  child:Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [Container(padding: EdgeInsets.all(MediaQuery.of(context).size.width*0.02), child: Text('The app needs permenant location permission to validate your steps in background',textAlign: TextAlign.center,),),
                    ElevatedButton(onPressed: (){
                      pm.openAppSettings();
                      Navigator.pop(context);

                    }, child: Text('Set Permission') )
                  ],)
                )
                
            );
          },);

          // return Future.error('Location permissions are denied');

        }
      }
      else{
        print('no in use');
        showDialog(
            barrierDismissible:false ,
            context: context, builder: (context) {
            return Container(
              padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width*0.2, vertical: MediaQuery.of(context).size.height*0.3),
              child: Container(
                decoration: BoxDecoration(color: Colors.white,
                borderRadius: BorderRadius.circular(10)
                ),
                  child:Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [Container(padding: EdgeInsets.all(MediaQuery.of(context).size.width*0.02), child: Text('The app needs permenant location permission to validate your steps in background',textAlign: TextAlign.center,),),
                    ElevatedButton(onPressed: (){
                      pm.openAppSettings();
                      Navigator.pop(context);

                    }, child: Text('Set Permission') )
                  ],)
                )
                
            );
          },);
        // return Future.error('Location permissions are denied');
      }
    }

    return _locationData = await location.getLocation();
    
  }

  // calculate the distance between to lat lon location
  double convertLatLonToDistance(LocationData position, LocationData lastPos){
    var p = 0.017453292519943295;
            var c = cos;
            var a = 0.5 - c((position.latitude! - lastPos.latitude!) * p)/2 + 
                  c(lastPos.latitude! * p) * c(position.latitude! * p) * 
                  (1 - c((position.longitude! - lastPos.longitude!) * p))/2;
            var dist = 12742 * asin(sqrt(a))*1000;
    return dist;
            
  }

  void onLocationChange(LocationData position) {
      // Use current location
      if(position.latitude == null || position.longitude==null){
        print('position is null');
        return;
      }
      print('current accuracy: ${position.accuracy}');
      //change lat lon location distance to distance in meters
      double distToPre = convertLatLonToDistance(position, prePos);

      //if the user is moving right now, add the distance from last position(prePos) to the total distance 
      if(moving){
        if(status == 'walking'){
          setParentState(() {
            totalDist+=distToPre;
          });
        }
      }
      //calculate the total distance moved since lastPos update
      totalDistSinceLastUpdate+=distToPre;
        

      //if the distance between the last recorded position and the current position is bigger than 4, 
      //we update the lastPos to prevent that the distance away exceed 40 after several calls when not moving
      print("distToPre1:$distToPre");
      print('current position: lat: ${position.latitude} lon:${position.longitude}');
      print('pre position: lat: ${prePos.latitude} lon:${prePos.longitude}');

      if(distToPre >= 5.0 && !moving){
          distToPre = 0;
          double dist = convertLatLonToDistance(position, lastPos);
          print("total distance before update $dist");
          print('Update LAST POSITION');
          lastPos = position;
          // print('last position: lat: ${lastPos.latitude} lon:${lastPos.longitude}');
          totalDistSinceLastUpdate=0;
          //Since the steps and totalDist still update when moving is true,
          //the moved is set to false to allow totalDist update by totalDistSinceLast Update only when moving is false
          moved = false;
      }

      prePos = position;


      double dist = convertLatLonToDistance(position, lastPos);
        
      print('totalDist:$dist');


      //if distance away is greater than 30, we assume that the user is truely walking
      //then we set the moving to true and set the timer
      //already tested 20 can be panetrated
      if(dist >= 30){
        lastPos = position;
        distToPre = 0;
        if(!moved){
          setParentState(() {
            totalDist+=totalDistSinceLastUpdate;
            print("UPATE WITH TOTALDISTSINCELASTUPDATE: $totalDist");

          });
        }
        totalDistSinceLastUpdate = 0;

        print('Location is updating:');
        positionTimer.cancel();
        if(!moving){
          moving = true;
        }
        //Since during moving the totalDist is updated by disToPre, we should set the moved to true
        moved = true;

        //timer to set the moving value to false after 25 seconds.
        positionTimer = Timer.periodic(Duration(seconds: 25),(timer){
          if(moving){
            moving=false;
            timer.cancel();
            totalDistSinceLastUpdate=0;
            moved = false;
          }
          else{
            timer.cancel();
          }
        });
      }
    }

}