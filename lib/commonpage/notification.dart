import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rubidya/resources/color.dart';
import 'package:rubidya/services/home_service.dart';
import 'package:rubidya/support/logger.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({Key? key}) : super(key: key);

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  List<dynamic> notifications = [];
  bool isLoading = true;
  bool _isFetchingMore = false;
  int _currentPage = 1;
  bool _isLastPage = false;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _fetchNotifications();
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent && !_isFetchingMore && !_isLastPage) {
      _fetchNotifications();
    }
  }

  Future<void> _fetchNotifications({bool reset = false}) async {
    if (_isFetchingMore) return;
    if (reset) {
      setState(() {
        _currentPage = 1;
        _isLastPage = false;
        notifications.clear();
      });
    }
    if (_isLastPage) return;

    setState(() {
      _isFetchingMore = true;
    });

    try {
      var response = await HomeService.getActivityNotification(page: _currentPage, limit: 10);
      log.i('API Request: page $_currentPage');
      log.i('API Response: $response');

      if (response['notifications'] != null && response['notifications'].isNotEmpty) {
        setState(() {
          notifications.addAll(response['notifications']);
          log.i('Current Notifications: $notifications');
          if (response['notifications'].length < 10) {
            _isLastPage = true;
          }
          _currentPage++;
        });
      } else {
        setState(() {
          _isLastPage = true;
        });
      }
    } catch (e) {
      log.e('Failed to fetch notifications: $e');
    } finally {
      setState(() {
        isLoading = false;
        _isFetchingMore = false;
      });
    }
  }

  String formatTime(String dateTime) {
    DateTime time = DateTime.parse(dateTime);
    return DateFormat.yMMMd().add_jm().format(time);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          "Notifications",
          style: TextStyle(fontSize: 14),
        ),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : notifications.isEmpty
          ? Center(child: Text("No notifications available"))
          : NotificationListView(
        notifications: notifications,
        isLoadingMore: _isFetchingMore,
        formatTime: formatTime,
        scrollController: _scrollController,
      ),
    );
  }
}

class NotificationListView extends StatelessWidget {
  final List<dynamic> notifications;
  final bool isLoadingMore;
  final Function(String) formatTime;
  final ScrollController scrollController;

  NotificationListView({
    required this.notifications,
    required this.isLoadingMore,
    required this.formatTime,
    required this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: notifications.length + (isLoadingMore ? 1 : 0),
      controller: scrollController,
      itemBuilder: (context, index) {
        if (index < notifications.length) {
          var notification = notifications[index];
          return Card(
            color: bluetext,
            child: ListTile(
              leading: notification['profilePic'] != null
                  ? CircleAvatar(
                backgroundImage: NetworkImage(notification['profilePic']),
              )
                  : CircleAvatar(
                child: Icon(Icons.person),
              ),
              title: Text(
                notification['user'],
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
              ),
              subtitle: Text(
                notification['message'],
                style: TextStyle(color: Colors.white),
              ),
              trailing: Text(
                formatTime(notification['time']),
                style: TextStyle(color: Colors.white),
              ),
            ),
          );
        } else {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
    );
  }
}
