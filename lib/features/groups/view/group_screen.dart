import 'package:chat_app/core/view/widgets/conversation_row.dart';
import 'package:chat_app/core/view/widgets/custom_app_bar.dart';
import 'package:chat_app/core/view/widgets/custom_drawer.dart';
import 'package:chat_app/core/view/widgets/tab_navigation_bar.dart';
import 'package:chat_app/features/groups/group_utils.dart';
import 'package:chat_app/features/groups/model/group_database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../core/model/model.dart';
import '../../../core/view/chat_screen.dart';
import '../../../res/colors.dart';

class GroupScreen extends StatefulWidget {
  const GroupScreen({super.key});

  @override
  State<GroupScreen> createState() => _GroupScreenState();
}

class _GroupScreenState extends State<GroupScreen> {
  TextEditingController controller = TextEditingController();
  @override
  void initState() {
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
          Column(
            children: [
              CustomAppBar(),
              const TabNavigationBar(fontSize: fontSize, width: width)
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
                            padding: const EdgeInsets.only(left: 25),
                            itemCount: snapshot.data?.docs.length,
                            itemBuilder: (context, index) {
                              Timestamp time = snapshot.data?.docs[index]
                                  ["recentMsg"]["time"];
                              return ConversationRow(
                                  time: time.seconds.toString(),
                                  name: snapshot.data?.docs[index]["groupName"],
                                  message: snapshot.data?.docs[index]
                                      ["recentMsg"]["text"],
                                  filename: snapshot.data?.docs[index]
                                      ["groupImg"],
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => ChatScreen(
                                              chatType: ChatType.group,
                                              documentId:
                                                  snapshot.data!.docs[index].id,
                                              objectMap: snapshot
                                                      .data!.docs[index]
                                                      .data()
                                                  as Map<String, dynamic>),
                                        ));
                                  },
                                  msgCount: 0);
                            }),
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
            Icons.add,
            size: 28,
          ),
          onPressed: () async {
            await showCreateGroupDialog(context, controller);
          },
        ),
      ),
      drawer: const CustomDrawer(),
    );
  }
}
