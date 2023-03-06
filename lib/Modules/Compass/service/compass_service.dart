import 'dart:math' as math;

class CompassService {
  double angleBetweenCoordinates(double lat1, double long1, double lat2, double long2) {
    // this function returns the angle between 2 coordinates in degrees
    double dLon = (long1 - long2);
    double y = math.sin(dLon) * math.cos(lat2);
    double x = math.cos(lat1) * math.sin(lat2) - math.sin(lat1) * math.cos(lat2) * math.cos(dLon);

    double brng = math.atan2(y, x);

    double degreeAngle = brng * 57.2958;
    degreeAngle = (degreeAngle + 360) % 360;
    // setState(() {
    //   turns = degreeAngle / 360;
    // });
    // brng = 360 - brng; // count degrees counter-clockwise - remove to make clockwise
    // log('brng is $brng');

    return degreeAngle;
  }

  double distanceBetweenCoordinates(lat1, lon1, lat2, lon2) {
    var p = 0.017453292519943295;
    var c = math.cos;
    var a = 0.5 - c((lat2 - lat1) * p) / 2 + c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
    return double.parse((12742 * math.asin(math.sqrt(a))).toStringAsFixed(2));
  }
}
