import 'dart:async';
import 'dart:math';

import 'package:location/location.dart';

import '../lib/pedometer/PedometerSplit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import '../lib/pedometer/locationSetting.dart';
import 'pedoTestData.dart';

GlobalKey pedoKey = new GlobalKey<PedoCheckState>();
late PedoCheck pd;
late LocationData checkLastPos;




void main(){
 

  test('locationStream test', (){

  var locationStreamController = StreamController<LocationData>.broadcast();
  var sink = locationStreamController.sink;
  var stream = locationStreamController.stream;

  locationSettings locTest = locationSettings(setParentState:(Function a){}, status: 'walking');
  locTest.prePos = locTest.lastPos = LocationData.fromMap(Map.of(locationDatas[0]));
  stream.listen(locTest.onLocationChange);
    // var locationStream1 = Stream<LocationData>.periodic(const Duration(seconds: 1),(x){
    //   return LocationData.fromMap(Map.of(locationDatas[x]));
    // }).take(2);

    expectLater(stream,emitsInOrder([LocationData.fromMap(Map.of(locationDatas[0])),LocationData.fromMap(Map.of(locationDatas[1]))])).then((value){
      expect(locTest.lastPos.latitude, LocationData.fromMap(Map.of(locationDatas[1])).latitude);
      expect(locTest.lastPos.longitude, LocationData.fromMap(Map.of(locationDatas[1])).longitude);
      print('done');
    });
    sink.add(LocationData.fromMap(Map.of(locationDatas[0])));
    sink.add(LocationData.fromMap(Map.of(locationDatas[1])));
  });

  test('locationStream test1', (){
    var locationStreamController = StreamController<LocationData>.broadcast();
    var sink = locationStreamController.sink;
    var stream = locationStreamController.stream;

    locationSettings locTest = locationSettings(setParentState: (Function a){}, status: 'walking');
    locTest.prePos = locTest.lastPos = LocationData.fromMap(Map.of(locationDatas[0]));
    stream.listen(locTest.onLocationChange);
    expectLater(stream,emitsInOrder([
      LocationData.fromMap(Map.of(locationDatas[0]))
      ,LocationData.fromMap(Map.of(locationDatas[1]))
      ,LocationData.fromMap(Map.of(locationDatas[2]))
      ,LocationData.fromMap(Map.of(locationDatas[3]))
      ,LocationData.fromMap(Map.of(locationDatas[4]))
      ,LocationData.fromMap(Map.of(locationDatas[5]))
      ,LocationData.fromMap(Map.of(locationDatas[6]))
      ,LocationData.fromMap(Map.of(locationDatas[7]))
      ,LocationData.fromMap(Map.of(locationDatas[8]))
      ,LocationData.fromMap(Map.of(locationDatas[9]))
      ,LocationData.fromMap(Map.of(locationDatas[10]))
      ,LocationData.fromMap(Map.of(locationDatas[11]))
      ,LocationData.fromMap(Map.of(locationDatas[12]))

      ])).then((value){
      expect(locTest.moving, true);

      print('done2');
    });

    sink.add(LocationData.fromMap(Map.of(locationDatas[0])));
    sink.add(LocationData.fromMap(Map.of(locationDatas[1])));
    sink.add(LocationData.fromMap(Map.of(locationDatas[2])));
    sink.add(LocationData.fromMap(Map.of(locationDatas[3])));
    sink.add(LocationData.fromMap(Map.of(locationDatas[4])));
    sink.add(LocationData.fromMap(Map.of(locationDatas[5])));
    sink.add(LocationData.fromMap(Map.of(locationDatas[6])));
    sink.add(LocationData.fromMap(Map.of(locationDatas[7])));
    sink.add(LocationData.fromMap(Map.of(locationDatas[8])));
    sink.add(LocationData.fromMap(Map.of(locationDatas[9])));
    sink.add(LocationData.fromMap(Map.of(locationDatas[10])));
    sink.add(LocationData.fromMap(Map.of(locationDatas[11])));
    sink.add(LocationData.fromMap(Map.of(locationDatas[12])));
  });

  testWidgets('locationstream test', (WidgetTester tester) async {
    await tester.pumpWidget( pd = PedoCheck(key:pedoKey));
    final pedoFinder = find.byKey(pedoKey);
    PedoCheckState c = pedoKey.currentState as PedoCheckState;

    
  });

}

