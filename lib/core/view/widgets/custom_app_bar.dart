import 'package:flutter/material.dart';

import '../search_screen.dart';

class CustomAppBar extends StatelessWidget {
  CustomAppBar({
    super.key,
  });
  final FocusNode focusNode = FocusNode();
  final TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: const Color(0xFF171717),
      elevation: 0,
      actions: [
        IconButton(
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SearchScreen(),
                ));
          },
          icon: const Icon(color: Colors.white, Icons.search),
        ),
      ],
    );
  }

  TextField searchTextField(controller) {
    return TextField(
      focusNode: focusNode,
      controller: controller,
      decoration: TextFieldDecoration(),
    );
  }

  InputDecoration TextFieldDecoration() {
    return const InputDecoration(
      border: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.black54),
        gapPadding: 10,
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.black54),
        gapPadding: 10,
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.black54),
        gapPadding: 10,
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
    );
  }
}
