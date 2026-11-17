import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';

class Fix {
  const Fix(this.latitude, this.longitude, this.accuracy);

  final double latitude;
  final double longitude;
  final double accuracy;
}

/// Where the phone is. Tests replace it with a fake.
abstract class LocationService {
  /// The current position, or null when it cannot be obtained (permission
  /// denied, GPS off, no fix in time). Never throws.
  Future<Fix?> current();
}

class DeviceLocationService implements LocationService {
  @override
  Future<Fix?> current() async {
    try {
      if (!await Geolocator.isLocationServiceEnabled()) {
        return null;
      }

      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
        return null;
      }

      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: Duration(seconds: 30),
        ),
      );

      return Fix(position.latitude, position.longitude, position.accuracy);
    } catch (_) {
      return null;
    }
  }
}

final locationProvider = Provider<LocationService>((ref) => DeviceLocationService());
