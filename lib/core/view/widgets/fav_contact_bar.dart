import 'package:flutter/material.dart';

import '../../model/data/database.dart';
import 'contact_avatar.dart';

class FavContactsBar extends StatelessWidget {
  const FavContactsBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 60,
      left: 0,
      right: 0,
      child: Container(
        padding: const EdgeInsets.only(top: 15, left: 25, right: 25),
        height: 260,
        decoration: const BoxDecoration(
            color: Color(0xFF27c1a9),
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(40), topRight: Radius.circular(40))),
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
              child: StreamBuilder(
                  stream: Database.usersCollection.limit(6).snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return ListView.builder(
                        itemCount: snapshot.data?.docs.length,
                        itemBuilder: (context, index) {
                          return ContactAvatar(
                              name: snapshot.data?.docs[index]["name"],
                              filename: snapshot.data?.docs[index]
                                  ["profileImg"]);
                        },
                        scrollDirection: Axis.horizontal,
                      );
                    } else {
                      return Container();
                    }
                  }),
            )
          ],
        ),
      ),
    );
  }
}
