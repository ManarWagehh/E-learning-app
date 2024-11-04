import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:graduationproject/instractor_screens/home_teacher.dart';
import 'package:graduationproject/service/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:random_string/random_string.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:file_picker/file_picker.dart';

import 'package:get/get.dart';

class AddCourse extends StatefulWidget {
  const AddCourse({super.key});

  @override
  State<AddCourse> createState() => _AddCourseState();
}

class _AddCourseState extends State<AddCourse> {
  List<File> _videoFiles = [];
  List<File> _pdfFiles = [];
  TextEditingController name = new TextEditingController();

  final CollectionReference items =
      FirebaseFirestore.instance.collection("users");
  String imageUrl = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigo,
        title: Center(
          child: Row(
            children: [
              IconButton(
                color: Colors.white,
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => HomeTeacher()),
                  );
                },
                icon: const BackButtonIcon(),
              ),
              Text("Add Course",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  )),
            ],
          ),
        ),
      ),
      body: Container(
        margin: EdgeInsets.only(left: 20, top: 30, right: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Name",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                )),
            SizedBox(
              height: 10,
            ),
            Container(
              padding: EdgeInsets.only(left: 10),
              decoration: BoxDecoration(
                  border: Border.all(),
                  borderRadius: BorderRadius.circular(10)),
              child: TextField(
                controller: name,
                decoration: InputDecoration(border: InputBorder.none),
              ),
            ),
            SizedBox(
              height: 40,
            ),
            Center(
                child: IconButton(
                    onPressed: () async {
                      ImagePicker imagePicker = ImagePicker();
                      XFile? file = await imagePicker.pickImage(
                          source: ImageSource.gallery);

                      if (file == null) return;

                      String uniqueFileName = randomAlphaNumeric(10);

                      Reference referenceRoot = FirebaseStorage.instanceFor(
                              bucket:
                                  "gs://graduation-project-fdc47.appspot.com")
                          .ref();
                      Reference referenceDirImages =
                          referenceRoot.child('images');
                      Reference referenceImageToUpload =
                          referenceDirImages.child(uniqueFileName);

                      try {
                        await referenceImageToUpload.putFile(File(file.path));

                        imageUrl =
                            await referenceImageToUpload.getDownloadURL();
                        setState(
                            () {}); // Update the UI to display the selected image
                      } catch (error) {
                        // Handle error if image upload fails
                        print('Error uploading image: $error');
                      }
                    },
                    icon: const Icon(Icons.camera_alt))),
            SizedBox(
              height: 50,
            ),
            Text("Upload videos",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                )),
            IconButton(
                onPressed: () async {
                  FilePickerResult? result =
                      await FilePicker.platform.pickFiles(
                    allowMultiple: true,
                    type: FileType.video,
                  );
                  if (result != null) {
                    List<File> pickedFiles =
                        result.paths.map((path) => File(path!)).toList();
                    setState(() {
                      _videoFiles = pickedFiles;
                    });
                  }
                },
                icon: Icon(Icons.upload)),
            SizedBox(height: 20),
            Text("Upload Pdfs",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                )),
            IconButton(
                onPressed: () async {
                  FilePickerResult? result =
                      await FilePicker.platform.pickFiles(
                    allowMultiple: true,
                    type: FileType.custom,
                    allowedExtensions: ['pdf'],
                  );
                  if (result != null) {
                    List<File> pickedFiles =
                        result.paths.map((path) => File(path!)).toList();
                    setState(() {
                      _pdfFiles = pickedFiles;
                    });
                  }
                },
                icon: Icon(Icons.upload)),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigo,
                ),
                onPressed: () async {
                  String CourseId = randomAlphaNumeric(10);

                  if (name.text.isNotEmpty && imageUrl.isNotEmpty) {
                    // Store the course details in Firestore
                    try {
                      await FirebaseFirestore.instance
                          .collection('courses')
                          .doc(name.text)
                          .set({
                        'name': name.text,
                        'imageUrl': imageUrl,
                      });
                      _uploadPDFs(name.text);
                      _uploadVideos(name.text);

                      // Show success message or navigate to another screen
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Course added successfully')),
                      );
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => HomeTeacher()),
                      );
                    } catch (error) {
                      // Handle error if adding the course fails
                      print('Error adding course: $error');
                    }
                  } else {
                    // Show an error message if the name or image is missing
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content: Text(
                              'Please enter the course name and select an image')),
                    );
                  }
                },
                child: Text(
                  "Add",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<void> _uploadVideos(final id) async {
    if (_videoFiles.isNotEmpty) {
      try {
        // Loop through each selected video file and upload to Firebase Storage
        for (int i = 0; i < _videoFiles.length; i++) {
          File videoFile = _videoFiles[i];
          String uniqueFileName = 'Chapter video ${i + 1}';

          Reference referenceRoot = FirebaseStorage.instanceFor(
                  bucket: "gs://graduation-project-fdc47.appspot.com")
              .ref();
          Reference referenceDirVideos = referenceRoot.child('videos');
          Reference referenceVideoToUpload =
              referenceDirVideos.child(uniqueFileName);

          // Upload video file
          await referenceVideoToUpload.putFile(videoFile);

          // Get download URL
          String videoUrl = await referenceVideoToUpload.getDownloadURL();
          print("Uploaded video URL: $videoUrl");

          // Store video information in Firestore
          await FirebaseFirestore.instance
              .collection("courses")
              .doc(id)
              .collection('videos')
              .add({"videourl": videoUrl, "namevideo": uniqueFileName});
        }

        // Show success message or perform any other action after all videos are uploaded
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Videos uploaded successfully')),
        );
      } catch (error) {
        print('Error uploading videos: $error');
        // Handle error
      }
    } else {
      // No videos selected
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No videos selected')),
      );
    }
  }

  Future<void> _uploadPDFs(final id) async {
    if (_pdfFiles.isNotEmpty) {
      try {
        // Loop through each selected PDF file and upload to Firebase Storage
        for (int i = 0; i < _pdfFiles.length; i++) {
          File pdfFile = _pdfFiles[i];
          String uniqueFileName = 'Chapter pdf ${i + 1}';

          Reference referenceRoot = FirebaseStorage.instanceFor(
                  bucket: "gs://graduation-project-fdc47.appspot.com")
              .ref();
          Reference referenceDirPDFs = referenceRoot.child('pdfs');
          Reference referencePDFToUpload =
              referenceDirPDFs.child(uniqueFileName);

          // Upload PDF file
          await referencePDFToUpload.putFile(pdfFile);

          // Get download URL
          String pdfUrl = await referencePDFToUpload.getDownloadURL();
          print("Uploaded PDF URL: $pdfUrl");

          // Store PDF information in Firestore
          await FirebaseFirestore.instance
              .collection("courses")
              .doc(id)
              .collection('pdf')
              .add({"pdfurl": pdfUrl, "namepdf": uniqueFileName});
        }

        // Show success message or perform any other action after all PDFs are uploaded
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('PDFs uploaded successfully')),
        );
      } catch (error) {
        print('Error uploading PDFs: $error');
        // Handle error
      }
    } else {
      // No PDFs selected
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No PDFs selected')),
      );
    }
  }
}
