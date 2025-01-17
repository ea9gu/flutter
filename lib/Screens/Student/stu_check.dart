import 'package:flutter/material.dart';
import 'package:ea9gu/constants.dart';
import 'package:ea9gu/Components/dialog.dart';
import 'package:ea9gu/device_info.dart';
import 'package:ea9gu/api/add_device.dart';
import 'dart:async';
import 'dart:io';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';
import 'package:http_parser/http_parser.dart';
import 'dart:convert';

class StuCheck extends StatefulWidget {
  final String student_id;
  final String class_name;
  final String course_id;

  StuCheck(
      {required this.student_id,
      required this.class_name,
      required this.course_id,
      Key? key})
      : super(key: key);

  @override
  _StuCheckState createState() => _StuCheckState();
}

class _StuCheckState extends State<StuCheck> with TickerProviderStateMixin {
  bool isCheckButtonEnabled = false;
  bool isCheckButtonPressed = false;
  bool isAttendanceChecking = false;
  Color checkButtonBackgroundColor = darkColor;
  Color checkButtonTextColor = Colors.white;
  Color boxBackgroundColor = Colors.white;
  Color boxTextColor = mainColor;
  final _audioRecorder = FlutterSoundRecorder();
  String boxText = '출석체크하기';
  String stateText = '출석체크 중이 아닙니다';

  Map<String, int> attendanceData = {};
  List<String> attendanceOptions = ['출석', '결석'];
  late TabController _tabController;

  Map<String, String> deviceInfo = {};
  String current_id = "";

  @override
  void initState() {
    super.initState();
    checkAttendanceStatus();
    _audioRecorder.openRecorder();
    _tabController = TabController(length: 2, vsync: this);
    attendanceData = {};
    _getDeviceInfo();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _audioRecorder.closeRecorder();
    super.dispose();
  }

  Future<void> _getDeviceInfo() async {
    deviceInfo = await getDeviceInfo();
    setState(() {});
    print(deviceInfo);
  }

