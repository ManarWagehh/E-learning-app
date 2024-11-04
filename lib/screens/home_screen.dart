import 'package:flutter/material.dart';
import 'package:graduationproject/dashboard.dart';
import 'package:graduationproject/screens/course_screen.dart';

import 'package:graduationproject/screens/login.dart';
import 'package:graduationproject/screens/profile_student.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

class Course {
  final String name;
  final String imageUrl;
  bool isFavorite;

  Course(this.name, this.imageUrl, {this.isFavorite = false});
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late List<Course> allCourses;
  late List<Course> displayedCourses;
  var inputText = '';

  @override
  void initState() {
    super.initState();
    allCourses = [];
    displayedCourses = [];
    loadCourses();
  }

  void loadCourses() async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('courses').get();

    setState(() {
      allCourses = querySnapshot.docs
          .map((doc) => Course(
                doc['name'],
                doc['imageUrl'],
              ))
          .toList();

      displayedCourses = List.from(allCourses);
    });
  }

  void searchCourses(String query) {
    setState(() {
      displayedCourses = allCourses
          .where((course) =>
              course.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          Container(
            padding: EdgeInsets.only(top: 15, right: 15, left: 15, bottom: 10),
            decoration: BoxDecoration(
              color: Colors.indigo,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      color: Colors.white,
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => LoginPage()),
                        );
                      },
                      icon: const BackButtonIcon(),
                    ),
                    IconButton(
                      color: Colors.white,
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => BarChartWidget()),
                        );
                      },
                      icon: Icon(
                        Icons.dashboard,
                        size: 30,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: EdgeInsets.only(left: 3, bottom: 15),
                  child: Text(
                    "Hi , Programmer",
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1,
                      wordSpacing: 2,
                      color: Colors.white,
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 5, bottom: 20),
                  width: MediaQuery.of(context).size.width,
                  height: 55,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: TextFormField(
                    onChanged: (val) {
                      searchCourses(val);
                      setState(() {
                        inputText = val;
                      });
                      print(inputText);
                    },
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "Search here...",
                      hintStyle:
                          TextStyle(color: Colors.black.withOpacity(0.5)),
                      prefixIcon: Icon(
                        Icons.search,
                        size: 25,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Courses",
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 23),
              ),
              Text(
                "See All",
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 18,
                  color: Colors.indigo[900],
                ),
              )
            ],
          ),
          SizedBox(
            height: 10,
          ),
          GridView.builder(
            itemCount: displayedCourses.length,
            itemBuilder: (context, index) {
              return buildCourseItem(displayedCourses[index]);
            },
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 3 / 4,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
            ),
          ),
        ],
      ),
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Colors.white,
        color: Colors.indigo,
        items: [
          IconButton(
            icon: Icon(Icons.home, color: Colors.white),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => HomePage()),
            ),
          ),
          IconButton(
            icon: Icon(Icons.person, color: Colors.white),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ProfileStudent()),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildCourseItem(Course course) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CourseScreen(course.name, course.imageUrl),
          ),
        );
      },
      child: Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Color(0xFFF5F3FF),
        ),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(10),
              child: Image.network(
                course.imageUrl,
                width: 100,
                height: 100,
              ),
            ),
            SizedBox(height: 10),
            Text(
              course.name,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w600,
                color: Colors.black.withOpacity(0.6),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
