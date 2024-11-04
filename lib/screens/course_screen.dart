import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:graduationproject/screens/home_screen.dart';
import 'package:graduationproject/screens/pdf_section.dart';
import 'package:graduationproject/screens/profile_student.dart';
import 'package:graduationproject/screens/video_section.dart';
import 'package:video_player/video_player.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_animate/flutter_animate.dart';

class CourseScreen extends StatefulWidget {
  final String img;
  final String name;

  CourseScreen(this.name, this.img);

  @override
  State<CourseScreen> createState() => _CourseScreenState();
}

class _CourseScreenState extends State<CourseScreen> {
  final id = FirebaseAuth.instance.currentUser!.uid;
  List<File> _pdfFiles = [];
  late VideoPlayerController _controller;
  bool isVideoSection = true;
  String? selectedVideoUrl; // Variable to store the selected video URL

  @override
  void initState() {
    super.initState();
    // Initialize the VideoPlayerController with the default video URL
    _controller = VideoPlayerController.network(widget.img)
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

  void showMultipleDialogs(
      List<String> messages, List<String> images, int index) {
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, StateSetter setState) {
            return AlertDialog(
              backgroundColor: Colors.white,
              title: Text("Important Notice",
                  style: TextStyle(color: Colors.indigo)),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Animate(
                    onPlay: (controller) => controller.repeat(),
                    child: Image.asset(
                      images[index],
                      height: 300,
                      width: 300, // Adjust width proportionally if needed
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(messages[index]),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: index > 0
                            ? () {
                                setState(() {
                                  index--;
                                });
                              }
                            : null,
                        child: Text("Back",
                            style: TextStyle(color: Colors.indigo)),
                      ),
                    ],
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    if (index == messages.length - 1) {
                      _controller.play();
                    } else {
                      showMultipleDialogs(messages, images, index + 1);
                    }
                  },
                  child: Text(
                    index == messages.length - 1 ? "Close" : "Next",
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void showPlayMessages() {
    List<String> messages = [
      "Open the app.",
      "Wear headset.",
      "Export data.",
      "Please upload a CSV file using the button below the video.",
    ];
    List<String> images = [
      "assets/images/open.gif",
      "assets/images/image_2024-06-18_16-32-03.png",
      "assets/images/export.gif",
      "assets/images/image_2024-06-18_16-43-25.png"
    ];
    showMultipleDialogs(messages, images, 0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Navigate back to previous screen
          },
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 10),
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
                if (_controller.value.isPlaying) {
                  _controller.pause();
                } else {
                  showPlayMessages();
                }
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
              "Created By Girls Programmer",
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.black.withOpacity(0.7)),
            ),
            SizedBox(
              height: 5,
            ),
            ElevatedButton(
              onPressed: () {
                _uploadcsvfile(id);
              },
              child: Text(
                "Upload CSV file",
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: Colors.black.withOpacity(0.5)),
              ),
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
                          "PDFs",
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
                ? VideoSection(
                    // Pass the callback method to the VideoSection widget
                    onVideoSelected: updateVideoUrl,
                  )
                : PdfSection(),
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
              MaterialPageRoute(builder: (context) => HomePage()),
            ),
          ),
          IconButton(
            icon: Icon(Icons.person, color: Colors.white),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ProfileStudent()),
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

  Future<void> _uploadcsvfile(final idd) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.custom,
      allowedExtensions: ['csv'],
    );
    if (result != null) {
      List<File> pickedFiles = result.paths.map((path) => File(path!)).toList();
      setState(() {
        _pdfFiles = pickedFiles;
      });

      if (_pdfFiles.isNotEmpty) {
        try {
          // Loop through each selected PDF file and upload to Firebase Storage
          for (int i = 0; i < _pdfFiles.length; i++) {
            File pdfFile = _pdfFiles[i];
            String uniqueFileName = 'csv_${i + 1}.csv';

            Reference referenceRoot = FirebaseStorage.instanceFor(
                    bucket: "gs://graduation-project-fdc47.appspot.com")
                .ref();
            Reference referenceDirPDFs = referenceRoot.child('csvFiles');
            Reference referencePDFToUpload =
                referenceDirPDFs.child(uniqueFileName);

            // Upload PDF file
            await referencePDFToUpload.putFile(pdfFile);

            // Get download URL
            String pdfUrl = await referencePDFToUpload.getDownloadURL();
            print("Uploaded PDF URL: $pdfUrl");

            // Store PDF information in Firestore
            await FirebaseFirestore.instance
                .collection("students")
                .doc(idd)
                .collection('csvFiles')
                .add({"pdfurl": pdfUrl, "namepdf": uniqueFileName});
          }

          // Show success message or perform any other action after all PDFs are uploaded
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('CSV files uploaded successfully')),
          );
        } catch (error) {
          print('Error uploading CSV files: $error');
          // Handle error
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error uploading CSV files: $error')),
          );
        }
      } else {
        // No PDFs selected
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('No CSV files selected')),
        );
      }
    } else {
      // User canceled the picker
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('File picking canceled')),
      );
    }
  }
}
