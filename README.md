# MoveUST-Test
Some testing Done for the MoveUST APP

## Structure
The main documents are put in the lib directory. Only the "main.dart", "home.dart", and "Pedometer.dart" are important. Others are just files for learning flutter.


## Implementation
### PedoMeter
The Pedometer class stores two location information: the last location updated (named lastPos), and the last location recorded in the last callback (named prePos). The algorithm detect whether the distance between current position and prePos is larger than 5 meters. If yes, we think that the user is indoor and trying to trick the pedometer. If no, we update the prePos and lastPos to current position. Then, the algorithm will calculate the distance between current position and the lastPos. If the distance is larger than 30, the algorithm will think the user is truely moving and allow the pedometer callback function to update the step count.
### Problem of pedometer
Current Problem is that since the status is not change when subscribe the status stream again, it won't
broadcast to change the value of status on the screen until next status change