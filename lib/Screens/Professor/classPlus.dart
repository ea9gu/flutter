import 'dart:convert';

import 'package:ea9gu/Components/input_form.dart';
import 'package:ea9gu/Components/next_button.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:ea9gu/constants.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
import 'package:http_parser/http_parser.dart';

class classPlus extends StatefulWidget {
  final Function(String) onDataReturned; // 데이터를 반환하기 위한 콜백 함수

  classPlus({required this.onDataReturned});

  @override
  classPlusScreenState createState() => classPlusScreenState();
}

class classPlusScreenState extends State<classPlus> {
  String selectedFileName = ''; // 선택한 파일의 제목을 저장할 변수
  String selectedFilePath = '';
  bool isFileSelected = false; // 파일이 선택되었는지 여부를 저장할 변수
  String course_id = ''; //학수번호
  String course_name = ''; //강좌명
  final _formKey = GlobalKey<FormState>();

  void _onButtonPressed() {
    // 버튼을 누를 때 데이터를 콜백 함수를 통해 전달
    String data = "컴파일러";
    widget.onDataReturned(data);
    Navigator.pop(context); // 이전 화면으로 돌아감
  }

  Future<void> enrollStudents() async {
    _formKey.currentState!.save();
    final url = Uri.parse(
        'http://localhost:8000/class/create-and-enroll/'); // Replace with your DRF server URL

    try {
      var request = http.MultipartRequest('POST', url);
      request.fields['course_id'] = course_id;
      request.fields['professor_id'] = "prof1";
      request.fields['course_name'] = course_name;
      request.files
          .add(await http.MultipartFile.fromPath('csv_file', selectedFilePath));

      var response = await request.send();

      if (response.statusCode == 200) {
        print("hi");
        var responseJson = await response.stream.bytesToString();
        var decodedJson = jsonDecode(responseJson);

        // Process the responseJson
      } else {
        // Handle error
      }
    } catch (e) {
      // Handle error
    }
  }

  void _pickFile(BuildContext context) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['xlsx', 'xls', 'csv'], // 허용할 파일 확장자를 여기에 추가하세요.
    );

    if (result != null) {
      String filePath = result.files.single.path!;
      String fileName = path.basename(filePath); // 선택한 파일의 제목을 가져옴
      //String uploadStatus = await uploadFile(filePath);
      setState(() {
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
        selectedFilePath = '';
        selectedFileName = ''; // 파일 선택이 취소된 경우 변수 초기화
        isFileSelected = false; // 파일 선택이 취소되었음을 표시
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('파일 선택 취소됨')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('강좌 추가'),
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
                        text: "출석부 등록하기/업데이트하기", onpress: _onButtonPressed),
                  ])
                ],
              ),
            ),
          ),
        ));
  }
}
