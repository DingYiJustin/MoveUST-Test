import 'package:location/location.dart';

import '../lib/pedometer/PedometerSplit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
    testWidgets('Counter increments smoke test', (WidgetTester tester) async {
          await tester.pumpWidget(const PedoCheck());
          var locationStream = Stream<LocationData>.periodic(const Duration(seconds: 1), (x){
            final locationDatas = <String,dynamic>{
              'latitude': 22.337936782055642,
              'longitude':114.26352054895702,
              'accuracy':35.0,
              'altitude':0.0,
              'speed':0.0,
              'speed_accuracy':0.0,
              'heading':0.0,
              'time':DateTime.now().millisecondsSinceEpoch,
              'isMock':false,
              'verticalAccuracy':35.0,
              'headingAccuracy':0.0,
              'elapsedRealtimeNanos':0.0,
              'elapsedRealtimeUncertaintyNanos':0.0,
              'satelliteNumber':0,
              'provider':'',
            };
            /**
             * first: lat: 22.33800972766978 lon:114.26344913863483
             * second: lat: 22.337936782055642 lon:114.26352054895702 //Update shall occur (10m away)
             * //here the lastPos should be second position(use expect to test out(==?to see if refers to the same one))
             * third: lat: 22.337936782055642 (lastPos) + 0.0000243152047*(x-1) , lon:114.26352054895702-0.000023803441*(x-1)
             * four: like third
             * ...
             * twelve: like third //should be more than thirty meters from lastPos now
             * //here the lastPos should be twelve and moving should be true 
             */
            return LocationData.fromMap(Map.of(locationDatas));
            
          });

    });

}