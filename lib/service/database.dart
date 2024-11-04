import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:get/get.dart';

class databaseMethods {
  Future AddStudentDetails(
      Map<String, dynamic> studentinfomap, String id) async {
    return await FirebaseFirestore.instance
        .collection("students")
        .doc(id)
        .set(studentinfomap);
  }

  Future<Stream<QuerySnapshot>> GetStudentDetails() async {
    return await FirebaseFirestore.instance.collection("students").snapshots();
  }

  Future UpdateStudentDetails(
      String id, Map<String, dynamic> Updatetinfomap) async {
    return await FirebaseFirestore.instance
        .collection("students")
        .doc(id)
        .update(Updatetinfomap);
  }

  Future DeleteStudentDetails(String id) async {
    return await FirebaseFirestore.instance
        .collection("students")
        .doc(id)
        .delete();
  }

  Future AddTeacheDetails(
      Map<String, dynamic> teacherinfomap, String id) async {
    return await FirebaseFirestore.instance
        .collection("teachers")
        .doc(id)
        .set(teacherinfomap);
  }

  Future<Stream<QuerySnapshot>> GetTeacherDetails() async {
    return await FirebaseFirestore.instance.collection("teachers").snapshots();
  }

  Future UpdateTeacherDetails(
      String id, Map<String, dynamic> Updatetinfomap) async {
    return await FirebaseFirestore.instance
        .collection("teachers")
        .doc(id)
        .update(Updatetinfomap);
  }

  Future DeleteTeacherDetails(String id) async {
    return await FirebaseFirestore.instance
        .collection("teachers")
        .doc(id)
        .delete();
  }

  pickImage(ImageSource source) async {
    final ImagePicker _imagepicker = ImagePicker();
    XFile? _file = await _imagepicker.pickImage(source: source);
    if (_file != null) {
      return await _file.readAsBytes();
    }
    {
      print('no image is selected');
    }
  }

  Future UpdatecoursesDetails(
      String id, Map<String, dynamic> Updatetinffomap) async {
    return await FirebaseFirestore.instance
        .collection("courses")
        .doc(id)
        .update(Updatetinffomap);
  }

  Future<Stream<QuerySnapshot>> GetCoursesDetails() async {
    return await FirebaseFirestore.instance.collection("courses").snapshots();
  }

  Future DeleteCoursesDetails(String id) async {
    return await FirebaseFirestore.instance
        .collection("courses")
        .doc(id)
        .delete();
  }

  Future AddCoursesDetails(
    Map<String, dynamic> studentinfomap,
  ) async {
    return await FirebaseFirestore.instance
        .collection("courses")
        .doc()
        .set(studentinfomap);
  }

  Future<Stream<QuerySnapshot>> GetChaptersDetails(String id) async {
    return await FirebaseFirestore.instance
        .collection("courses")
        .doc(id)
        .collection("lession")
        .snapshots();
  }

  Future AddChapterDetails(
      Map<String, dynamic> chapterinfomap, String id) async {
    return await FirebaseFirestore.instance
        .collection("courses")
        .doc(id)
        .collection("lession")
        .doc()
        .set(chapterinfomap);
  }
}
