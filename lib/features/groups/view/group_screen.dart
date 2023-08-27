import 'package:chat_app/core/model/model.dart';
import 'package:chat_app/core/view/chat_screen.dart';
import 'package:chat_app/core/view/widgets/conversation_row.dart';
import 'package:chat_app/core/view/widgets/custom_app_bar.dart';
import 'package:chat_app/core/view/widgets/custom_drawer.dart';
import 'package:chat_app/core/view/widgets/tab_navigation_bar.dart';
import 'package:chat_app/features/groups/model/group_database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../res/colors.dart';
import '../model/group_model.dart';

class GroupScreen extends StatefulWidget {
  const GroupScreen({super.key});

  @override
  State<GroupScreen> createState() => _GroupScreenState();
}

class _GroupScreenState extends State<GroupScreen> {
  @override
  void initState() {
    GroupDB.getGroups();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    const double fontSize = 16;
    const double width = 12;
    double h = MediaQuery.sizeOf(context).height;
    return Scaffold(
      backgroundColor: const Color(0xFF171717),
      body: Stack(
        children: [
          const Column(
            children: [
              CustomAppBar(),
              TabNavigationBar(fontSize: fontSize, width: width)
            ],
          ),
          Positioned(
              top: 130,
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 15),
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(40),
                      topRight: Radius.circular(40)),
                  color: Color(0xFFEFFFFC),
                ),
                child: StreamBuilder<QuerySnapshot>(
                  // padding: const EdgeInsets.only(left: 25),
                  stream: GroupDB.groupCollection.snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Column(
                        children: [
                          SizedBox(
                            height: h * 0.3,
                          ),
                          const SizedBox(
                            height: 30,
                            width: 30,
                            child:
                                CircularProgressIndicator(color: primaryColor),
                          ),
                        ],
                      );
                    }
                    if (snapshot.hasData) {
                      return Container(
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(40),
                              topRight: Radius.circular(40)),
                          color: Color(0xFFEFFFFC),
                        ),
                        child: ListView.builder(
                          itemCount: GroupDB.groupList?.length ?? 0,
                          itemBuilder: (context, index) => ConversationRow(
                              time: GroupDB
                                  .groupList![index].recentMessage.time.seconds
                                  .toString(),
                              name: GroupDB.groupList![index].groupName,
                              message:
                                  GroupDB.groupList![index].recentMessage.text,
                              filename: GroupDB.groupList![index].groupImg,
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ChatScreen(
                                          chatType: ChatType.group,
                                          chatRoomId: GroupDB
                                              .groupList![index].groupRoomId,
                                          userMap: Group.toMap(
                                              GroupDB.groupList![index])),
                                    ));
                              },
                              msgCount: 0),
                        ),
                      );
                    } else {
                      return Container();
                    }
                  },
                ),
              ))
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: SizedBox(
        height: 55,
        width: 55,
        child: FloatingActionButton(
          backgroundColor: const Color(0xFF27c1a9),
          child: const Icon(
            Icons.edit_outlined,
            size: 28,
          ),
          onPressed: () {},
        ),
      ),
      drawer: const CustomDrawer(),
    );
  }
}
