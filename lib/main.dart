import 'package:chat_app/chat_screen.dart';
import 'package:chat_app/login/view/login.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import "package:flutter/foundation.dart";
import 'login/view_model/auth.dart';
import 'constants.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
        options: FirebaseOptions(
            apiKey: constants.apiKey,
            appId: constants.appId,
            messagingSenderId: constants.messagingSenderId,
            projectId: constants.projectId));
  } else {
    await Firebase.initializeApp();
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => Auth(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            drawerTheme: const DrawerThemeData(scrimColor: Colors.transparent)),
        title: 'Chat App',
        home: const LoginScreen(),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final GlobalKey<ScaffoldState> _globalKey = GlobalKey();
  Map<String, dynamic> userMap = {};

  String chatRoomId(String user1, String user2) {
    if (user1[0].toLowerCase().codeUnits[0] >
        user2[0].toLowerCase().codeUnits[0]) {
      return "$user1$user2";
    } else {
      return "$user2$user1";
    }
  }

  void getUser(String name) async {
    await Provider.of<Auth>(context, listen: false)
        .firestore
        .collection("users")
        .where("name", isEqualTo: name)
        .get()
        .then((value) {
      setState(() {
        userMap = value.docs[0].data();
      });
    });
    print(userMap);
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    const double fontSize = 16;
    const double width = 12;
    return Scaffold(
      key: _globalKey,
      backgroundColor: const Color(0xFF171717),
      body: Stack(
        children: [
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 20, left: 5, right: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                        onPressed: () {
                          _globalKey.currentState!.openDrawer();
                        },
                        icon: const Icon(
                          Icons.menu,
                          color: Color.fromARGB(255, 149, 136, 136),
                        )),
                    //   TextField(
                    //   controller: TextEditingController(),
                    //  )
                    // ,
                    IconButton(
                      onPressed: () {
                        Provider.of<Auth>(context, listen: false).signOut();
                        Navigator.pop(context);
                      },
                      icon: const Icon(color: Colors.white, Icons.search),
                      // icon: const Icon(
                      //   Icons.search,
                      //   color: Colors.white,
                      // )
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 50,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.only(left: 10),
                  children: [
                    TextButton(
                        onPressed: () {},
                        child: const Text(
                          "Messages",
                          style: TextStyle(
                              color: Colors.white, fontSize: fontSize),
                        )),
                    const SizedBox(
                      width: width,
                    ),
                    TextButton(
                        onPressed: () {},
                        child: const Text(
                          "Online",
                          style:
                              TextStyle(color: Colors.grey, fontSize: fontSize),
                        )),
                    const SizedBox(
                      width: width,
                    ),
                    TextButton(
                        onPressed: () {},
                        child: const Text(
                          "Groups",
                          style:
                              TextStyle(color: Colors.grey, fontSize: fontSize),
                        )),
                    const SizedBox(
                      width: width,
                    ),
                    TextButton(
                        onPressed: () {},
                        child: const Text(
                          "More",
                          style:
                              TextStyle(color: Colors.grey, fontSize: fontSize),
                        )),
                    const SizedBox(
                      width: width,
                    ),
                  ],
                ),
              )
            ],
          ),
          Positioned(
            top: 130,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.only(top: 15, left: 25, right: 25),
              height: 260,
              decoration: const BoxDecoration(
                  color: Color(0xFF27c1a9),
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(40),
                      topRight: Radius.circular(40))),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Favorite contacts",
                        style: TextStyle(color: Colors.white),
                      ),
                      IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.more_horiz,
                            color: Colors.white,
                          )),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    height: 90,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        buildContactAvatar('Alla', 'img1.jpeg'),
                        buildContactAvatar('July', 'img2.jpeg'),
                        buildContactAvatar('Mikle', 'img3.jpeg'),
                        buildContactAvatar('Kler', 'img4.jpg'),
                        buildContactAvatar('Moane', 'img5.jpeg'),
                        buildContactAvatar('Julie', 'img6.jpeg'),
                        buildContactAvatar('Allen', 'img7.jpeg'),
                        buildContactAvatar('John', 'img8.jpg'),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
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
                      child: buildConversationRow(
                          'Laura', 'Hello, how are you', 'img1.jpeg', 0),
                    ),
                    buildConversationRow(
                        'Kalya', 'Will you visit me', 'img2.jpeg', 2),
                    buildConversationRow(
                        'Mary', 'I ate your pussy', 'img3.jpeg', 6),
                    buildConversationRow(
                        'Hellen', 'Are you with Kayla again', 'img5.jpeg', 0),
                    buildConversationRow(
                        'Louren', 'Barrow money please', 'img6.jpeg', 3),
                    buildConversationRow('Tom', 'Hey, whatsup', 'img7.jpeg', 0),
                    buildConversationRow(
                        'Laura', 'Helle, how are you', 'img1.jpeg', 0),
                    buildConversationRow(
                        'Laura', 'Helle, how are you', 'img1.jpeg', 0),
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
      drawer: Drawer(
        width: 275,
        elevation: 30,
        backgroundColor: const Color.fromRGBO(57, 56, 56, 0.953),
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.horizontal(right: Radius.circular(40))),
        child: Container(
          decoration: const BoxDecoration(
              borderRadius: BorderRadius.horizontal(right: Radius.circular(40)),
              boxShadow: [
                BoxShadow(
                    color: Color(0x3D000000), spreadRadius: 30, blurRadius: 20)
              ]),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 50, 20, 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Row(
                      children: const [
                        Icon(
                          Icons.arrow_back_ios,
                          color: Colors.white,
                          size: 20,
                        ),
                        SizedBox(
                          width: 56,
                        ),
                        Text(
                          'Settings',
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Row(
                      children: [
                        const UserAvatar(filename: 'img3.jpeg'),
                        const SizedBox(
                          width: 12,
                        ),
                        Text(
                          '${Provider.of<Auth>(context, listen: false).auth.currentUser?.email}',
                          style: const TextStyle(color: Colors.white),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 35,
                    ),
                    const DrawerItem(
                      title: 'Account',
                      icon: Icons.key,
                    ),
                    const DrawerItem(title: 'Chats', icon: Icons.chat_bubble),
                    const DrawerItem(
                        title: 'Notifications', icon: Icons.notifications),
                    const DrawerItem(
                        title: 'Data and Storage', icon: Icons.storage),
                    const DrawerItem(title: 'Help', icon: Icons.help),
                    const Divider(
                      height: 35,
                      color: Colors.green,
                    ),
                    const DrawerItem(
                        title: 'Invite a friend', icon: Icons.people_outline),
                  ],
                ),
                GestureDetector(
                  onTap: () {
                    Provider.of<Auth>(context, listen: false).signOut();
                    Navigator.pop(context);
                  },
                  child: Row(
                    children: const [
                      Icon(color: Colors.white, Icons.logout),
                      SizedBox(
                        width: 30,
                      ),
                      Text(
                        'Log out',
                        style: TextStyle(
                          color: Colors.white,
                          // fontSize: 22,
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Column buildConversationRow(
      String name, String message, String filename, int msgCount) {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            getUser(name);
            print(Provider.of<Auth>(context, listen: false)
                    .auth
                    .currentUser
                    ?.displayName ??
                "");
            String roomId = chatRoomId(
                Provider.of<Auth>(context, listen: false)
                        .auth
                        .currentUser
                        ?.displayName ??
                    "",
                userMap["name"]);
            Navigator.push(context, MaterialPageRoute(
              builder: (context) {
                return ChatScreen(
                  chatRoomId: roomId,
                  userMap: userMap,
                );
              },
            ));
          },
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  UserAvatar(filename: filename),
                  const SizedBox(
                    width: 15,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: const TextStyle(color: Colors.grey),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                        message,
                        style: const TextStyle(color: Colors.black),
                      ),
                    ],
                  )
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(right: 25, top: 5),
                child: Column(
                  children: [
                    const Text(
                      '16:35',
                      style: TextStyle(fontSize: 10),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    if (msgCount > 0)
                      CircleAvatar(
                        radius: 7,
                        backgroundColor: const Color(0xFF27c1a9),
                        child: Text(
                          msgCount.toString(),
                          style: const TextStyle(
                              fontSize: 10, color: Colors.white),
                        ),
                      )
                  ],
                ),
              )
            ],
          ),
        ),
        const Divider(
          indent: 70,
          height: 20,
        )
      ],
    );
  }

  Padding buildContactAvatar(String name, String filename) {
    return Padding(
      padding: const EdgeInsets.only(right: 20.0),
      child: Column(
        children: [
          UserAvatar(
            filename: filename,
          ),
          const SizedBox(
            height: 5,
          ),
          Text(
            name,
            style: const TextStyle(color: Colors.white, fontSize: 16),
          )
        ],
      ),
    );
  }
}

class DrawerItem extends StatelessWidget {
  final String title;
  final IconData icon;
  const DrawerItem({
    super.key,
    required this.title,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Padding(
        padding: const EdgeInsets.only(bottom: 25),
        child: Row(
          children: [
            Icon(
              icon,
              color: Colors.white,
              size: 20,
            ),
            const SizedBox(
              width: 40,
            ),
            Text(
              title,
              style: const TextStyle(color: Colors.white, fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}

class UserAvatar extends StatelessWidget {
  final String filename;
  const UserAvatar({
    super.key,
    required this.filename,
  });

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 27,
      backgroundColor: Colors.white,
      child: CircleAvatar(
        radius: 27,
        backgroundImage: Image.asset('assets/images/$filename').image,
      ),
    );
  }
}
