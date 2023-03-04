import 'dart:async';
// import 'dart:js';
// import 'dart:js';

import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'dart:math' show cos, sqrt, asin;
import 'package:permission_handler/permission_handler.dart' as pm;
import 'customDialog.dart';


class locationSettings{

  locationSettings({required this.setParentState, required this.status});

  late Function setParentState;
  //The last previous position updated
  late LocationData lastPos;
  //the last position recorded
  LocationData? prePos = null;
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

  Future<void> initialSettings(BuildContext context) async {
    //check if getPermission throws an error, if yes, throw the error again
    try{
      lastPos = await _getPermission(context);
      prePos = lastPos;
      print('init prePos');
      location.enableBackgroundMode(enable: true);
    }catch(e){
      return Future.error('cannot retrieve location data');
    }
    return;

  }
  
  /**
   * The function to request for permissions for localization 
   */
  Future<LocationData> _getPermission(BuildContext context) async{
    // test();
    location = new Location();
    bool _serviceEnabled;
    bool _serviceAlwaysEnabled;
    pm.PermissionStatus _permissionGranted;
    LocationData _locationData;
    try{

      //check if the localization permission has been permanently denied by the user
      if(await pm.Permission.location.isPermanentlyDenied){

        //show dialog to let user manually set the permission if he/she permanently denied
        await showDialog(
          barrierDismissible:false ,
          context: context, builder: (context) {
          return customDialog(OnPress: (){
            pm.openAppSettings();
            }, 
            context: context);
        },);

        //check if the user changed the permission, if no, throw an error
        if(await pm.Permission.location.isPermanentlyDenied){
          print('cannot');
          return Future.error('cannot retrieve location');
        }
      }

      

      //check if the user set the permission to Always
      _serviceAlwaysEnabled =await pm.Permission.locationAlways.isGranted;
      if(!_serviceAlwaysEnabled){
        //if not always, check if the permission is whenInUse
        _serviceEnabled = await pm.Permission.locationWhenInUse.isGranted;
        if(!_serviceEnabled){
          //if not whenInUse, request for whenInUse so that we can request for permanent
          _serviceEnabled = await pm.Permission.locationWhenInUse.request().isGranted;
        }

        //check if the permission is whenInUse or Only once now
        if(_serviceEnabled){
          //if yes, request for permanent permission
          _serviceAlwaysEnabled = await pm.Permission.locationAlways.request().isGranted;
          //if request failed, use dialog to let user manually set the permission
          if(!_serviceAlwaysEnabled){
            // print('no alway');
            // The user opted to never again see the permission request dialog for this
            // app. The only way to change the permission's status now is to let the
            // user manually enable it in the system settings.
            await showDialog(
              barrierDismissible:false ,
              context: context, builder: (context) {
              return customDialog(OnPress: (){
                pm.openAppSettings();
                // Navigator.pop(context);
                }, 
                context: context);
              },);

            // return Future.error('Location permissions are denied');

          }
        }
        else{
          //if the permission is not whenInUse or onlyOnce, let the user manually set the permission
          print('no in use');
          await showDialog(
              barrierDismissible:false ,
              context: context, builder: (context) {
              return 
                customDialog(OnPress: (){
                  pm.openAppSettings();
                  // Navigator.pop(context);
                }, 
                context: context);
            },);
          // return Future.error('Location permissions are denied');
        }
      }

      //Before getting the location, check whether the permission is whenInUse or Always, 
      //if no, throw an error
      if(await pm.Permission.location.isPermanentlyDenied || !(await pm.Permission.locationWhenInUse.isGranted||await pm.Permission.locationAlways.isGranted)){
          print('cannot retrieve location last');
          return Future.error('cannot retrieve location');
      }

      _locationData = await location.getLocation();
    }catch(e){
      return Future.error(Exception("cannot retrieve location data"));
    }
    return _locationData;


    
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
      double distToPre = convertLatLonToDistance(position, prePos!);

      //if the user is moving right now, add the distance from last position(prePos) to the total distance 
      if(moving){
        if(status == 'walking'){
          setParentState(() {
            totalDist+=distToPre;
            print('update distance while walking:$totalDist');
          });
        }
      }
      //calculate the total distance moved since lastPos update
      totalDistSinceLastUpdate+=distToPre;
        

      //if the distance between the last recorded position and the current position is bigger than 4, 
      //we update the lastPos to prevent that the distance away exceed 40 after several calls when not moving
      // print("distToPre1:$distToPre");
      // print('current position: lat: ${position.latitude} lon:${position.longitude}');
      // print('pre position: lat: ${prePos!.latitude} lon:${prePos!.longitude}');

      if(distToPre >= 5.0 && !moving){
          distToPre = 0;
          double dist = convertLatLonToDistance(position, lastPos);
          // print("total distance before update $dist");
          // print('Update LAST POSITION');
          lastPos = position;
          // print('last position: lat: ${lastPos.latitude} lon:${lastPos.longitude}');
          totalDistSinceLastUpdate=0;
          //Since the steps and totalDist still update when moving is true,
          //the moved is set to false to allow totalDist update by totalDistSinceLast Update only when moving is false
          moved = false;
      }

      prePos = position;


      double dist = convertLatLonToDistance(position, lastPos);
        
      // print('totalDist:$dist');


      //if distance away is greater than 30, we assume that the user is truely walking
      //then we set the moving to true and set the timer
      //already tested 20 can be panetrated
      if(dist >= 30){
        lastPos = position;
        distToPre = 0;
        if(!moved){
          // setParentState(() {
            totalDist+=totalDistSinceLastUpdate; 
            // print("UPATE WITH TOTALDISTSINCELASTUPDATE: $totalDist");

          // });
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