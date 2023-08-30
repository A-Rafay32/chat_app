import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../features/groups/view/user_tile.dart';
import '../../res/colors.dart';
import '../model/data/database.dart';

class SearchScreen extends StatelessWidget {
  SearchScreen({super.key});

  TextEditingController searchController = TextEditingController();
  String? name;
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
                  onChanged: (value) {
                    name = value;
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
                child: StreamBuilder<QuerySnapshot>(
                  // padding: const EdgeInsets.only(left: 25),
                  stream: Database.usersCollection
                      .where("name", isEqualTo: name)
                      .snapshots(),
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
                                status: snapshot.data!.docs[index]["status"],
                                name: snapshot.data!.docs[index]["name"],
                                filename: snapshot.data!.docs[index]
                                    ["profileImg"],
                              );
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
    );
  }

  InputDecoration TextFieldDecoration() {
    return const InputDecoration(
      contentPadding: EdgeInsets.symmetric(horizontal: 25, vertical: 8),
      hintText: "Search",
      hintStyle: TextStyle(color: Colors.white60, fontSize: 17),
      border: UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.white),
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      enabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.white),
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.white),
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
    );
  }
}
