import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:file_picker/file_picker.dart';

class VideoTeacher extends StatelessWidget {
  final void Function(String)? onVideoSelected;

  VideoTeacher({this.onVideoSelected});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('courses').snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        // Iterate through the courses
        return ListView.builder(
          itemCount: snapshot.data!.docs.length,
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemBuilder: (context, courseIndex) {
            var courseDoc = snapshot.data!.docs[courseIndex];
            var courseId = courseDoc.id;

            // Now, fetch videos for each course from its subcollection
            return StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('courses')
                  .doc(courseId)
                  .collection('videos')
                  .snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> videoSnapshot) {
                if (!videoSnapshot.hasData) {
                  return SizedBox(); // Return an empty widget while loading
                }

                // Iterate through the videos for this course
                return ListView.builder(
                  itemCount: videoSnapshot.data!.docs.length,
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (context, videoIndex) {
                    var videoDoc = videoSnapshot.data!.docs[videoIndex];
                    var videoName = videoDoc['namevideo'];
                    var videoUrl = videoDoc['videourl'];

                    // Build each video ListTile
                    return ListTile(
                      onTap: () {
                        // Call the callback function with the selected video URL
                        if (onVideoSelected != null) {
                          onVideoSelected!(videoUrl);
                        }
                      },
                      leading: Container(
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: videoIndex == 0
                              ? Colors.indigo
                              : Colors.indigo.withOpacity(0.6),
                        ),
                        child: Icon(
                          Icons.play_arrow_rounded,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),
                      title: Row(
                        children: [
                          Expanded(
                            child: Text(videoName),
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.edit,
                              color: Colors.green,
                            ),
                            onPressed: () {
                              _updateVideo(
                                  context, courseId, videoDoc.id, videoName);
                            },
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.delete,
                              color: Colors.red,
                            ),
                            onPressed: () {
                              _deleteVideo(context, courseId, videoDoc.id);
                            },
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            );
          },
        );
      },
    );
  }

  // Function to handle video update
  void _updateVideo(BuildContext context, String courseId, String videoId,
      String currentName) {
    TextEditingController nameController =
        TextEditingController(text: currentName);
    FilePickerResult? result;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Color.fromARGB(255, 244, 244, 244),
          title: Text('Update Video', style: TextStyle(color: Colors.indigo)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'Video Name'),
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: () async {
                  result = await FilePicker.platform.pickFiles(
                    type: FileType.custom,
                    allowedExtensions: ['mp4', 'mov', 'avi', 'wmv', 'flv'],
                  );
                },
                child: Text('Select Video File',
                    style: TextStyle(color: Colors.indigo)),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel', style: TextStyle(color: Colors.indigo)),
            ),
            TextButton(
              onPressed: () async {
                if (result != null && result!.files.isNotEmpty) {
                  PlatformFile file = result!.files.first;

                  // Show loading indicator while uploading
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (context) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    },
                  );

                  // Upload new file to Firebase Storage
                  UploadTask uploadTask = FirebaseStorage.instance
                      .ref('videos/${file.name}')
                      .putData(file.bytes!);

                  TaskSnapshot snapshot = await uploadTask;
                  String downloadUrl = await snapshot.ref.getDownloadURL();

                  // Update video info in Firestore
                  await FirebaseFirestore.instance
                      .collection('courses')
                      .doc(courseId)
                      .collection('videos')
                      .doc(videoId)
                      .update({
                    'namevideo': nameController.text,
                    'videourl': downloadUrl,
                  });

                  // Close loading indicator
                  Navigator.of(context).pop();
                } else {
                  // Update only the name if no file was selected
                  await FirebaseFirestore.instance
                      .collection('courses')
                      .doc(courseId)
                      .collection('videos')
                      .doc(videoId)
                      .update({
                    'namevideo': nameController.text,
                  });
                }

                Navigator.of(context).pop();
              },
              child: Text('Update', style: TextStyle(color: Colors.indigo)),
            ),
          ],
        );
      },
    );
  }

  // Function to handle video delete
  void _deleteVideo(
      BuildContext context, String courseId, String videoId) async {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Color.fromARGB(255, 244, 244, 244),
          title: Text('Delete Video', style: TextStyle(color: Colors.indigo)),
          content: Text('Are you sure you want to delete this video?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel', style: TextStyle(color: Colors.indigo)),
            ),
            TextButton(
              onPressed: () async {
                // Delete video document from Firestore
                await FirebaseFirestore.instance
                    .collection('courses')
                    .doc(courseId)
                    .collection('videos')
                    .doc(videoId)
                    .delete();

                // Optionally, delete corresponding file from Firebase Storage
                // Get the URL of the video from Firestore and extract the filename
                // Delete the file from Firebase Storage using FirebaseStorage.instance.ref().child(filename).delete();

                Navigator.of(context).pop();
              },
              child: Text(
                'Delete',
                style: TextStyle(color: Colors.indigo),
              ),
            ),
          ],
        );
      },
    );
  }
}
