import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfileStudent extends StatefulWidget {
  const ProfileStudent({super.key});

  @override
  State<ProfileStudent> createState() => _ProfileStudentState();
}

class _ProfileStudentState extends State<ProfileStudent> {
  final currentUser = FirebaseAuth.instance.currentUser!;
  final info = FirebaseFirestore.instance.collection("students").snapshots();
  final StudentsCollection = FirebaseFirestore.instance.collection("students");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.indigo,
          title: Text(
            'Student Profile',
            style: TextStyle(color: Colors.white),
          ),
          leading: IconButton(
            color: Colors.white,
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const BackButtonIcon(),
          ),
        ),
        body: StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection("students")
              .doc(currentUser.uid)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final userDate = snapshot.data!.data() as Map<String, dynamic>;
              return ListView(children: [
                SizedBox(
                  height: 50,
                ),
                Icon(
                  Icons.person,
                  size: 72,
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  '   Your Email',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                    margin: EdgeInsets.only(left: 10, right: 10),
                    padding: EdgeInsets.all(15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          currentUser.email!,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color.fromARGB(255, 56, 54, 54),
                          ),
                        ),
                        IconButton(
                            onPressed: () async {
                              String newValue = "";
                              await showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                        title:
                                            Text('Edit ' + userDate['email']),
                                        content: TextField(
                                          autofocus: true,
                                          decoration: InputDecoration(
                                              hintText: ('Enter new value ' +
                                                  userDate['email'])),
                                          onChanged: (value) {
                                            newValue = value;
                                          },
                                        ),
                                        actions: [
                                          TextButton(
                                              onPressed: () =>
                                                  Navigator.pop(context),
                                              child: Text('Cancel')),
                                          TextButton(
                                              onPressed: () =>
                                                  Navigator.of(context)
                                                      .pop(newValue),
                                              child: Text('Save'))
                                        ],
                                      ));
                              if (newValue.trim().length > 0) {
                                await StudentsCollection.doc(currentUser.uid)
                                    .update({'email': newValue});
                              }
                            },
                            icon: Icon(Icons.settings)),
                      ],
                    ),
                    decoration: BoxDecoration(
                        color: Color.fromARGB(255, 231, 231, 231),
                        borderRadius: BorderRadius.circular(50))),
                SizedBox(
                  height: 20,
                ),
                Text(
                  '   Your Name',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                    margin: EdgeInsets.only(left: 10, right: 10),
                    padding: EdgeInsets.all(15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          userDate['name'],
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color.fromARGB(255, 56, 54, 54),
                          ),
                        ),
                        IconButton(
                            onPressed: () async {
                              String newValue = "";
                              await showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                        title: Text('Edit ' + userDate['name']),
                                        content: TextField(
                                          autofocus: true,
                                          decoration: InputDecoration(
                                              hintText: ('Enter new value ' +
                                                  userDate['name'])),
                                          onChanged: (value) {
                                            newValue = value;
                                          },
                                        ),
                                        actions: [
                                          TextButton(
                                              onPressed: () =>
                                                  Navigator.pop(context),
                                              child: Text('Cancel')),
                                          TextButton(
                                              onPressed: () =>
                                                  Navigator.of(context)
                                                      .pop(newValue),
                                              child: Text('Save'))
                                        ],
                                      ));
                              if (newValue.trim().length > 0) {
                                await StudentsCollection.doc(currentUser.uid)
                                    .update({'name': newValue});
                              }
                            },
                            icon: Icon(Icons.settings))
                      ],
                    ),
                    decoration: BoxDecoration(
                        color: Color.fromARGB(255, 231, 231, 231),
                        borderRadius: BorderRadius.circular(50))),
                SizedBox(
                  height: 20,
                ),
                Text(
                  '   Your Password',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                    margin: EdgeInsets.only(left: 10, right: 10),
                    padding: EdgeInsets.all(15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          userDate['password'],
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color.fromARGB(255, 56, 54, 54),
                          ),
                        ),
                        IconButton(
                            onPressed: () async {
                              String newValue = "";
                              await showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                          title: Text(
                                              'Edit ' + userDate['password']),
                                          content: TextField(
                                            autofocus: true,
                                            decoration: InputDecoration(
                                                hintText: ('Enter new value ' +
                                                    userDate['password'])),
                                            onChanged: (value) {
                                              newValue = value;
                                            },
                                          ),
                                          actions: [
                                            TextButton(
                                                onPressed: () =>
                                                    Navigator.pop(context),
                                                child: Text('Cancel')),
                                            TextButton(
                                                onPressed: () =>
                                                    Navigator.of(context)
                                                        .pop(newValue),
                                                child: Text('Save'))
                                          ]));
                              if (newValue.trim().length > 0) {
                                await StudentsCollection.doc(currentUser.uid)
                                    .update({'password': newValue});
                              }
                            },
                            icon: Icon(Icons.settings))
                      ],
                    ),
                    decoration: BoxDecoration(
                        color: Color.fromARGB(255, 231, 231, 231),
                        borderRadius: BorderRadius.circular(50))),
                SizedBox(
                  height: 20,
                ),
              ]);
            } else if (snapshot.hasError) {
              return Center(
                child: Text('Error${snapshot.error}'),
              );
            }
            return Center(
              child: CircularProgressIndicator(),
            );
          },
        ));
  }
}
