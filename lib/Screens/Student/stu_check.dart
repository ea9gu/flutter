import 'package:flutter/material.dart';
import 'package:ea9gu/constants.dart';
import 'dart:async';
import 'dart:io';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';
import 'package:http_parser/http_parser.dart';
// import 'package:path/path.dart' as path;
// import 'package:path_provider/path_provider.dart';

class StuCheck extends StatefulWidget {
  StuCheck({required this.buttonText, Key? key}) : super(key: key);
  final String buttonText;

  @override
  _StuCheckState createState() => _StuCheckState();
}

class _StuCheckState extends State<StuCheck> with TickerProviderStateMixin {
  bool isCheckButtonEnabled = false;
  bool isCheckButtonPressed = false;
  Color checkButtonBackgroundColor = darkColor;
  Color checkButtonTextColor = Colors.white;
  Color boxBackgroundColor = Colors.white;
  Color boxTextColor = mainColor;
  final _audioRecorder = FlutterSoundRecorder();

  @override
  void initState() {
    super.initState();
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
    final url = Uri.parse('http://localhost:8000/freq/save-attendance/');
    final request = http.MultipartRequest('POST', url);
    final fileBytes = await file.readAsBytes();
    request.files.add(await http.MultipartFile.fromBytes(
      'recording',
      fileBytes,
      filename: 'audio_file',
      contentType: MediaType('audio', 'wav'),
    ));
    final response = await request.send();

    if (response.statusCode == 200) {
      print('Data sent successfully');
    } else {
      print('Failed to send data');
    }
  }

  void toggleCheckButton() {
    setState(() {
      if (!isCheckButtonPressed) {
        isCheckButtonPressed = true;
        checkButtonBackgroundColor = lightColor;
        checkButtonTextColor = Colors.white;
        boxBackgroundColor = mainColor;
        boxTextColor = Colors.white;
        _startRecording();
        Future.delayed(Duration(seconds: 3), () {
          _stopRecording();
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    TabController _tabController = TabController(length: 2, vsync: this);
    String boxText = isCheckButtonPressed ? '출석체크 완료' : '출석체크를 하세요';
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.buttonText),
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
                          borderRadius: BorderRadius.circular(25)),
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
                        onPressed: isCheckButtonEnabled && !isCheckButtonPressed
                            ? () {
                                setState(() {
                                  toggleCheckButton();
                                });
                              }
                            : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: checkButtonBackgroundColor,
                          primary: checkButtonTextColor,
                          padding: EdgeInsets.symmetric(
                              horizontal: 30, vertical: 15),
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
                              isCheckButtonEnabled = true;
                              checkButtonBackgroundColor = darkColor;
                              checkButtonTextColor = Colors.white;
                            });
                          },
                          icon: const Icon(Icons.autorenew),
                          iconSize: 30,
                        ),
                      ),
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
                          "지각, 결석",
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
