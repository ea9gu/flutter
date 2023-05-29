import 'package:flutter/material.dart';
import 'package:ea9gu/constants.dart';

class BackButton1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        Icons.arrow_back,
        color: mainColor, // 보라색으로 변경
      ),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
  }
}

class TransparentAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: BackButton1(),
      backgroundColor: Colors.transparent, // 투명한 색상
      elevation: 0, // 그림자 제거
    );
  }
}
