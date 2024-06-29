import 'dart:io';
import 'package:video_player/video_player.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dio/dio.dart';
import 'package:story_view/story_view.dart';
import '../../../navigation/bottom_navigation.dart';
import '../../../resources/color.dart';
import '../../../services/home_service.dart';
import '../../../services/upload_image.dart';

class HomeStory extends StatefulWidget {
  const HomeStory({Key? key}) : super(key: key);

  @override
  State<HomeStory> createState() => _HomeStoryState();
}

class _HomeStoryState extends State<HomeStory> {
  List<dynamic> _stories = [];
  bool _isLoading = true;
  bool uploading = false;
  bool isLoading = false;
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
              'seen': false,
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
      final picker = ImagePicker();
      final pickedFile = await picker.getVideo(source: ImageSource.gallery);
      if (pickedFile != null) {
        // Get the duration of the video
        final videoPlayerController =
        VideoPlayerController.file(File(pickedFile.path));
        await videoPlayerController.initialize();
        final videoDuration = videoPlayerController.value.duration.inSeconds;

        FormData formData = FormData.fromMap({
          'media': await MultipartFile.fromFile(
            pickedFile.path,
            filename: 'video.mp4',
          ),
          'description': description,
          'duration': videoDuration, // Pass the duration to the backend
        });

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
            MaterialPageRoute(
                builder: (context) => Bottomnav(initialPageIndex: 0)),
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
    if (uploading || _isLoading) {
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

    List<Map<String, List<dynamic>>> allStories =
    storiesByUser.entries.map((entry) {
      return {entry.key: entry.value};
    }).toList();

    return ListView(
      scrollDirection: Axis.horizontal,
      children: [
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
        if (allStories.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
            child: Column(
              children: [
                ClipOval(
                  child: Container(
                    color: Colors.grey,
                    height: 60,
                    width: 60,
                    child: Icon(
                      Icons.person,
                      size: 40,
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(height: 8),
                Text("No stories", style: TextStyle(fontSize: 12)),
              ],
            ),
          )
        else
          ...allStories.asMap().entries.map<Widget>((entry) {
            int index = entry.key;
            List<dynamic> userStories = entry.value?.values?.first ?? [];
            if (userStories.isEmpty) return Container(); // Return an empty container if userStories is empty

            String username = userStories.first['username'] ?? '';
            String profilePicUrl = userStories.first['profilePic']?['filePath'] ?? '';

            return GestureDetector(
              onTap: () => _playUserStories(context, allStories, index),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                child: Column(
                  children: [
                    Stack(
                      children: [
                        ClipOval(
                          child: profilePicUrl.isNotEmpty
                              ? Image.network(
                            profilePicUrl,
                            height: 60,
                            width: 60,
                            fit: BoxFit.cover,
                          )
                              : Container(
                            height: 60,
                            width: 60,
                            color: Colors.grey, // Placeholder color if no image
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
                              color: userStories.first['seen'] ? blueshade : bluetext,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    SizedBox(
                      width: 80,
                      child: Center(
                        child: Text(
                          username,
                          style: TextStyle(fontSize: 12),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),

      ],
    );
  }

  void _playUserStories(BuildContext context,
      List<Map<String, List<dynamic>>> allStories, int initialIndex) {
    List<dynamic> userStories = allStories[initialIndex].values.first;

    if (userStories.isEmpty) {
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
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => UserStoriesScreen(
              userStories: userStories,
              allStories: allStories,
              initialIndex: initialIndex),
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

class UserStoriesScreen extends StatefulWidget {
  final List<dynamic> userStories;
  final List<Map<String, List<dynamic>>> allStories;
  final int initialIndex;
  final StoryController storyController = StoryController();

  UserStoriesScreen({
    Key? key,
    required this.userStories,
    required this.allStories,
    required this.initialIndex,
  }) : super(key: key);

  @override
  _UserStoriesScreenState createState() => _UserStoriesScreenState();
}

class _UserStoriesScreenState extends State<UserStoriesScreen> {
  late int currentIndex;
  late int currentStoryIndex;
  late List<StoryItem> currentStoryItems;

  @override
  void initState() {
    super.initState();
    currentIndex = widget.initialIndex;
    currentStoryIndex = 0;
    _updateCurrentStoryItems();
  }

  void _updateCurrentStoryItems() {
    List<dynamic> currentUserStories =
        widget.allStories[currentIndex].values.first;
    currentStoryItems = currentUserStories.map<StoryItem>((story) {
      String videoUrl = story['filePath'];
      int duration = story['duration'] ??
          10; // Default to 10 seconds if duration is not provided
      return StoryItem.pageVideo(
        videoUrl,
        controller: widget.storyController,
        duration: Duration(seconds: duration),
        imageFit: BoxFit.cover,
      );
    }).toList();
    widget.storyController
        .play(); // Start playing the stories from the beginning
  }

  void _onComplete() {
    setState(() {
      if (currentIndex < widget.allStories.length - 1) {
        currentIndex++;
        currentStoryIndex = 0;
        _updateCurrentStoryItems();
      } else {
        Navigator.pop(
            context); // Go back to the previous screen if all stories are completed
      }
    });
  }

  void _goToNextStory() {
    setState(() {
      if (currentStoryIndex < currentStoryItems.length - 1) {
        currentStoryIndex++;
      } else {
        _onComplete();
        return; // Return early to avoid the next steps
      }
      // Ensure the next story item is updated correctly
      _updateCurrentStoryItems();
    });
  }

  void _goToPreviousStory() {
    setState(() {
      if (currentStoryIndex > 0) {
        currentStoryIndex--;
      } else if (currentIndex > 0) {
        currentIndex--;
        currentStoryIndex =
            widget.allStories[currentIndex].values.first.length - 1;
        _updateCurrentStoryItems();
      }
      widget.storyController
          .play(); // Ensure the previous story starts playing automatically
    });
  }

  @override
  Widget build(BuildContext context) {
    List<dynamic> currentUserStories = widget.allStories[currentIndex]?.values?.first ?? [];
    if (currentUserStories.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: Text(
            'No Stories',
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.close, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
        body: Center(
          child: Text('No stories available', style: TextStyle(color: Colors.white)),
        ),
      );
    }

    String currentUserName = currentUserStories.first['username'] ?? 'Unknown User';
    String currentUserProfilePic = currentUserStories.first['profilePic']?['filePath'] ?? '';

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.black,
        title: Row(
          children: [
            ClipOval(
              child: Image.network(
                currentUserProfilePic,
                height: 40,
                width: 40,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(width: 8),
            SizedBox(
              width: 200,
              child: Text(
                currentUserName,
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
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
      body: GestureDetector(
        onTapUp: (details) {
          final screenWidth = MediaQuery.of(context).size.width;
          if (details.globalPosition.dx < screenWidth / 2) {
            _goToPreviousStory();
          } else {
            _goToNextStory();
          }
        },
        onHorizontalDragEnd: (details) {
          if (details.primaryVelocity! < 0) {
            _goToNextStory(); // Swipe left
          } else if (details.primaryVelocity! > 0) {
            _goToPreviousStory(); // Swipe right
          }
        },
        child: StoryView(
          storyItems: currentStoryItems,
          repeat: true,
          controller: widget.storyController,
          onComplete: _goToNextStory,
          onVerticalSwipeComplete: (direction) {
            if (direction == Direction.down) {
              Navigator.pop(context);
            }
          },
        ),
      ),
    );
  }
}