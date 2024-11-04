import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:graduationproject/service/database.dart';
import 'package:flutter/material.dart';
import 'students.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  Stream? studentstream;
  getontheload() async {
    studentstream = await databaseMethods().GetStudentDetails();
    setState(() {});
  }

  @override
  void initState() {
    getontheload();
    super.initState();
  }

  Widget allStudentDetails() {
    return StreamBuilder(
        stream: studentstream,
        builder: (context, AsyncSnapshot snapshot) {
          return snapshot.hasData
              ? ListView.builder(
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: (context, index) {
                    DocumentSnapshot ds = snapshot.data.docs[index];
                    return Container(
                      margin: EdgeInsets.only(bottom: 20),
                      child: Material(
                        elevation: 5,
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10)),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Text(
                                    "Name : " + ds["name"],
                                    style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Spacer(),
                                  GestureDetector(
                                      onTap: () {
                                        name.text = ds["name"];
                                        email.text = ds["email"];
                                        password.text = ds["password"];
                                        EditStudentdetails(ds["id"]);
                                      },
                                      child: Icon(Icons.edit,
                                          color: Colors.indigo)),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  GestureDetector(
                                      onTap: () async {
                                        await databaseMethods()
                                            .DeleteStudentDetails(ds["id"]);
                                      },
                                      child:
                                          Icon(Icons.delete, color: Colors.red))
                                ],
                              ),
                              Text(
                                "Email : " + ds["email"],
                                style: TextStyle(
                                    color: Colors.indigo,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                "Password : " + ds["password"],
                                style: TextStyle(
                                    color: Colors.indigo,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  })
              : Container();
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color.fromARGB(255, 244, 244, 244),
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => Students()));
        },
        child: Icon(
          Icons.add,
          color: Colors.indigo,
        ),
      ),
      appBar: AppBar(
        backgroundColor: Colors.indigo,
        leading: IconButton(
          color: Colors.white,
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const BackButtonIcon(),
        ),
        title: Center(
          child: Row(
            children: [
              Text("Students",
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
        margin: EdgeInsets.only(left: 10, right: 10, top: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [Expanded(child: allStudentDetails())],
        ),
      ),
    );
  }

  Future EditStudentdetails(String id) => showDialog(
      context: context,
      builder: (context) => AlertDialog(
            backgroundColor: Color.fromARGB(255, 244, 244, 244),
            content: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Icon(Icons.cancel)),
                      SizedBox(
                        width: 60,
                      ),
                      Text("Edit Details",
                          style: TextStyle(
                            color: Colors.indigo,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          )),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
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
                    height: 30,
                  ),
                  Center(
                      child: ElevatedButton(
                          onPressed: () async {
                            Map<String, dynamic> Updateinfomap = {
                              "name": name.text,
                              "id": id,
                              "email": email.text,
                              "password": password.text,
                              "role": "student"
                            };
                            await databaseMethods()
                                .UpdateStudentDetails(id, Updateinfomap)
                                .then((value) {
                              Navigator.pop(context);
                            });
                          },
                          child: Text(
                            "Update",
                            style: TextStyle(color: Colors.indigo),
                          )))
                ],
              ),
            ),
          ));
}
