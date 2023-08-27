import 'package:chat_app/core/view/widgets/conversation_row.dart';
import 'package:chat_app/core/view/widgets/custom_app_bar.dart';
import 'package:chat_app/core/view/widgets/custom_drawer.dart';
import 'package:chat_app/core/view/widgets/fav_contact_bar.dart';
import 'package:chat_app/core/view/widgets/tab_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../auth/view_model/auth.dart';
import '../model/data/database.dart';
import '../model/model.dart';
import 'chat_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    Database.getUsersList();
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
          const FavContactsBar(),
          Positioned(
              top: 290,
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
                child: StreamBuilder(
                    stream: Database.usersCollection.snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return ListView.builder(
                          padding: const EdgeInsets.only(left: 25),
                          itemCount: Database.userList!.length,
                          itemBuilder: (context, index) => ConversationRow(
                            time: Database
                                .userList![index].recentMsg.time.seconds
                                .toString(),
                            name: Database.userList![index].name,
                            message: Database.userList![index].recentMsg.text,
                            filename: Database.userList![index].profileImg,
                            msgCount: 0,
                            onTap: () async {
                              //get other user
                              Map<String, dynamic> userMap =
                                  await Database.getUser(
                                      snapshot.data!.docs[index]["name"]);
                              print(Auth().auth.currentUser?.displayName ?? "");

                              // generate roomId with them
                              String roomId = Database.chatRoomId(
                                  Auth().auth.currentUser?.displayName ?? "",
                                  snapshot.data!.docs[index]["name"]);

                              //navigate
                              Navigator.push(context, MaterialPageRoute(
                                builder: (context) {
                                  return ChatScreen(
                                    chatType: ChatType.one2one,
                                    chatRoomId: roomId,
                                    userMap: userMap,
                                  );
                                },
                              ));
                            },
                          ),
                        );
                      } else {
                        return Column(
                          children: [
                            SizedBox(
                              height: h * 0.1,
                            ),
                            SvgPicture.asset(
                              "assets/icons/box.svg",
                              height: 50,
                              width: 50,
                              colorFilter: const ColorFilter.mode(
                                  Colors.grey, BlendMode.dstIn),
                            )
                          ],
                        );
                      }
                    }),
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
