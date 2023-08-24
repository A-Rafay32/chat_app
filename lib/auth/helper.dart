import 'package:chat_app/auth/view_model/auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Helper {
  static SharedPreferences? authPref;
  static String userKey = "USERKEY";

  static void setUserSignedStatus(bool value) async {
    authPref = await SharedPreferences.getInstance();
    authPref?.setBool(userKey, value);
  }

  static Future<bool> getUserSignedStatus() async {
    authPref = await SharedPreferences.getInstance();
    print("SignedIn :  ${authPref?.getBool(userKey)}");
    return authPref?.getBool(userKey) ?? false;
  }

  static void isSignedIn() async {
    Auth().isSignedIn = await getUserSignedStatus();
  }
}
