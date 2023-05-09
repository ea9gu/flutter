import 'package:flutter/material.dart';

class SecondPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
      appBar: AppBar(title: Text('앱')),
      body: Align(
          alignment: Alignment.center,
          child: Column(children: [
            Image.asset('assets/sample.jpg'),
            Text(
              "Explore the app",
              style: TextStyle(
                fontSize: 30,
              ),
            ),
            Container(
                margin: EdgeInsets.all(10),
                width: 300,
                height: 120,
                child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xffC7C0CE)),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                              margin: EdgeInsets.all(20),
                              padding: EdgeInsets.only(right: 40),
                              child: Image.asset('assets/pro.png')),
                          Text("교수용")
                        ]))),
            Container(
                margin: EdgeInsets.all(10),
                width: 300,
                height: 120,
                child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xff5B587E)),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                              margin: EdgeInsets.all(20),
                              padding: EdgeInsets.only(right: 40),
                              child: Image.asset('assets/stu.png')),
                          Text("학생용")
                        ]))),
          ])),
      bottomNavigationBar: BottomAppBar(
        child: Container(
          height: 70,
          child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Icon(Icons.phone),
                Icon(Icons.message),
                Icon(Icons.contact_page)
              ]),
        ),
      ),
    ));
  }
}
