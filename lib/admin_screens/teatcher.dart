import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:graduationproject/service/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:random_string/random_string.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';

class AddTeacher extends StatefulWidget {
  const AddTeacher({super.key});

  @override
  State<AddTeacher> createState() => _AddTeacherState();
}

class _AddTeacherState extends State<AddTeacher> {
  TextEditingController name = new TextEditingController();
  TextEditingController email = new TextEditingController();
  TextEditingController password = new TextEditingController();

  final CollectionReference items =
      FirebaseFirestore.instance.collection("teachers");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigo,
        title: Center(
          child: Row(
            children: [
              Text("Add Teacher",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ))
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
            Text("Email",
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
                controller: email,
                decoration: InputDecoration(border: InputBorder.none),
              ),
            ),
            SizedBox(
              height: 40,
            ),
            Text("Password",
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
                controller: password,
                decoration: InputDecoration(border: InputBorder.none),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            SizedBox(
              height: 50,
            ),
            Center(
              child: ElevatedButton(
                  onPressed: () async {
                    var results = await FirebaseAuth.instance
                        .createUserWithEmailAndPassword(
                            email: email.text, password: password.text);

                    if (results != null) {
                      String id = FirebaseAuth.instance.currentUser!.uid;
                      Map<String, dynamic> teacherinfomap = {
                        "name": name.text,
                        "id": id,
                        "email": email.text,
                        "password": password.text,
                      };

                      name.text = '';
                      email.text = '';
                      password.text = '';
                      Navigator.of(context).pop();
                      await databaseMethods()
                          .AddTeacheDetails(teacherinfomap, id)
                          .then((value) {
                        Fluttertoast.showToast(
                            msg: "Add Successfuly",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.CENTER,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Colors.red,
                            textColor: Colors.white,
                            fontSize: 16.0);
                      });
                    } else {
                      print('try later');
                    }
                  },
                  child: Text("Add",
                      style: TextStyle(
                        color: Colors.indigo,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ))),
            )
          ],
        ),
      ),
    );
  }
}
