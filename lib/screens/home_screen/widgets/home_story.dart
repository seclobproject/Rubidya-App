import 'package:flutter/material.dart';
import 'package:rubidya/resources/color.dart';

import 'package:rubidya/services/home_service.dart';
import 'package:story_view/story_view.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dio/dio.dart';
import 'package:video_trimmer/video_trimmer.dart';

import '../../../navigation/bottom_navigation.dart';
import '../../../services/upload_image.dart';

class HomeStory extends StatefulWidget {
  const HomeStory({Key? key}) : super(key: key);

  @override
  State<HomeStory> createState() => _HomeStoryState();
}

class _HomeStoryState extends State<HomeStory> {
  Trimmer? _trimmer;
  List<dynamic> _stories = [];
  bool _isLoading = true;
  bool uploading = false; // Declare and initialize uploading variable
  bool isLoading = false; // Declare and initialize isLoading variable
  String description = '';

  @override
  void initState() {
    super.initState();
    _fetchStories();
  }

  Future<void> _fetchStories() async {
    try {
      final response = await HomeService.getStories();
      if (response['status'] == "01" && response['msg'] == "Success") {
        final List<dynamic> stories = response['story'];
        setState(() {
          _stories = stories.map((story) {
            return {
              ...story,
              'seen': false, // Initialize 'seen' property
            };
          }).toList();
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }
  Future<void> uploadVideo() async {
    if (uploading) return;

    setState(() {
      uploading = true;
      isLoading = true;
    });

    try {
      // Get the video file from the gallery
      final picker = ImagePicker();
      final pickedFile = await picker.getVideo(source: ImageSource.gallery);

      if (pickedFile != null) {
        // Prepare the video file for upload
        FormData formData = FormData.fromMap({
          'media': await MultipartFile.fromFile(
            pickedFile.path,
            filename: 'video.mp4',
          ),
          'description': description,
        });

        // Upload the video using your service
        var response = await UploadService.uploadstory(formData);

        if (response['sts'] == "01") {
          print("Video uploaded successfully");
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Story uploaded successfully"),
              backgroundColor: Colors.green,
            ),
          );

          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => Bottomnav(initialPageIndex: 0)),
                (route) => false,
          );
          print(response['msg']);
        } else {
          print(response['sts']);
          print(response['msg']);
        }
      }
    } on DioError catch (e) {
      print("Exception during video upload: $e");
      String errorMessage = "Connection error. Please try again.";
      if (e.type == DioErrorType.receiveTimeout) {
        errorMessage = "No response received. Please try again.";
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
          backgroundColor: Colors.red,
        ),
      );
    } catch (e) {
      print("Exception during video upload: $e");
    } finally {
      setState(() {
        uploading = false;
        isLoading = false;
      });
    }
  }




  @override
  Widget build(BuildContext context) {
    // Check if uploading is in progress
    if (uploading) {
      return Center(child: CircularProgressIndicator());
    }
    if (_isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    // Group stories by user ID
    Map<String, List<dynamic>> storiesByUser = {};
    _stories.forEach((story) {
      String userId = story['userId'];
      if (!storiesByUser.containsKey(userId)) {
        storiesByUser[userId] = [];
      }
      storiesByUser[userId]!.add(story);
    });

    // If there are no stories, display a user profile icon
    if (storiesByUser.isEmpty) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ClipOval(
            child: Container(
              color: Colors.grey, // Placeholder color
              height: 60,
              width: 60,
              child: Icon(
                Icons.person,
                size: 40,
                color: Colors.white,
              ),
            ),
          ),
          SizedBox(height: 2),
          Text(
            "  No stories ",
            style: TextStyle(fontSize: 10),
          ),
        ],
      );
    }

    return ListView(
      scrollDirection: Axis.horizontal,
      children: [
        // Add Your Story option
        GestureDetector(
          onTap: uploadVideo,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.grey,
                      width: 1,
                    ),
                  ),
                  height: 60,
                  width: 60,
                  child: Icon(
                    Icons.add,
                    size: 40,
                    color: Colors.grey,
                  ),
                ),
                SizedBox(height: 8),
                Text("Your Story", style: TextStyle(fontSize: 12)),
              ],
            ),
          ),
        ),

        // Other user stories
        ...storiesByUser.entries.map<Widget>((entry) {
          List<dynamic> userStories = entry.value;
          String username = userStories.first['username'];
          String profilePicUrl = userStories.first['profilePic']['filePath'];

          return GestureDetector(
            onTap: () => _playUserStories(context, userStories),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
              child: Column(
                children: [
                  Stack(
                    children: [
                      ClipOval(
                        child: Image.network(
                          profilePicUrl,
                          height: 60,
                          width: 60,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          height: 15,
                          width: 15,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.white,
                              width: 1,
                            ),
                            color: userStories.first['seen']
                                ? blueshade
                                : bluetext,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Text(username, style: TextStyle(fontSize: 12)),
                ],
              ),
            ),
          );
        }).toList(),
      ],
    );
  }

  void _playUserStories(BuildContext context, List<dynamic> userStories) {
    if (userStories.isEmpty) {
      // If no stories available, show a dummy picture
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => NoStoryScreen(),
        ),
      );
    } else {
      // Set the 'seen' property of each story to true
      userStories.forEach((story) {
        story['seen'] = true;
      });

      // If stories available, navigate to UserStoriesScreen
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => UserStoriesScreen(userStories: userStories),
        ),
      );
    }
  }
}

class NoStoryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text("No Stories"),
        actions: [
          IconButton(
            icon: Icon(Icons.close, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.image,
              size: 100,
              color: Colors.grey,
            ),
            SizedBox(height: 20),
            Text(
              "No stories",
              style: TextStyle(fontSize: 20),
            ),
          ],
        ),
      ),
    );
  }
}

class UserStoriesScreen extends StatelessWidget {
  final List<dynamic> userStories;

  const UserStoriesScreen({Key? key, required this.userStories})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.black,
        title: Row(
          children: [
            ClipOval(
              child: Image.network(
                userStories.first['profilePic']['filePath'],
                height: 40,
                width: 40,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(width: 8),
            Text(
              userStories.first['username'],
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.close, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
      body: StoryView(
        storyItems: userStories.map<StoryItem>((story) {
          String videoUrl = story['filePath'];
          String username = story['username'];
          return StoryItem.pageVideo(
            videoUrl,
            caption: Text(username),
            controller: StoryController(), // Add this line
            duration: Duration(
                seconds: 10), // Set the duration as per your requirement
            imageFit: BoxFit.cover,
          );
        }).toList(),
        repeat: false,
        controller: StoryController(),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: Scaffold(
      body: HomeStory(),
    ),
  ));
}