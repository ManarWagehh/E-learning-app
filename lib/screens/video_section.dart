import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:graduationproject/screens/course_screen.dart';

class VideoSection extends StatelessWidget {
  final void Function(String)? onVideoSelected;

  VideoSection({this.onVideoSelected});

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
}
