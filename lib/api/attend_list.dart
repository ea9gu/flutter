import 'package:http/http.dart' as http;
import 'dart:convert';

Future<Map<String, dynamic>> fetchDateListData(String courseId) async {
  final url =
      'http://13.124.69.1:8000/class/get-attendance-data/'; // API의 엔드포인트 URL로 대체해야 합니다.
  final headers = {'Content-Type': 'application/x-www-form-urlencoded'};
  final body = {'course_id': courseId};

  final response =
      await http.post(Uri.parse(url), headers: headers, body: body);

  //print(response.body);
  if (response.statusCode == 200) {
    //print(json.decode(response.body));
    return json.decode(response.body);
  } else {
    throw Exception('Failed to fetch attendance data');
  }
}

Future<Map<String, dynamic>> fetchDateAttendanceData(
    String courseId, String? date) async {
  final url =
      'http://13.124.69.1:8000/class/get-attendance-data/'; // API의 엔드포인트 URL로 대체해야 합니다.
  final headers = {'Content-Type': 'application/x-www-form-urlencoded'};
  final body = {'course_id': courseId, 'date': date};

  final response =
      await http.post(Uri.parse(url), headers: headers, body: body);

  if (response.statusCode == 200) {
    return json.decode(response.body);
  } else {
    throw Exception('Failed to fetch attendance data');
  }
}
