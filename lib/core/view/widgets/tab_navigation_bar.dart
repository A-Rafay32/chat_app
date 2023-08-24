import 'package:flutter/material.dart';

class TabNavigationBar extends StatelessWidget {
  const TabNavigationBar({
    super.key,
    required this.fontSize,
    required this.width,
  });

  final double fontSize;
  final double width;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.only(left: 10),
        children: [
          TextButton(
              onPressed: () {},
              child: Text(
                "Messages",
                style: TextStyle(color: Colors.white, fontSize: fontSize),
              )),
          SizedBox(
            width: width,
          ),
          TextButton(
              onPressed: () {},
              child: Text(
                "Online",
                style: TextStyle(color: Colors.grey, fontSize: fontSize),
              )),
          SizedBox(
            width: width,
          ),
          TextButton(
              onPressed: () {},
              child: Text(
                "Groups",
                style: TextStyle(color: Colors.grey, fontSize: fontSize),
              )),
          SizedBox(
            width: width,
          ),
          TextButton(
              onPressed: () {},
              child: Text(
                "More",
                style: TextStyle(color: Colors.grey, fontSize: fontSize),
              )),
          SizedBox(
            width: width,
          ),
        ],
      ),
    );
  }
}
