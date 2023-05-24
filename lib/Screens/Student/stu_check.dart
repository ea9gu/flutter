import 'package:flutter/material.dart';
import 'package:ea9gu/constants.dart';
import 'package:ea9gu/Components/dialog.dart';
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

  @override
  void initState() {
    super.initState();
    checkAttendanceStatus();
    _audioRecorder.openRecorder();
  }

  @override
  void dispose() {
    _audioRecorder.closeRecorder();
    super.dispose();
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
  }

  Future<void> _sendAudioFile(File file) async {
    final url = Uri.parse('http://10.0.2.2:8000/freq/save-attendance/');
    final request = http.MultipartRequest('POST', url);
    final fileBytes = await file.readAsBytes();
    request.files.add(await http.MultipartFile.fromBytes(
      'recording',
      fileBytes,
      filename: 'audio_file',
      contentType: MediaType('audio', 'wav'),
    ));
    request.fields['student_id'] = 'stu_id'; // Replace with current user ID
    request.fields['course_id'] = widget.course_id;
    request.fields['date'] = DateTime.now().toString();
    final response = await request.send();

    if (response.statusCode == 200) {
      print('Data sent successfully');
      final responseData = await response.stream.bytesToString();
      final parsedResponse = jsonDecode(responseData);
      if (parsedResponse['status'] == 'error') {
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
      return true;
    } else {
      DialogFormat.customDialog(
          context: context, title: "Error", content: "기기등록을 먼저 진행해주세요.");
      return false;
    }
  }

  Future<void> checkAttendanceStatus() async {
    final url2 = Uri.parse('http://10.0.2.2:8000/class/activate-signal/');
    final request2 = http.MultipartRequest('POST', url2);
    request2.fields['student_id'] = 'stu_id'; // Replace with current user ID
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
        });
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
            });
          });
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    TabController _tabController = TabController(length: 2, vsync: this);
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
                    Container(
                      width: 250,
                      height: 50,
                      color: mainColor,
                      child: Center(
                        child: Text(
                          "출석 2회, 결석 1회",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
