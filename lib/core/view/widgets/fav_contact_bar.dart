import 'package:flutter/material.dart';

import 'contact_avatar.dart';

class FavContactsBar extends StatelessWidget {
  const FavContactsBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 130,
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
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: const [
                  ContactAvatar(name: 'Alla', filename: 'img1.jpeg'),
                  ContactAvatar(name: 'July', filename: 'img2.jpeg'),
                  ContactAvatar(name: 'Mikle', filename: 'img3.jpeg'),
                  ContactAvatar(name: 'Kler', filename: 'img4.jpg'),
                  ContactAvatar(name: 'Moane', filename: 'img5.jpeg'),
                  ContactAvatar(name: 'Julie', filename: 'img6.jpeg'),
                  ContactAvatar(name: 'Allen', filename: 'img7.jpeg'),
                  ContactAvatar(name: 'John', filename: 'img8.jpg'),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
