import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

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
  QuerySnapshot? searchResult;
  String searchedValue = "";
  List<Map<String, dynamic>> searchMap = [];

  void init() async {
    if (searchedValue == "") {
      print(Database.usersCollection.path);
      searchResult = await Database.usersCollection.get();
    } else {
      searchResult = await Database.usersCollection
          .where("name", isEqualTo: searchedValue)
          .limit(1)
          .get();
    }
    for (int i = 0; i < searchResult!.docs.length; ++i) {
      searchMap.add(searchResult!.docs[i].data() as Map<String, dynamic>);
    }

    print("searchMap : $searchMap");
  }

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
    init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.sizeOf(context).height;
    // double w = MediaQuery.sizeOf(context).height;
    return Scaffold(
      appBar: AppBar(
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
              top: 20,
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
                TextField(
                  style: const TextStyle(color: Colors.white),
                  onSubmitted: (value) {
                    // searchedValue = value;
                    // print(searchedValue);
                    // searchStream = Database.usersCollection
                    //     .where("name", isEqualTo: searchedValue)
                    //     .snapshots();
                  },
                  onChanged: (value) {
                    searchedValue = value;
                    print(searchedValue);
                    init();
                    // searchStream = Database.usersCollection
                    //     .where("name", isEqualTo: searchedValue)
                    //     .snapshots();

                    // searchMap =
                    //     searchResult!.docs.first.data() as Map<String, dynamic>;
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
                // child: Text(searchMap[0]["name"])
                // ListView.builder(
                //     padding: const EdgeInsets.only(left: 25),
                //     itemCount: searchMap.length,
                //     itemBuilder: (context, index) {
                //       print(searchMap.length);
                //       print(searchMap[index]["status"]);
                //       print(searchMap[index]["name"]);
                //       print(searchMap[index]["profileImg"]);

                // UserTile(
                //   status: searchMap[index]["status"],
                //   name: searchMap[index]["name"],
                //   filename: searchMap[index]["profileImg"],
                // );
                // }),

                child: StreamBuilder(
                  stream: Database.usersCollection.snapshots(),
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
                            itemCount: snapshot.data!.docs.length,
                            itemBuilder: (context, index) {
                              return UserTile(
                                status: snapshot.data?.docs[index]["status"],
                                name: snapshot.data?.docs[index]["name"],
                                filename: snapshot.data?.docs[index]
                                    ["profileImg"],
                              );
                            }),
                      );
                    } else {
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
