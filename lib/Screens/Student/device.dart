import 'package:ea9gu/Components/back_button.dart';
import 'package:ea9gu/Components/input_box.dart';
import 'package:ea9gu/Components/next_button.dart';
import 'package:ea9gu/Screens/Professor/Signup/proSignup2.dart';
import 'package:ea9gu/device_info.dart';
import 'package:flutter/material.dart';

class Device extends StatefulWidget {
  @override
  _DeviceScreenState createState() => _DeviceScreenState();
}

class _DeviceScreenState extends State<Device> {
  Map<String, String> deviceInfo = {};

  @override
  void initState() {
    super.initState();
    _getDeviceInfo();
  }

  Future<void> _getDeviceInfo() async {
    deviceInfo = await getDeviceInfo();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('기기등록'),
          centerTitle: true,
          backgroundColor: Color(0xff8685A6),
          actions: [
            IconButton(
              icon: Icon(Icons.settings),
              onPressed: () {},
            )
          ],
        ),
        body: Padding(
          //두번째 padding <- LIstview에 속함.
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Form(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(height: 15),
                  Text("현재 접속한 기기를 등록하시겠습니까?"),
                  SizedBox(height: 5),
                  Text(
                      "출석체크를 위해서는 기기를 등록 하셔야 합니다.\n등록한 기기는 2주 이내에 변경이 불가능합니다."),
                  Text('현재 접속 기기 : ${deviceInfo['device_type'] ?? ''}'),
                  SizedBox(height: 10),
                  NextButton(
                      text: "기기등록",
                      onpress: () {
                        print(deviceInfo['device_id']);
                      }),
                  SizedBox(height: 15),
                  Container(
                      height: 1.0, width: 500.0, color: Color(0xffD8DADC)),
                  SizedBox(height: 15),
                  Text("현재 등록 기기"),
                ],
              ),
            ),
          ),
        ));
  }
}
