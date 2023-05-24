import 'dart:convert';
import 'package:http/http.dart' as http;

Future<http.Response> signUp(String username, String name, bool flag,
    String password1, String password2) async {
  final url = Uri.parse('http://localhost:8000/user/account/signup/');
  final headers = {'Content-Type': 'application/json'};
  final body = json.encode({
    'username': username,
    'name': name,
    'flag': flag,
    'password1': password1,
    'password2': password2,
  });

  final response = await http.post(url, headers: headers, body: body);

  return response;
}

Future<http.Response> login(String username, String password) async {
  final url = Uri.parse('http://localhost:8000/user/account/mylogin/');
  final headers = {'Content-Type': 'application/json'};
  final body = json.encode({
    'username': username,
    'password': password,
  });

  final response = await http.post(url, headers: headers, body: body);

  return response;
}
