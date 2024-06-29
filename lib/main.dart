import 'package:flutter/material.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:uni_links/uni_links.dart';
import 'dart:async';

// import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:workmanager/workmanager.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rubidya/screens/home_screen/widgets/single_post.dart';
import 'authentication_page/splash.dart';

void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    if (inputData != null) {
      await showBackgroundNotification(
        inputData['user'],
        inputData['message'],
        inputData['notificationType'],
        inputData['time'],
      );
    }
    return Future.value(false);
  });
}

Future<void> showBackgroundNotification(
    String user, String message, String notificationType, String time) async {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');
  final InitializationSettings initializationSettings = InitializationSettings(android: initializationSettingsAndroid);
  await flutterLocalNotificationsPlugin.initialize(initializationSettings);

  const AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
    'your_channel_id', 'your_channel_name',
    channelDescription: 'your_channel_description',
    importance: Importance.max,
    priority: Priority.high,
    showWhen: false,
  );
  const NotificationDetails platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics);
  await flutterLocalNotificationsPlugin.show(
    0,
    '$user $notificationType',
    message,
    platformChannelSpecifics,
    payload: 'item x',
  );
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp(); // Initialize Firebase
  Workmanager().initialize(callbackDispatcher, isInDebugMode: false); // Initialize WorkManager
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  StreamSubscription? _sub;
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  void initState() {
    super.initState();
    checkForUpdate();
    initUniLinks(context);
     // Setup Firebase Messaging
  }

  Future<void> checkForUpdate() async {
    print('Checking for update');
    try {
      final info = await InAppUpdate.checkForUpdate();
      if (info.updateAvailability == UpdateAvailability.updateAvailable) {
        print('Update available');
        await update();
      } else {
        print('No update available');
      }
    } catch (e) {
      print('Error checking for update: $e');
    }
  }

  Future<void> update() async {
    print('Updating');
    try {
      await InAppUpdate.startFlexibleUpdate();
      await InAppUpdate.completeFlexibleUpdate();
      print('Update completed');
    } catch (e) {
      print('Error updating: $e');
    }
  }

  Future<void> initUniLinks(BuildContext context) async {
    try {
      final initialLink = await getInitialLink();
      if (initialLink != null) {
        print('Initial link received: $initialLink');
        handleIncomingLink(context, initialLink); // Pass context to handleIncomingLink
      } else {
        print('No initial link received');
      }
    } catch (e) {
      print('Error getting initial link: $e');
    }

    _sub = linkStream.listen((String? link) {
      if (link != null) {
        print('Link received: $link');
        handleIncomingLink(context, link); // Pass context to handleIncomingLink
      } else {
        print('Empty link received');
      }
    }, onError: (err) {
      print('Error receiving link: $err');
    });
  }

  // void setupFirebaseMessaging() {
  //   FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler); // Set background handler
  //   FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
  //     alert: true,
  //     badge: true,
  //     sound: true,
  //   );
  // }

  // static Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  //   print("Handling a background message: ${message.messageId}");
  //   // Handle background message and trigger notification
  //   await showBackgroundNotification(
  //     message.data['user'],
  //     message.data['message'],
  //     message.data['notificationType'],
  //     message.sentTime.toString(),
  //   );
  // }

  void handleIncomingLink(BuildContext context, String link) {
    print('Received link: $link');
    final uri = Uri.parse(link);
    print('Parsed URI: $uri');

    if (uri.pathSegments.length == 2 && uri.pathSegments[0] == 'post') {
      final postId = uri.pathSegments[1];
      print('Valid post link. Post ID: $postId');

      // Navigate to SinglePostScreen
      navigatorKey.currentState?.push(
        MaterialPageRoute(
          builder: (context) => SinglePostScreen(postId: postId),
        ),
      );
    } else {
      print('Invalid link format or path. Expected format: /post/postId');
    }
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: MyHomePage(),
    );
  }
}