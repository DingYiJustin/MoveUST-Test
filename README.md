# MoveUST-Test
Some testing Done for the MoveUST APP

# Structure
The main documents are put in the lib directory. Only the "main.dart", "home.dart", and "Pedometer.dart" are important. Others are just files for learning flutter.


# further implementation?
## PedoMeter


1. Since the accuracy is different indoor and outdoor. We can have a counter for position update(for example, the position will update itself after 5 counts or when the distance between the last position and currently position is greater then 10 meters).

2. I tried a very strict checking. if ((dist - lastDist)>=3 ||(dist - lastDist)<-3 ) then update the last location so that the distance from the last location will become 0 again. This makes it nearly impossible to update indoor. Haven't tested outdoor.