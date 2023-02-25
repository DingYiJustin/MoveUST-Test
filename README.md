# MoveUST-Test
Some testing Done for the MoveUST APP

## Structure
The main documents are put in the lib directory. Only the "main.dart", "home.dart", and "Pedometer.dart" are important. Others are just files for learning flutter.


## Implementation
### PedoMeter
The Pedometer class stores two location information: the last location updated (named lastPos), and the last location recorded in the last callback (named prePos). The algorithm detect whether the distance between current position and prePos is larger than 5 meters. If yes, we think that the user is indoor and trying to trick the pedometer. If no, we update the prePos and lastPos to current position. Then, the algorithm will calculate the distance between current position and the lastPos. If the distance is larger than 30, the algorithm will think the user is truely moving and allow the pedometer callback function to update the step count.

### UnitTest
Note1: If testing a widget independently and the widget has Text widgets in it, use MaterialApp to surround the widget

Note2: I changed the location.dart file of the location package to enable the testing using customized stream.

Problem:it seems that the timers in the widgets won't stop and affect the testings