import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart'; // Import url_launcher package
import 'package:graduationproject/screens/pdf_display.dart';

class PdfSection extends StatelessWidget {
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

            // Now, fetch PDFs for each course from its subcollection
            return StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('courses')
                  .doc(courseId)
                  .collection('pdf')
                  .snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> pdfSnapshot) {
                if (!pdfSnapshot.hasData) {
                  return SizedBox(); // Return an empty widget while loading
                }

                // Iterate through the PDFs for this course
                return ListView.builder(
                  itemCount: pdfSnapshot.data!.docs.length,
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (context, pdfIndex) {
                    var pdfDoc = pdfSnapshot.data!.docs[pdfIndex];
                    var pdfName = pdfDoc['namepdf'];
                    var pdfUrl = pdfDoc['pdfurl'];

                    // Build each PDF ListTile
                    return ListTile(
                      onTap: () async {
                        // Open the PDF URL in the default browser or another installed PDF viewer app
                        if (await canLaunch(pdfUrl)) {
                          await launch(pdfUrl);
                        } else {
                          throw 'Could not launch $pdfUrl';
                        }
                      },
                      leading: Container(
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: pdfIndex == 0
                              ? Colors.indigo
                              : Colors.indigo.withOpacity(0.6),
                        ),
                        child: Icon(
                          Icons.picture_as_pdf,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),
                      title: Row(
                        children: [
                          Expanded(
                            child: Text(pdfName),
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
