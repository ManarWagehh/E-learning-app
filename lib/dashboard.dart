import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fl_chart/fl_chart.dart';

class DataModel {
  String? key;
  String? value;

  DataModel({this.key, this.value});

  DataModel.fromJson(Map<String, dynamic> json) {
    key = json['key'];
    value = json['value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['key'] = this.key;
    data['value'] = this.value;
    return data;
  }
}

class BarChartWidget extends StatefulWidget {
  @override
  State<BarChartWidget> createState() => _BarChartWidgetState();
}

class _BarChartWidgetState extends State<BarChartWidget> {
  List<DataModel> _list = [];
  final currentUser = FirebaseAuth.instance.currentUser!;
  final firestoreInstance = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  void fetchData() async {
    try {
      DocumentSnapshot documentSnapshot = await firestoreInstance
          .collection('students')
          .doc(currentUser.uid)
          .get();

      if (documentSnapshot.exists) {
        var userData = documentSnapshot.data() as Map<String, dynamic>;
        if (userData.containsKey('6session')) {
          List<dynamic> sessions = userData['6session'] as List<dynamic>;
          List<DataModel> tempList = [];
          sessions.forEach((session) {
            if (session is Map<String, dynamic>) {
              session.forEach((key, value) {
                tempList.add(DataModel(key: key, value: value.toString()));
              });
            }
          });
          print("DataModel list: $tempList"); // Debug output
          setState(() {
            _list = tempList;
          });
        } else {
          print("6session field does not exist in the document");
        }
      } else {
        print("Document does not exist");
      }
    } catch (e) {
      print("Error fetching data: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.indigo,
        title: const Text(
          "Dashboard",
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
            final userData = snapshot.data!.data() as Map<String, dynamic>?;

            if (userData == null) {
              return Center(child: Text("No data available"));
            }

            List<PieChartSectionData> _buildPieChartSections() {
              double totalValue = 100.0;
              double focusValue =
                  double.parse(userData['averagefocous'].toString());
              double remainingValue = totalValue - focusValue;

              return [
                PieChartSectionData(
                  value: focusValue,
                  color: Colors.blue.shade900,
                  radius: 25,
                  showTitle: false,
                ),
                PieChartSectionData(
                  value: remainingValue,
                  color: Colors.transparent,
                  radius: 25,
                  showTitle: false,
                ),
              ];
            }

            return Column(
              children: [
                SizedBox(
                  height: 50,
                ),
                Center(
                  child: Text(
                    'Learning Style: ${userData['learning style']}',
                    style: TextStyle(
                        fontSize: 25,
                        color: Colors.indigo[900],
                        fontWeight: FontWeight.bold),
                  ),
                ),
                Expanded(
                  child: Container(
                    color: Colors.white,
                    height: 100,
                    width: 200,
                  ),
                  flex: 2,
                ),
                Expanded(
                  child: Container(
                    color: Colors.white,
                    height: 200,
                    width: 200,
                    child: _list.isNotEmpty
                        ? BarChart(
                            BarChartData(
                              backgroundColor: Colors.white,
                              barGroups: _chartGroups(),
                              borderData: FlBorderData(
                                border: const Border(
                                  bottom: BorderSide(color: Colors.black),
                                  left: BorderSide(color: Colors.black),
                                ),
                              ),
                              gridData: FlGridData(show: false),
                              titlesData: FlTitlesData(
                                bottomTitles:
                                    AxisTitles(sideTitles: _bottomTitles),
                                leftTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                    showTitles: true,
                                    reservedSize: 40,
                                    getTitlesWidget: (value, meta) {
                                      final double y = value.toDouble();
                                      if (y >= 0 && y < _list.length) {
                                        return Text(
                                          _list[y.toInt()].key!,
                                          style: const TextStyle(fontSize: 10),
                                        );
                                      }
                                      return const Text('');
                                    },
                                  ),
                                ),
                                topTitles: AxisTitles(
                                  sideTitles: SideTitles(showTitles: false),
                                ),
                                rightTitles: AxisTitles(
                                  sideTitles: SideTitles(showTitles: false),
                                ),
                              ),
                            ),
                          )
                        : Center(child: Text("No data available")),
                  ),
                  flex: 2,
                ),
                SizedBox(
                  height: 100,
                ),
                SizedBox(
                  height: 250,
                  child: Stack(
                    children: [
                      PieChart(
                        PieChartData(
                          startDegreeOffset: 250,
                          sectionsSpace: 0,
                          centerSpaceRadius: 100,
                          sections: _buildPieChartSections(),
                        ),
                      ),
                      Positioned.fill(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              height: 160,
                              width: 160,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.shade200,
                                    blurRadius: 10.0,
                                    spreadRadius: 10.0,
                                    offset: const Offset(3.0, 3.0),
                                  ),
                                ],
                              ),
                              child: Center(
                                child: Text(
                                  "Average Focus ${userData['averagefocous']} %",
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 50,
                ),
              ],
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }

  List<BarChartGroupData> _chartGroups() {
    List<BarChartGroupData> list =
        List<BarChartGroupData>.empty(growable: true);
    for (int i = 0; i < _list.length; i++) {
      list.add(BarChartGroupData(x: i, barRods: [
        BarChartRodData(
          toY: double.parse(_list[i].value!),
          color: Colors.indigo,
        ),
      ]));
    }
    return list;
  }

  SideTitles get _bottomTitles => SideTitles(
        showTitles: true,
        getTitlesWidget: (value, meta) {
          String text = '';
          switch (value.toInt()) {
            case 0:
              text = 's1';
              break;
            case 1:
              text = 's2';
              break;
            case 2:
              text = 's3';
              break;
            case 3:
              text = 's4';
              break;
            case 4:
              text = 's5';
              break;
            case 5:
              text = 's6';
              break;
          }
          return Text(
            text,
            style: TextStyle(fontSize: 10),
          );
        },
      );
}

void main() {
  runApp(MaterialApp(
    home: BarChartWidget(),
  ));
}
