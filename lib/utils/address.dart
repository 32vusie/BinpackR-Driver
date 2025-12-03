import 'package:geocoding/geocoding.dart';

Future<String> getFullAddress(double latitude, double longitude) async {
  try {
    List<Placemark> placemarks = await placemarkFromCoordinates(latitude, longitude);
    if (placemarks.isNotEmpty) {
      Placemark placemark = placemarks.first;
      return '${placemark.name}, ${placemark.locality}, ${placemark.administrativeArea}, ${placemark.country}';
    }
  } catch (e) {
    return 'Error retrieving address: $e';
  }
  return 'Unknown Address';
}


String getAddressFromGeoPoint(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')} ${_getMonthAbbreviation(date.month)} ${date.year}';
  }

  String _getMonthAbbreviation(int month) {
    return [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ][month - 1];
  }
