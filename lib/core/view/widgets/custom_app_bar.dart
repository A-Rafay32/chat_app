import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../auth/view_model/auth.dart';

class CustomAppBar extends StatelessWidget {
  const CustomAppBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, left: 5, right: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
              onPressed: () {
                Scaffold.of(context).openDrawer();
                // _globalKey.currentState!.openDrawer();
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
            },
            icon: const Icon(color: Colors.white, Icons.search),
            // icon: const Icon(
            //   Icons.search,
            //   color: Colors.white,
            // )
          ),
        ],
      ),
    );
  }
}
