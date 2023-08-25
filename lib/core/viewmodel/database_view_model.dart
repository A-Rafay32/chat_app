import 'package:chat_app/core/model/data/database.dart';
import 'package:flutter/material.dart';

class DBViewModel extends ChangeNotifier {
  void onSendMessage(chatRoomId) {
    Database.onSendMessage(chatRoomId);
    
    notifyListeners();
  }
}
