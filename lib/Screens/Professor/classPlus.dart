import 'dart:convert';
import 'dart:io';

import 'package:ea9gu/Components/input_form.dart';
import 'package:ea9gu/Components/next_button.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:ea9gu/constants.dart';
import 'package:http/http.dart' as http;
import 'package:ea9gu/Components/dialog.dart';
import 'package:path/path.dart' as path;
import 'package:http_parser/http_parser.dart';

class classPlus extends StatefulWidget {
  final String prof_id;

  classPlus({required this.prof_id});

  @override
  classPlusScreenState createState() => classPlusScreenState();
}

class classPlusScreenState extends State<classPlus> {
  File? _selectedFile;
  String selectedFileName = ''; // 선택한 파일의 제목을 저장할 변수
  String selectedFilePath = '';
  bool isFileSelected = false; // 파일이 선택되었는지 여부를 저장할 변수
  String course_id = ''; //학수번호
  String course_name = ''; //강좌명
  final _formKey = GlobalKey<FormState>();

  void _pickFile(BuildContext context) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['xlsx', 'xls', 'csv'], // 허용할 파일 확장자를 여기에 추가하세요.
    );

    if (result != null && result.files.isNotEmpty) {
      final file = File(result.files.first.path!);
      String filePath = result.files.single.path!;
      String fileName = path.basename(filePath); // 선택한 파일의 제목을 가져옴
      //String uploadStatus = await uploadFile(filePath);
      setState(() {
        _selectedFile = file;
        selectedFilePath = filePath;
        selectedFileName = fileName; // 파일 제목을 selectedFileName 변수에 할당
        isFileSelected = true; // 파일이 선택되었음을 표시
      });

      /*
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(uploadStatus)),
      );
      */
    } else {
      setState(() {
        _selectedFile = null;
        selectedFilePath = '';
        selectedFileName = ''; // 파일 선택이 취소된 경우 변수 초기화
        isFileSelected = false; // 파일 선택이 취소되었음을 표시
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('파일 선택 취소됨')),
      );
    }
  }

  Future<void> enrollStudents() async {
    _formKey.currentState!.save();
    final url = Uri.parse(
        'http://10.0.2.2:8000/class/create-and-enroll/'); // Replace with your DRF server URL

    print(selectedFilePath);
    try {
      var request = http.MultipartRequest('POST', url);
      request.fields['course_id'] = course_id;
      request.fields['professor_id'] = widget.prof_id;
      request.fields['course_name'] = course_name;
      request.files
          .add(await http.MultipartFile.fromPath('csv_file', selectedFilePath));

      var response = await request.send();

      if (response.statusCode == 200) {
        print("hi");
        var responseJson = await response.stream.bytesToString();
        var responseData = jsonDecode(responseJson);
        final status = responseData['status'];
        print(responseData);
        if (status == "success") {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('알림'),
                content: Text('강좌가 추가되었습니다.'),
                actions: <Widget>[
                  TextButton(
                    child: Text('확인'),
                    onPressed: () {
                      // Reset form and close pop-up
                      _formKey.currentState!.reset();
                      setState(() {
                        _selectedFile = null;
                        selectedFileName = ''; // 파일 선택 취소 버튼을 누르면 변수 초기화
                        isFileSelected = false; // 파일 선택 취소되었음을 표시
                      });
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
        } else {
          DialogFormat.customDialog(
            context: context,
            title: 'Error',
            content: '모든 칸을 입력해 주세요.',
          );
        }
        // Process the responseJson
      } else {
        // Handle error
        DialogFormat.customDialog(
          context: context,
          title: 'Error',
          content: '출석부를 첨부해 주세요.',
        );
      }
    } catch (e) {
      // Handle error
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('나의 강좌'),
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
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                    height: 15,
                  ),
                  buildTextFormField(
                    hintText: "강좌명",
                    onSaved: (value) {
                      course_name = value!;
                    },
                  ),
                  SizedBox(height: 15),
                  buildTextFormField(
                    hintText: "학수번호",
                    onSaved: (value) {
                      course_id = value!;
                    },
                  ),
                  SizedBox(height: 15),
                  Text("출석부 첨부"),
                  SizedBox(height: 5),
                  Row(
                    children: [
                      if (isFileSelected)
                        Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                              border: Border.all(
                                color: mainColor,
                                width: 1,
                              )),
                          child: Row(
                            children: [
                              Container(
                                padding: EdgeInsets.only(left: 10),
                                child: Text(
                                  selectedFileName,
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              IconButton(
                                icon: Icon(Icons.clear),
                                onPressed: () {
                                  setState(() {
                                    _selectedFile = null;
                                    selectedFileName =
                                        ''; // 파일 선택 취소 버튼을 누르면 변수 초기화
                                    isFileSelected = false; // 파일 선택 취소되었음을 표시
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                      if (!isFileSelected)
                        OutlinedButton.icon(
                            icon: Icon(Icons.file_upload, color: mainColor),
                            onPressed: () => _pickFile(context),
                            label: Text('파일 선택',
                                style:
                                    TextStyle(color: mainColor, fontSize: 15)),
                            style: OutlinedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                              side: BorderSide(
                                color: mainColor,
                                width: 2,
                              ),
                            )),
                    ],
                  ),
                  SizedBox(height: 50),
                  Column(children: [
                    NextButton(
                        text: "출석부 등록하기/업데이트하기", onpress: enrollStudents),
                  ])
                ],
              ),
            ),
          ),
        ));
  }
}
