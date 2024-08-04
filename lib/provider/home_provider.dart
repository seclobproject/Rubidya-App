import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rubidya/support/dio_helper.dart';

import '../commonpage/enum.dart';
import '../networking/constant.dart';

final notificationsProvider =
ChangeNotifierProvider<NotificationsPageProvider>((ref) {
  return NotificationsPageProvider();
});

class NotificationsPageProvider extends ChangeNotifier {
  ContentLoadingStatus status = ContentLoadingStatus.initial;

  String? error;

  List _notifications = [];
  List get notifications => _notifications;

  Future loadContents({int page = 1, int limit = 7}) async {
    setError(null);

    try {
      log("",name:"START API");
      var dio = await DioHelper.getInstance();
      var response = await dio.get('$baseURL/api/posts/get-latest-posts?page=$page&limit=$limit');
      List notificationsList = response.data["posts"] ?? [];
      log(response.data.toString(),name:"TestLOG");
      _notifications = notificationsList;
      notifyListeners();
      setStatus(ContentLoadingStatus.completed);
    } catch (e) {
      log(e.toString(), name: "NotificationsPageProvider.loadingContents");
      setError(e.toString());
    }
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