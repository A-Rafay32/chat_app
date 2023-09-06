import 'package:flutter/material.dart';

import '../../../features/groups/view/group_screen.dart';
import '../home_screen.dart';

class TabNavigationBar extends StatefulWidget {
  const TabNavigationBar({
    super.key,
    required this.fontSize,
    required this.width,
  });

  final double fontSize;
  final double width;

  @override
  State<TabNavigationBar> createState() => _TabNavigationBarState();
}

class _TabNavigationBarState extends State<TabNavigationBar> {
  List<String> buttonText = ["Messages", "Online", "Groups", "More"];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.only(left: 10),
        itemCount: buttonText.length,
        itemBuilder: (context, index) => TextButton(
            onPressed: () {
              buttonText[index] == "Messages"
                  ? Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const HomeScreen(),
                      ))
                  : buttonText[index] == "Groups"
                      ? Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const GroupScreen(),
                          ))
                      : null;
              setState(() {
                TabBarIndex.tabBarIndex = index;
              });
            },
            child: Text(
              buttonText[index],
              style: TextStyle(
                  color: TabBarIndex.tabBarIndex == index
                      ? Colors.white
                      : Colors.grey,
                  fontSize: widget.fontSize),
            )),
      ),
    );
  }
}

class TabBarIndex {
  static int tabBarIndex = 0;
}
