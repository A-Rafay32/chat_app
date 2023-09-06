import 'package:chat_app/core/model/model.dart';
import 'package:chat_app/core/view/chat_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../auth/view_model/auth.dart';
import '../../features/groups/view/user_tile.dart';
import '../../res/colors.dart';
import '../model/data/database.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController searchController = TextEditingController();

  Stream<QuerySnapshot>? searchStream;
  String searchedValue = "";

  void initSearch() {
    if (searchedValue == "") {
      searchStream = Database.usersCollection.snapshots();
    } else {
      searchStream = Database.usersCollection
          .where("name", isEqualTo: searchedValue)
          .snapshots();
    }
  }

  @override
  void initState() {
    initSearch();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.sizeOf(context).height;
    // double w = MediaQuery.sizeOf(context).height;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFF171717),
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back_ios_new_sharp)),
      ),
      backgroundColor: const Color(0xFF171717),
      body: Stack(
        children: [
          Container(
            padding: const EdgeInsets.only(
              top: 0,
              left: 5,
              right: 5,
            ),
            child: Column(
              children: [
                const Center(
                  child: Text(
                    "Search Your Contacts",
                    style: TextStyle(
                        fontSize: 21,
                        fontWeight: FontWeight.w500,
                        color: Colors.white),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                TextField(
                  style: const TextStyle(color: Colors.white),
                  onSubmitted: (value) {},
                  onChanged: (value) {
                    setState(() {
                      searchedValue = value;
                      // Update the searchStream with the new query
                      searchStream = Database.usersCollection
                          .where("name", isEqualTo: searchedValue)
                          .snapshots();
                    });
                  },
                  cursorColor: Colors.white,
                  controller: searchController,
                  decoration: TextFieldDecoration(),
                ),
              ],
            ),
          ),
          Positioned(
              top: 120,
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
                  stream: searchStream,
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
                    if (snapshot.hasError) {
                      // Handle errors
                      return Text('Error: ${snapshot.error.toString()}');
                    }
                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return Column(
                        children: [
                          const SizedBox(
                            height: 300,
                          ),
                          Container(
                            child: const Text(
                              "User Doesnot exist",
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                        ],
                      );
                    }

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
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () async {
                                //get other user
                                Map<String, dynamic> userMap =
                                    await Database.getUser(
                                        snapshot.data!.docs[index]["name"]);
                                print(
                                    Auth().auth.currentUser?.displayName ?? "");

                                // generate roomId with them
                                String roomId = Database.chatRoomId(
                                    Auth().auth.currentUser?.displayName ?? "",
                                    snapshot.data!.docs[index]["name"]);

                                //navigate
                                if (!context.mounted) return;
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ChatScreen(
                                          documentId: roomId,
                                          objectMap: userMap,
                                          chatType: ChatType.one2one),
                                    ));
                              },
                              child: UserTile(
                                status: snapshot.data?.docs[index]["status"],
                                name: snapshot.data?.docs[index]["name"],
                                filename: snapshot.data?.docs[index]
                                    ["profileImg"],
                              ),
                            );
                          }),
                    );
                  },
                ),
              ))
        ],
      ),
    );
  }

  InputDecoration TextFieldDecoration() {
    return InputDecoration(
      contentPadding: const EdgeInsets.symmetric(horizontal: 25, vertical: 8),
      hintText: "Search",
      suffixIcon: IconButton(
        onPressed: () {},
        icon: const Icon(Icons.search),
        color: Colors.grey,
      ),
      hintStyle: const TextStyle(color: Colors.white60, fontSize: 17),
      border: const UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.white),
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      enabledBorder: const UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.white),
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      focusedBorder: const UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.white),
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
    );
  }
}
