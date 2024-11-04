import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:graduationproject/admin_screens/hometeacher.dart';
import 'package:graduationproject/instractor_screens/pdf_teacher.dart';
import 'package:graduationproject/instractor_screens/profile_teacher.dart';
import 'package:graduationproject/instractor_screens/video_teacher.dart';
import 'package:graduationproject/screens/home_screen.dart';
import 'package:graduationproject/screens/pdf_section.dart';
import 'package:graduationproject/screens/profile_student.dart';
import 'package:graduationproject/screens/video_section.dart';
import 'package:video_player/video_player.dart';

class CourseTeacher extends StatefulWidget {
  String img;
  String name;

  CourseTeacher(
    this.name,
    this.img,
  );

  @override
  State<CourseTeacher> createState() => _CourseScreenState();
}

class _CourseScreenState extends State<CourseTeacher> {
  late VideoPlayerController _controller;
  bool isVideoSection = true;
  String? selectedVideoUrl; // Variable to store the selected video URL

  @override
  void initState() {
    super.initState();
    // Initialize the VideoPlayerController with the default video URL
    _controller = VideoPlayerController.network('${widget.name}')
      ..initialize().then((_) {
        setState(() {});
      });
  }

  // Method to update the video URL when a video is selected
  void updateVideoUrl(String videoUrl) {
    setState(() {
      selectedVideoUrl = videoUrl;
      // Update the VideoPlayerController with the selected video URL
      _controller = VideoPlayerController.network(selectedVideoUrl!)
        ..initialize().then((_) {
          setState(() {});
        });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          Padding(
            padding: EdgeInsets.only(
              right: 10,
            ),
            child: Icon(Icons.notifications, size: 28, color: Colors.indigo),
          )
        ],
        foregroundColor: Colors.indigo,
        elevation: 0,
        centerTitle: true,
        title: Text(
          widget.name,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        child: ListView(
          children: [
            Center(
              child: _controller.value.isInitialized
                  ? AspectRatio(
                      aspectRatio: _controller.value.aspectRatio,
                      child: VideoPlayer(_controller),
                    )
                  : Container(),
            ),
            IconButton(
              onPressed: () {
                setState(() {
                  _controller.value.isPlaying
                      ? _controller.pause()
                      : _controller.play();
                });
              },
              icon: Icon(
                _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Text(
              "${widget.name} Complete Course",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
            ),
            SizedBox(
              height: 5,
            ),
            Text(
              "Create By Girls Programmer",
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.black.withOpacity(0.7)),
            ),
            SizedBox(
              height: 5,
            ),
            Text(
              "55 Videos",
              style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: Colors.black.withOpacity(0.5)),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
              decoration: BoxDecoration(
                  color: Color(0XFFF5F3FF),
                  borderRadius: BorderRadius.circular(10)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Material(
                    color: isVideoSection
                        ? Colors.indigo
                        : Colors.indigo.withOpacity(0.6),
                    borderRadius: BorderRadius.circular(10),
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          isVideoSection = true;
                        });
                      },
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                        child: Text(
                          "Videos",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                    ),
                  ),
                  Material(
                    color: isVideoSection
                        ? Colors.indigo.withOpacity(0.6)
                        : Colors.indigo,
                    borderRadius: BorderRadius.circular(10),
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          isVideoSection = false;
                        });
                      },
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                        child: Text(
                          "PDFS",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            isVideoSection
                ? VideoTeacher(
                    // Pass the callback method to the VideoSection widget
                    onVideoSelected: updateVideoUrl,
                  )
                : PdfTeachar(),
          ],
        ),
      ),
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Colors.white,
        color: Colors.indigo,
        items: [
          IconButton(
            icon: Icon(Icons.home, color: Colors.white),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Hometeacher()),
            ),
          ),
          IconButton(
            icon: Icon(Icons.person, color: Colors.white),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ProfileTeacher()),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
