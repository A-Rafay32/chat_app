import 'package:chat_app/auth/helper.dart';
import 'package:chat_app/auth/view/login.dart';
import 'package:chat_app/core/view/home_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import "package:flutter/foundation.dart";
import 'auth/view_model/auth.dart';
import 'utils/constants.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
        options: FirebaseOptions(
            apiKey: constants.apiKey,
            appId: constants.appId,
            messagingSenderId: constants.messagingSenderId,
            projectId: constants.projectId));
  } else {
    await Firebase.initializeApp();
  }

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    Helper.isSignedIn();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => Auth(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            drawerTheme: const DrawerThemeData(scrimColor: Colors.transparent)),
        title: 'Chat App',
        home: Auth().isSignedIn != true
            ? const LoginScreen()
            : const HomeScreen(),
      ),
    );  
  }
}
