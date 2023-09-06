import 'package:chat_app/features/groups/view/user_tile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../core/model/data/database.dart';
import '../../../core/view/widgets/custom_app_bar.dart';
import '../../../res/colors.dart';
import '../model/group_database.dart';

class AddMemberScreen extends StatelessWidget {
  AddMemberScreen({super.key, required this.groupDocId});

  String groupDocId;

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.sizeOf(context).height;
    return Scaffold(
      backgroundColor: const Color(0xFF171717),
      body: Stack(
        children: [
          Column(
            children: [
              CustomAppBar(),
            ],
          ),
          Positioned(
              top: 70,
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
                              return GestureDetector(
                                onTap: () {
                                  //update group field of user
                                  GroupDB.addMemberInGroup(
                                      context :context,
                                      groupDocId: groupDocId,
                                      memberEmail: snapshot.data!.docs[index]["email"],
                                      memberName: snapshot.data!.docs[index]["name"]);
                                  Navigator.pop(context);
                                  //snackbar
                                  
                                },
                                child: UserTile(
                                  status: snapshot.data!.docs[index]["status"],
                                  name: snapshot.data!.docs[index]["name"],
                                  filename: snapshot.data!.docs[index]
                                      ["profileImg"],
                                ),
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
}
