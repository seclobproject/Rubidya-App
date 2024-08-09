import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../commonpage/enum.dart';
import '../services/Chat_service.dart';

final chatProvider = ChangeNotifierProvider<ChatPageProvider>((ref) {
  return ChatPageProvider();
});

class ChatPageProvider extends ChangeNotifier {
  ContentLoadingStatus status = ContentLoadingStatus.initial;

  String? error;

  List _chats = [];
  List get chats => _chats;

  Future loadContents() async {
    setError(null);

    try {
      var response = await ChatService.getChatHistory(page: 1, limit: 30);

      List chatList = response['conversationData'] ?? [];
      _chats = chatList;
      notifyListeners();
      setStatus(ContentLoadingStatus.completed);
    } catch (e) {
      log(e.toString(), name: "ChatPageProvider.loadingContents");
      setError(e.toString());
    }
  }

  String? getConversationId(String userId) {
    String? conversationId;
    for (var chat in _chats) {
      if (chat['userId'] == userId) {
        conversationId = chat['_id'];
        break;
      }
    }
    return conversationId;
  }

  void setStatus(ContentLoadingStatus _status) {
    status = _status;
    notifyListeners();
  }

  void setError(String? _error) {
    error = _error;
    if (error != null) {
      status = ContentLoadingStatus.error;
    }

    notifyListeners();
  }
}
