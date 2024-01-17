import 'package:dio/dio.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:nutriscan/features/donation/domain/directions_model.dart';

class DirectionsRepository {
  static const String _baseUrl =
      'https://maps.googleapis.com/maps/api/directions/json?';

  final Dio _dio;

  DirectionsRepository({Dio? dio}) : _dio = dio ?? Dio();

  Future<Directions?> getDirections({
    required LatLng origin,
    required LatLng destination,
  }) async {
    try {
      final response = await _dio.get(
        _baseUrl,
        queryParameters: {
          'origin': '${origin.latitude},${origin.longitude}',
          'destination': '${destination.latitude},${destination.longitude}',
          'key': "AIzaSyBovpx2n8V3adrgQ-b3mWpQYKi9DmbnbTE",
        },
      );

      // Check if response is successful
      if (response.statusCode == 200) {
        return Directions.fromMap(response.data);
      } else {
        // Handle unsuccessful response (non-200 status code)
        print("Error: ${response.statusCode}");
        return null;
      }
    } catch (error) {
      // Handle Dio errors or other exceptions
      print("Error: $error");
      return null;
    }
  }
}
