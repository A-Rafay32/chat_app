import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget {
  CustomAppBar({
    super.key,
  });
  final FocusNode focusNode = FocusNode();
  final TextEditingController controller = TextEditingController();

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
            onPressed: () => focusNode.requestFocus(),
            icon: const Icon(color: Colors.white, Icons.search),
          ),
        ],
      ),
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
