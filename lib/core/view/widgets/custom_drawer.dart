import 'package:chat_app/core/view/widgets/user_avatar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../auth/view_model/auth.dart';
import 'drawer_item.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
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
                  const Row(
                    children: [
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
                child: const Row(
                  children: [
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
    );
  }
}