  Future<void> _initAudioRecorder() async {
    final status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      throw RecordingPermissionException('permission denied');
    }
    await _audioRecorder.openRecorder();
    _audioRecorder.setSubscriptionDuration(Duration(seconds: 3));
  }

  Future<void> _startRecording() async {
    await _audioRecorder.startRecorder(toFile: 'audio_file');
  }

  Future<void> _stopRecording() async {
    final path = await _audioRecorder.stopRecorder();
    final audioFile = File(path!);
    print('$audioFile');
    await _sendAudioFile(audioFile);
    fetchAttendanceData();
  }

  Future<void> _sendAudioFile(File file) async {
    final url = Uri.parse('http://13.124.69.1:8000/freq/save-attendance/');
    final request = http.MultipartRequest('POST', url);
    final fileBytes = await file.readAsBytes();
    request.files.add(await http.MultipartFile.fromBytes(
      'recording',
      fileBytes,
      filename: 'audio_file',
      contentType: MediaType('audio', 'wav'),
    ));
    request.fields['student_id'] =
        widget.student_id; // Replace with current user ID
    request.fields['course_id'] = widget.course_id;
    DateTime currentDate = DateTime.now();
    String formattedDate = currentDate.toIso8601String().split('T')[0];
    request.fields['date'] = formattedDate;
    final response = await request.send();

    if (response.statusCode == 200) {
      print('Data sent successfully');
      final responseData = await response.stream.bytesToString();
      final parsedResponse = jsonDecode(responseData);
      if (parsedResponse['status'] == 'success') {
        //원래는 success로 고치기
        setState(() {
          isCheckButtonPressed = true;
          boxBackgroundColor = mainColor;
          boxTextColor = Colors.white;
          boxText = '출석체크 완료';
          print('status change successfully');
        });
      }
    } else {
      print('Failed to send data');
    }
  }

  Future<bool> getCurrentDevice() async {
    final response = await getCurrentDeviceInfo(
      widget.student_id,
    );

    final responseData = jsonDecode(response.body);
    //print(responseData);
    final status = responseData['status'];

    if (status == 'success') {
      setState(() {
        current_id = responseData['device_id'];
      });
      print(current_id);
      if (current_id != deviceInfo['device_id']) {
        DialogFormat.customDialog(
            context: context, title: "Error", content: "등록된 기기가 아닙니다.");
        return false;
      }
      return true;
    } else {
      DialogFormat.customDialog(
          context: context, title: "Error", content: "기기등록을 먼저 진행해주세요.");
      return false;
    }
  }

  Future<void> checkAttendanceStatus() async {
    final url2 = Uri.parse('http://13.124.69.1:8000/class/activate-signal/');
    final request2 = http.MultipartRequest('POST', url2);
    request2.fields['student_id'] =
        widget.student_id; // Replace with current user ID
    request2.fields['course_id'] = widget.course_id;
    final response2 = await request2.send();

    if (response2.statusCode == 200) {
      print('iconbutton Data sent successfully');
      final responseData = await response2.stream.bytesToString();
      final parsedResponse = jsonDecode(responseData);
      print(parsedResponse);
      if (parsedResponse['status'] == 'check') {
        setState(() {
          isAttendanceChecking = true;
          stateText = '출석체크 중';
          fetchAttendanceData();
        });
        // fetchAttendanceData();
      } else if (parsedResponse['status'] == 'bluecheck') {
        setState(() {
          isAttendanceChecking = false;
          stateText = '출석체크 중이 아닙니다';
        });
      }
    } else {
      print('Failed to fetch attendance status');
    }
  }

  void toggleCheckButton() {
    setState(() {
      if (!isCheckButtonPressed) {
        isCheckButtonPressed = true;
        checkButtonBackgroundColor = lightColor;
        checkButtonTextColor = Colors.white;
        _startRecording();
        Future.delayed(Duration(seconds: 3), () {
          _stopRecording().then((_) {
            setState(() {
              stateText = '출석체크 완료';
              fetchAttendanceData();
            });
          });
        });
      }
    });
  }

  void fetchAttendanceData() async {
    var url = 'http://13.124.69.1:8000/class/get-attendance-data/';
    var data = {
      'course_id': widget.course_id.toString(),
      'student_id': widget.student_id.toString(),
    };
    print(data);

    try {
      var response = await http.post(
        Uri.parse(url),
        body: data,
      );
      print(response.body);

      if (response.statusCode == 200) {
        var responseData = json.decode(response.body);
        var attendanceDataMap =
            Map<String, int>.from(responseData['attendance_data']);
        var attendanceDates = List<String>.from(responseData['dates']);
        setState(() {
          attendanceData = attendanceDataMap;
          attendanceOptions = ['출석', '결석'];
        });
      }
    } catch (e) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    // TabController _tabController = TabController(length: 2, vsync: this);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.class_name),
        centerTitle: true,
        backgroundColor: mainColor,
      ),
      body: Column(
        children: [
          SizedBox(height: size.height * 0.1),
          Container(
            width: MediaQuery.of(context).size.width,
            child: DefaultTabController(
              length: 2,
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: 60,
                      decoration: BoxDecoration(
                        border: Border.all(color: mainColor),
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: TabBar(
                        controller: _tabController,
                        unselectedLabelColor: mainColor,
                        indicator: BoxDecoration(
                          borderRadius: BorderRadius.circular(25),
                          color: mainColor,
                        ),
                        tabs: [
                          Tab(text: "출석체크"),
                          Tab(text: "출석부"),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(height: 30),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                Column(
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: ElevatedButton(
                        onPressed: isAttendanceChecking && !isCheckButtonPressed
                            ? () async {
                                bool isDeviceRegistered =
                                    await getCurrentDevice();
                                isDeviceRegistered == true
                                    ? setState(() {
                                        toggleCheckButton();
                                        isCheckButtonEnabled = true;
                                        checkButtonBackgroundColor = darkColor;
                                        checkButtonTextColor = Colors.white;
                                      })
                                    : "";
                              }
                            : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: checkButtonBackgroundColor,
                          primary: checkButtonTextColor,
                          padding: EdgeInsets.symmetric(
                            horizontal: 30,
                            vertical: 15,
                          ),
                        ),
                        child: Text(
                          isCheckButtonPressed ? '출석체크가 이미 완료되었습니다' : '출석체크하기',
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 20.0),
                        child: IconButton(
                          onPressed: () {
                            setState(() {
                              checkAttendanceStatus();
                            });
                            print('iconbutton pressed');
                          },
                          icon: const Icon(Icons.autorenew),
                          iconSize: 30,
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      stateText,
                      style: TextStyle(color: mainColor),
                    ),
                    SizedBox(height: 80),
                    Container(
                      width: 250,
                      height: 50,
                      color: boxBackgroundColor,
                      child: Center(
                        child: Text(
                          boxText,
                          style: TextStyle(color: boxTextColor),
                        ),
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    SizedBox(height: 20),
                    // Container(
                    //   width: 250,
                    //   height: 50,
                    //   color: mainColor,
                    //   child: Center(
                    //     child: Text(
                    //       "출석 2회, 결석 1회",
                    //       style: TextStyle(color: Colors.white),
                    //     ),
                    //   ),
                    // )
                    if (attendanceData.isNotEmpty)
                      Expanded(
                        child: DataTable(
                          columns: [
                            DataColumn(label: Text('날짜')),
                            DataColumn(label: Text('출석여부')),
                          ],
                          rows: attendanceData.entries.map((entry) {
                            final date = entry.key;
                            String attendanceStatus =
                                entry.value == 1 ? '출석' : '결석';

                            return DataRow(
                              cells: [
                                DataCell(Text(date)),
                                DataCell(Text(attendanceStatus)),
                              ],
                            );
                          }).toList(),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
