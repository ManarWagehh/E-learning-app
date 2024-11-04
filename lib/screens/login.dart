import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:graduationproject/admin_screens/admin_dashboard.dart';
import 'package:graduationproject/instractor_screens/home_teacher.dart';
import 'package:graduationproject/screens/forget_password.dart';
import 'package:graduationproject/screens/home_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginPage extends StatelessWidget {
  final _formkey = GlobalKey<FormState>();
  final _auth = FirebaseAuth.instance;
  User? _currentUser;
  String _email = '';
  String _password = '';
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<String> documentIds = [];
  List<String> documentIds2 = [];

  TextEditingController _UserEmailController = TextEditingController();
  TextEditingController _UserPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
            gradient: LinearGradient(begin: Alignment.topCenter, colors: [
          Colors.indigo.shade900,
          Colors.indigo.shade700,
          Colors.indigo.shade300
        ])),
        child: Form(
          key: _formkey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                height: 80,
              ),
              Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    FadeInUp(
                        duration: Duration(milliseconds: 1000),
                        child: Text(
                          "Login",
                          style: TextStyle(color: Colors.white, fontSize: 40),
                        )),
                    SizedBox(
                      height: 10,
                    ),
                    FadeInUp(
                        duration: Duration(milliseconds: 1300),
                        child: Text(
                          "Welcome Back",
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        )),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(60),
                          topRight: Radius.circular(60))),
                  child: Padding(
                    padding: EdgeInsets.all(30),
                    child: Column(
                      children: <Widget>[
                        SizedBox(
                          height: 60,
                        ),
                        FadeInUp(
                            duration: Duration(milliseconds: 1400),
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.indigo,
                                        blurRadius: 20,
                                        offset: Offset(0, 10))
                                  ]),
                              child: Column(
                                children: <Widget>[
                                  Container(
                                    padding: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                        border: Border(
                                            bottom: BorderSide(
                                                color: Colors.grey.shade200))),
                                    child: TextFormField(
                                      onChanged: (value) {
                                        _email = value;
                                      },
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return "Enter Your Email";
                                        }
                                        return null;
                                      },
                                      controller: _UserEmailController,
                                      decoration: InputDecoration(
                                          hintText: "Email",
                                          hintStyle:
                                              TextStyle(color: Colors.grey),
                                          border: InputBorder.none),
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                        border: Border(
                                            bottom: BorderSide(
                                                color: Colors.grey.shade200))),
                                    child: TextFormField(
                                      onChanged: (value) {
                                        _password = value;
                                      },
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return "Enter Your Password";
                                        }
                                        return null;
                                      },
                                      controller: _UserPasswordController,
                                      obscureText: true,
                                      decoration: InputDecoration(
                                          hintText: "Password",
                                          hintStyle:
                                              TextStyle(color: Colors.grey),
                                          border: InputBorder.none),
                                    ),
                                  ),
                                ],
                              ),
                            )),
                        SizedBox(
                          height: 40,
                        ),
                        FadeInUp(
                            duration: Duration(milliseconds: 1500),
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ResetPassword()));
                              },
                              child: Text(
                                "Forgot Password?",
                                style: TextStyle(color: Colors.grey),
                              ),
                            )),
                        SizedBox(
                          height: 40,
                        ),
                        FadeInUp(
                            duration: Duration(milliseconds: 1600),
                            child: MaterialButton(
                              onPressed: () async {
                                if (_formkey.currentState!.validate()) {
                                  try {
                                    var student =
                                        await _auth.signInWithEmailAndPassword(
                                            email: _email, password: _password);

                                    if (student != null) {
                                      final id = await FirebaseAuth
                                          .instance.currentUser!.uid;
                                      QuerySnapshot querySnapshot =
                                          await FirebaseFirestore.instance
                                              .collection("students")
                                              .get();
                                      QuerySnapshot querySnapshot1 =
                                          await FirebaseFirestore.instance
                                              .collection("teachers")
                                              .get();

                                      querySnapshot.docs.forEach((doc) {
                                        documentIds.add(doc.id);
                                      });
                                      querySnapshot1.docs.forEach((doc) {
                                        documentIds2.add(doc.id);
                                      });
                                      if (documentIds.contains(id)) {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => HomePage(),
                                          ),
                                        );
                                      } else if (documentIds2.contains(id)) {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => HomeTeacher(),
                                          ),
                                        );
                                      } else {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => MyWidget(),
                                          ),
                                        );
                                      }
                                    }
                                  } catch (e) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                            "Incorrect email or password. Please try again."),
                                      ),
                                    );
                                  }
                                }
                              },
                              height: 50,
                              color: Colors.indigo,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50),
                              ),
                              child: Center(
                                child: Text(
                                  "Login",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            )),
                        SizedBox(
                          height: 50,
                        ),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