// void main() {
//     testWidgets('locationstream test', (WidgetTester tester) async {
//           await tester.pumpWidget( pd = PedoCheck(key:pedoKey));
//           final pedoFinder = find.byKey(pedoKey);


//           var locatonStream = Stream<LocationData>.periodic(const Duration(seconds: 1), (x){
//             print('emits');
//             final locationDatas;
//             if(x==0){
//               locationDatas = <String,dynamic>{
                
//                 'latitude': 22.33800972766978,
//                 'longitude':114.26344913863483,
//                 'accuracy':35.0,
//                 'altitude':0.0,
//                 'speed':0.0,
//                 'speed_accuracy':0.0,
//                 'heading':0.0,
//                 'time':DateTime.now().millisecondsSinceEpoch,
//                 'isMock':false,
//                 'verticalAccuracy':35.0,
//                 'headingAccuracy':0.0,
//                 'elapsedRealtimeNanos':0.0,
//                 'elapsedRealtimeUncertaintyNanos':0.0,
//                 'satelliteNumber':0,
//                 'provider':'',
//               };
//             }
//             else if(x==1){
//               locationDatas = <String,dynamic>{
//                 'latitude': 22.337936782055642,
//                 'longitude':114.26352054895702,
//                 'accuracy':35.0,
//                 'altitude':0.0,
//                 'speed':0.0,
//                 'speed_accuracy':0.0,
//                 'heading':0.0,
//                 'time':DateTime.now().millisecondsSinceEpoch,
//                 'isMock':false,
//                 'verticalAccuracy':35.0,
//                 'headingAccuracy':0.0,
//                 'elapsedRealtimeNanos':0.0,
//                 'elapsedRealtimeUncertaintyNanos':0.0,
//                 'satelliteNumber':0,
//                 'provider':'',
//               };
//               checkLastPos = locationDatas;
//             }
//             else{
//               if(x==2){
//                 PedoCheckState c = pedoKey.currentState as PedoCheckState;
//                 expect(c.getLoc.lastPos.latitude, checkLastPos.latitude);
//                 expect(c.getLoc.lastPos.longitude, checkLastPos.longitude);
//                 print('2');

//               }
//               else if(x == 12){
//                 PedoCheckState c = pedoKey.currentState as PedoCheckState;
//                 expect(c.getLoc.moving, true);
//                 print('12');
//               }
//               locationDatas = <String,dynamic>{
//                 'latitude': 22.337936782055642+ 0.0000243152047*(x-1),
//                 'longitude':114.26352054895702-0.000023803441*(x-1),
//                 'accuracy':35.0,
//                 'altitude':0.0,
//                 'speed':0.0,
//                 'speed_accuracy':0.0,
//                 'heading':0.0,
//                 'time':DateTime.now().millisecondsSinceEpoch,
//                 'isMock':false,
//                 'verticalAccuracy':35.0,
//                 'headingAccuracy':0.0,
//                 'elapsedRealtimeNanos':0.0,
//                 'elapsedRealtimeUncertaintyNanos':0.0,
//                 'satelliteNumber':0,
//                 'provider':'',
//               };
//             }
            
//             /**
//              * first: lat: 22.33800972766978 lon:114.26344913863483
//              * second: lat: 22.337936782055642 lon:114.26352054895702 //Update shall occur (10m away)
//              * //here the lastPos should be second position(use expect to test out(==?to see if refers to the same one))
//              * third: lat: 22.337936782055642 (lastPos) + 0.0000243152047*(x-1) , lon:114.26352054895702-0.000023803441*(x-1)
//              * four: like third
//              * ...
//              * twelve: like third //should be more than thirty meters from lastPos now
//              * //here the lastPos should be twelve and moving should be true 
//              */
//             return LocationData.fromMap(Map.of(locationDatas));
            
//           })
//           .take(13);
//           PedoCheckState c = pedoKey.currentState as PedoCheckState;
//           c.loc.location.onLocationChanged  = locatonStream;
//           final String value = 'Here is an event!';
//           expectLater(c.loc.location.onLocationChange, emits(value));
//           // c.loc.location.onLocationChange.listen(c.loc.onLocationChange);          

          
//           print('exit11111');
//     });

// }
