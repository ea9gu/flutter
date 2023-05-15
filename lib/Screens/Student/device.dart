import 'package:ea9gu/Components/dialog.dart';
import 'package:ea9gu/Components/next_button.dart';
import 'package:ea9gu/device_info.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:ea9gu/api/add_device.dart';

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

  Future<void> registerDevice() async {
    final deviceType = deviceInfo['device_type'];
    final deviceSerial = deviceInfo['device_id'];

    final response = await addDevice(deviceType!, deviceSerial!);

    final responseData = jsonDecode(response.body);
    final status = responseData['status'];

    if (status == 'error') {
      final message = responseData['message'];
      if (message == '이미 등록된 디바이스입니다.') {
        //print('이미 등록된 디바이스입니다.');
        DialogFormat.customDialog(
          context: context,
          title: 'Error',
          content: '이미 등록된 디바이스입니다.',
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
                        registerDevice();
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
