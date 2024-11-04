import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'home_screen.dart';
import 'login.dart';

class WelcomeSceen extends StatelessWidget {
  const WelcomeSceen({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
          child: Stack(
            children: [
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height / 2.666,
                    decoration: BoxDecoration(
                      color: Color(0X00296b),
                    )),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height / 2.666,
                  padding: EdgeInsets.only(top: 40, bottom: 30),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                          BorderRadius.only(topLeft: Radius.circular(70))),
                  child: Column(
                    children: [
                      Text(
                        "learning is everything",
                        style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 1,
                            wordSpacing: 2),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 40),
                        child: Text(
                          "Learning with pleasure with Deer Programmer, Wherever you are.",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 17,
                              color: Colors.black.withOpacity(0.6)),
                        ),
                      ),
                      SizedBox(
                        height: 60,
                      ),
                      Material(
                        color: Colors.indigo,
                        borderRadius: BorderRadius.circular(10),
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => LoginPage()));
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                vertical: 15, horizontal: 80),
                            child: Text(
                              "Get Started",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height / 1.6,
                decoration: BoxDecoration(
                  color: Colors.white,
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height / 1.6,
                decoration: BoxDecoration(
                  
                    color: Colors.indigo,
                    borderRadius:
                        BorderRadius.only(bottomRight: Radius.circular(70))),
                child: Center(
                  child: Image.asset(
                    "assets/images/books.png",
                    scale: 0.8,
                  ),
                ),
              )
            ],
          ),
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height),
    );
  }
}
