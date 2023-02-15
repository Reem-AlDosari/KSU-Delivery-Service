import 'package:background_location/background_location.dart';

class BackgroundClass{
  setLocationPrefs() async {
    String latitude = 'waiting...';
    String longitude = 'waiting...';
    String altitude = 'waiting...';
    String accuracy = 'waiting...';
    String bearing = 'waiting...';
    String speed = 'waiting...';
    String time = 'waiting...';
    // await BackgroundLocation.setAndroidConfiguration(1000);
    await BackgroundLocation.startLocationService();
    BackgroundLocation.getLocationUpdates((location) {
      print('''\n
                        Latitude:  $latitude
                        Longitude: $longitude
                        Altitude: $altitude
                        Accuracy: $accuracy
                        Bearing:  $bearing
                        Speed: $speed
                        Time: $time
                      ''');
    });
  }
}