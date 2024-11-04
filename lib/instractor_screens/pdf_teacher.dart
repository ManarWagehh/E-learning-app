import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:file_picker/file_picker.dart';
import 'package:url_launcher/url_launcher.dart'; // Import url_launcher package
import 'package:graduationproject/screens/pdf_display.dart';

class PdfTeachar extends StatelessWidget {
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
                          IconButton(
                            icon: Icon(Icons.edit, color: Colors.green),
                            onPressed: () {
                              _updatePdf(context, courseId, pdfDoc.id, pdfName);
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              _deletePdf(context, courseId, pdfDoc.id);
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

  // Function to handle PDF update
  void _updatePdf(
      BuildContext context, String courseId, String pdfId, String currentName) {
    TextEditingController nameController =
        TextEditingController(text: currentName);
    FilePickerResult? result;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Color.fromARGB(255, 244, 244, 244),
          title: Text('Update PDF', style: TextStyle(color: Colors.indigo)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'PDF Name'),
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: () async {
                  result = await FilePicker.platform.pickFiles(
                    type: FileType.custom,
                    allowedExtensions: ['pdf'],
                  );
                },
                child: Text(
                  'Select PDF File',
                  style: TextStyle(color: Colors.indigo),
                ),
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
                      .ref('pdfs/${file.name}')
                      .putData(file.bytes!);

                  TaskSnapshot snapshot = await uploadTask;
                  String downloadUrl = await snapshot.ref.getDownloadURL();

                  // Update PDF info in Firestore
                  await FirebaseFirestore.instance
                      .collection('courses')
                      .doc(courseId)
                      .collection('pdf')
                      .doc(pdfId)
                      .update({
                    'namepdf': nameController.text,
                    'pdfurl': downloadUrl,
                  });

                  // Close loading indicator
                  Navigator.of(context).pop();
                } else {
                  // Update only the name if no file was selected
                  await FirebaseFirestore.instance
                      .collection('courses')
                      .doc(courseId)
                      .collection('pdf')
                      .doc(pdfId)
                      .update({
                    'namepdf': nameController.text,
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

  // Function to handle PDF delete
  void _deletePdf(BuildContext context, String courseId, String pdfId) async {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Color.fromARGB(255, 244, 244, 244),
          title: Text('Delete PDF', style: TextStyle(color: Colors.indigo)),
          content: Text('Are you sure you want to delete this PDF?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel', style: TextStyle(color: Colors.indigo)),
            ),
            TextButton(
              onPressed: () async {
                // Delete PDF document from Firestore
                await FirebaseFirestore.instance
                    .collection('courses')
                    .doc(courseId)
                    .collection('pdf')
                    .doc(pdfId)
                    .delete();

                // Optionally, delete corresponding file from Firebase Storage
                // Get the URL of the PDF from Firestore and extract the filename
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
