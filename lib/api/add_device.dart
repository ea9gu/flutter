import 'package:http/http.dart' as http;
import 'dart:convert';

Future<http.Response> addDevice(String deviceType, String deviceSerial) async {
  final url = Uri.parse('http://10.0.2.2:8000/serial/save-device/');

  final response = await http.post(
    url,
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({
      'device_name': deviceType,
      'device_serial': deviceSerial,
    }),
  );

  return response;
}
