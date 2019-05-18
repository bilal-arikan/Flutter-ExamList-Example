import 'package:exam_calendar/exam.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Exam Calendar',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: ExamCalendarDemo(),
    );
  }
}

class ExamCalendarDemo extends StatefulWidget {

  @override
  _ExamCalendarDemoState createState() => _ExamCalendarDemoState();
}

class _ExamCalendarDemoState extends State<ExamCalendarDemo> {

  _openExamsFile() async {
    const url = 'https://github.com/bilal1993arikan/Flutter_ExamList_Example';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  List<Exam> foundExams = <Exam>[];

  showSearchDialog(BuildContext context){
    showDialog(
      context: context,
      builder: (_) => new AlertDialog(
          title: new Text("Search",
            textAlign: TextAlign.center,
          ),
          content: Container(
            height: 80,
            child: Column(
              children: <Widget>[
                Text("Enter a Lesson Name:"),
                TextField(
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.text,
                  onChanged: (str){
                    setState(() {
                      if(str.length == 0)
                        foundExams = Exam.exams.toList();
                      else
                        foundExams = Exam.exams.where((e) => e.lessonName.toString().contains(str)).toList();
                      foundExams.sort((a,b)=> a.date.microsecondsSinceEpoch);

                      print("Founded: " + foundExams.length.toString());
                    });
                  },
                ),
              ],
            ),
          ),
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    Exam.loadCSV();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Exam List'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(
              Icons.find_in_page,
              semanticLabel: 'update shape',
            ),
            onPressed: _openExamsFile,
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.only( left: 8.0, right: 8.0),
        children:
         foundExams.length > 0 ? 
         foundExams.map<Widget>((Exam e) {
          Widget child;
          child = ExamItem(exam: e);

          return Container(
            child: child,
          );
        }).toList() :
        <Widget>[
          Center(
            heightFactor: 3.0,
            child: Column(
              children: <Widget>[
                Icon(Icons.search,size: 40.0,)
              ],
            )
          ),
          Text(
            "Couldnt Find Any Exam.",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 24.0
            ),
            ),
          Text(
            "To Search any Exam, Click the Search Button",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18.0,
              color: Colors.red,
            ),
          ),
        ]
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.search),
        onPressed: () {
              showSearchDialog(context);
            },
      ),
    );
  }
}