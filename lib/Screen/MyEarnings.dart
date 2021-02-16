import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class MyEarnings extends StatefulWidget {
  @override
  _MyEarningsState createState() => _MyEarningsState();
}

class _MyEarningsState extends State<MyEarnings> {
  CalendarController _controller;

  @override
  void initState() {
    super.initState();
    _controller = CalendarController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Earnings'),
      ),
      body:
      Container(
        height: MediaQuery.of(context).size.height,
        child: new ListView(
          scrollDirection: Axis.vertical,
          children: new List.generate(10, (int index) {
            return AnimationConfiguration.staggeredList(
              position: index,
              duration: const Duration(milliseconds : 600),
              child: SlideAnimation(
                verticalOffset: 70,
                child: FadeInAnimation(
                  child: new Card(
                    elevation: 8,
                    color: Colors.white,
                    child: new Container(
                      width: 50.0,
                      height: 95.0,
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Container(
                              width: 60,
                              height: 80,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text("10th \n Oct",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w900,
                                      fontSize: 16,
                                      color: Colors.white,
                                  ),
                                ),
                              ),
                              decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                      offset: Offset(5, 5),
                                      spreadRadius: 1.0),
                                ],
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(
                                  color: Colors.white,
                                  width: 1,
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top:25.0,left: 20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Arpit Shah",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 25,
                                    color: Colors.deepOrange,
                                    fontFamily: 'Lato',
                                  ),
                                ),
                                Text("My Studio",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 17,
                                      color: Colors.purple,
                                    fontFamily: 'Lato',
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: 8,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Container(
                              width: 64,
                              height: 85,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text("100 \nPoints",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: Colors.black,
                                    fontFamily: 'Lato',
                                    backgroundColor: Colors.limeAccent,
                                  ),
                                ),
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(
                                  color: Colors.white,
                                  width: 1,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}