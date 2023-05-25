import 'package:http/http.dart' as http;
import 'dart:convert';

Future<http.Response> addDevice(
    String student_id, String deviceType, String deviceSerial) async {
  final url = Uri.parse('http://13.124.69.1:8000/serial/save-device/');

  final response = await http.post(
    url,
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({
      'student_id': student_id,
      'device_name': deviceType,
      'device_serial': deviceSerial,
    }),
  );

  return response;
}

Future<http.Response> getCurrentDeviceInfo(String student_id) async {
  final url = Uri.parse('http://13.124.69.1:8000/serial/get-device/');

  final response = await http.post(
    url,
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({
      'student_id': student_id,
    }),
  );

  return response;
}
