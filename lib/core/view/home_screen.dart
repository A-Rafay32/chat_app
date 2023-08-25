import 'package:chat_app/core/view/widgets/conversation_row.dart';
import 'package:chat_app/core/view/widgets/custom_app_bar.dart';
import 'package:chat_app/core/view/widgets/custom_drawer.dart';
import 'package:chat_app/core/view/widgets/fav_contact_bar.dart';
import 'package:chat_app/core/view/widgets/tab_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../auth/view_model/auth.dart';
import '../model/data/database.dart';
import 'chat_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // final GlobalKey<ScaffoldState> _globalKey = GlobalKey();
  Map<String, dynamic> userMap = {};

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    const double fontSize = 16;
    const double width = 12;
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
                child: ListView(
                  padding: const EdgeInsets.only(left: 25),
                  children: [
                    GestureDetector(
                      onTap: () {},
                      child: ConversationRow(
                        name: 'Laura',
                        message: 'Hello, how are you',
                        filename: 'img1.jpeg',
                        msgCount: 0,
                        onTap: () async {
                          Map<String, dynamic> userMap =
                              await Database.getUser("Laura");
                          print(Provider.of<Auth>(context, listen: false)
                                  .auth
                                  .currentUser
                                  ?.displayName ??
                              "");
                          String roomId = Database.chatRoomId(
                              Provider.of<Auth>(context, listen: false)
                                      .auth
                                      .currentUser
                                      ?.displayName ??
                                  "",
                              "Laura");
                          Navigator.push(context, MaterialPageRoute(
                            builder: (context) {
                              return ChatScreen(
                                chatRoomId: roomId,
                                userMap: userMap,
                              );
                            },
                          ));
                        },
                      ),
                    ),
                    ConversationRow(
                      name: 'Kalya',
                      message: 'Will you visit me',
                      filename: 'img2.jpeg',
                      msgCount: 2,
                      onTap: () async {
                        Map<String, dynamic> userMap =
                            await Database.getUser("Kalya");
                        print(Provider.of<Auth>(context, listen: false)
                                .auth
                                .currentUser
                                ?.displayName ??
                            "");
                        String roomId = Database.chatRoomId(
                            Provider.of<Auth>(context, listen: false)
                                    .auth
                                    .currentUser
                                    ?.displayName ??
                                "",
                            "Kalya");
                        Navigator.push(context, MaterialPageRoute(
                          builder: (context) {
                            return ChatScreen(
                              chatRoomId: roomId,
                              userMap: userMap,
                            );
                          },
                        ));
                      },
                    ),
                    // ConversationRow('Mary', 'I ate your pussy', 'img3.jpeg', 6),
                    // ConversationRow(
                    //     'Hellen', 'Are you with Kayla again', 'img5.jpeg', 0),
                    // ConversationRow(
                    //     'Louren', 'Barrow money please', 'img6.jpeg', 3),
                    ConversationRow(
                        name: 'Tom',
                        message: 'Hey, whatsup',
                        filename: 'img7.jpeg',
                        msgCount: 0,
                        onTap: () async {
                          Map<String, dynamic> userMap =
                              await Database.getUser("Tom");
                          print(Provider.of<Auth>(context, listen: false)
                                  .auth
                                  .currentUser
                                  ?.displayName ??
                              "");
                          String roomId = Database.chatRoomId(
                              Provider.of<Auth>(context, listen: false)
                                      .auth
                                      .currentUser
                                      ?.displayName ??
                                  "",
                              "Tom");
                          Navigator.push(context, MaterialPageRoute(
                            builder: (context) {
                              return ChatScreen(
                                chatRoomId: roomId,
                                userMap: userMap,
                              );
                            },
                          ));
                        }),
                    // ConversationRow(
                    //     'Laura', 'Helle, how are you', 'img1.jpeg', 0),
                    // ConversationRow(
                    //     'Laura', 'Helle, how are you', 'img1.jpeg', 0),
                  ],
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
