import 'package:ea9gu/Components/dialog.dart';
import 'package:ea9gu/Components/next_button.dart';
import 'package:ea9gu/device_info.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:ea9gu/api/add_device.dart';
import 'package:http/http.dart' as http;

class Device extends StatefulWidget {
  @override
  _DeviceScreenState createState() => _DeviceScreenState();
}

class _DeviceScreenState extends State<Device> {
  Map<String, String> deviceInfo = {};
  final student_id = "2300000";
  String current_id = "";
  String current_name = "";
  String current_time = "";

  @override
  void initState() {
    super.initState();
    getCurrentDevice();
    _getDeviceInfo();
  }

  Future<void> _getDeviceInfo() async {
    deviceInfo = await getDeviceInfo();
    setState(() {});
  }

  Future<void> registerDevice() async {
    final deviceType = deviceInfo['device_type'];
    final deviceSerial = deviceInfo['device_id'];

    final response = await addDevice(
      student_id,
      deviceType!,
      deviceSerial!,
    );

    final responseData = jsonDecode(response.body);
    final status = responseData['status'];

    if (status == 'error') {
      final message = responseData['message'];
      if (message == '이미 등록된 디바이스입니다.') {
        //print('이미 등록된 디바이스입니다.');
        DialogFormat.customDialog(
          context: context,
          title: 'Error',
          content: '이미 디바이스를 등록한 id입니다. 디바이스 변경은 등록일로부터 2주 후 가능합니다.',
        );
      } else {
        //print('기기 등록에 실패했습니다.');
        DialogFormat.customDialog(
          context: context,
          title: 'Error',
          content: '기기 등록에 실패했습니다.',
        );
      }
    } else {
      //print('기기 등록에 성공했습니다.');
      DialogFormat.customDialog(
        context: context,
        title: 'Success',
        content: '기기 등록에 성공했습니다.',
      );
    }
    getCurrentDevice();
  }

  Future<void> getCurrentDevice() async {
    final response = await getCurrentDeviceInfo(
      student_id,
    );

    final responseData = jsonDecode(response.body);
    //print(responseData);
    final status = responseData['status'];

    if (status == 'success') {
      print('등록된 디바이스가 있습니다.');
      setState(() {
        current_id = responseData['device_id'];
        current_name = responseData['device_name'];
        current_time = responseData['timestamp'];
      });
      print(current_id);
    } else {
      throw Exception('등록된 디바이스가 없습니다.');
    }
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
                  Text(
                    '현재 접속 기기 : ${deviceInfo['device_type'] ?? ''}',
                    style: TextStyle(
                      color: Color(0xff8685A6),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  NextButton(
                      text: "기기등록",
                      onpress: () {
                        //print(deviceInfo['device_id']);
                        registerDevice();
                      }),
                  SizedBox(height: 15),
                  Container(
                      height: 1.0, width: 500.0, color: Color(0xffD8DADC)),
                  SizedBox(height: 15),
                  Text("현재 등록 기기"),
                  SizedBox(height: 10),
                  current_id != ""
                      ? Container(
                          height: 80,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10.0),
                            border: Border.all(
                              width: 3,
                              color: Color(0xff8685A6),
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.smartphone, // 왼쪽에 표시할 아이콘
                                  color: Colors.black,
                                  size: 50.0),
                              SizedBox(width: 10.0), // 아이콘과 글씨 사이의 간격 조정
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "${current_name} - ${current_id}", // 첫 번째 줄로 표시할 글씨
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 17.0, // 첫 번째 줄 글씨 크기 조정
                                        // 진한 글씨체 적용
                                      ),
                                    ),
                                    Text(
                                      current_time, // 두 번째 줄로 표시할 글씨
                                      style: TextStyle(
                                        color: Colors.grey, // 연한 색상 적용
                                        fontSize: 14.0, // 두 번째 줄 글씨 크기 조정
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        )
                      : Text("등록된 기기가 없습니다.")
                ],
              ),
            ),
          ),
        ));
  }
}
