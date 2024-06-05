// import 'package:flutter/material.dart';
// import 'package:upgrader/upgrader.dart';
// import 'authentication_page/splash.dart';
// import 'package:flutter/material.dart';
// import 'package:in_app_update/in_app_update.dart';
//
// void main() {
//   runApp(MyApp());
// }
//
// class MyApp extends StatefulWidget {
//   const MyApp({Key? key}) : super(key: key);
//
//   @override
//   _MyAppState createState() => _MyAppState();
// }
//
// class _MyAppState extends State<MyApp> {
//
//
//   @override
//   void initState() {
//     super.initState();
//     checkForUpdate();
//   }
//
//   Future<void> checkForUpdate() async {
//     print('checking for Update');
//     InAppUpdate.checkForUpdate().then((info) {
//       setState(() {
//         if (info.updateAvailability == UpdateAvailability.updateAvailable) {
//           print('update available');
//           update();
//         }
//       });
//     }).catchError((e) {
//       print(e.toString());
//     });
//   }
//
//   void update() async {
//     print('Updating');
//     await InAppUpdate.startFlexibleUpdate();
//     InAppUpdate.completeFlexibleUpdate().then((_) {}).catchError((e) {
//       print(e.toString());
//     });
//   }
//
//
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'Flutter Demo',
//       theme: ThemeData(
//         colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
//         useMaterial3: true,
//       ),
//       home: MyHomePage(),
//     );
//   }
// }
//
//


import 'package:flutter/material.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:rubidya/screens/home_screen/widgets/single_post.dart';
import 'package:uni_links/uni_links.dart';
import 'dart:async';
import 'authentication_page/splash.dart';

void main() {
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
      key: navigatorKey,
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