
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:add_2_calendar/add_2_calendar.dart';
import 'package:intl/intl.dart';

class Exam{
  static Map<String, Color> lessonColors = <String, Color>{
    "Büro Yönetimi Ve Yönetici Asistanlığı": Colors.orange,
    "Harita ve Kadastro": Colors.red,
    "Harita ve Kadastro(İÖ)": Colors.orange,
    "İnternet ve Ağ Teknolojileri": Colors.yellow,
    "Kontrol Ve Otomasyon Teknolojisi": Colors.green,
    "Lojistik": Colors.cyan,
    "Makine": Colors.blue,
  };

  num lessonCode;
  String lessonName = "";
  String teacher = "";
  DateTime date ;
  String location = "";
  
  Exam({ this.lessonCode, 
    this.lessonName,
    this.teacher,
    this.date, 
    this.location,
    }){
  }

  static List<Exam> exams = <Exam>[
  ];

  static void loadCSV() {
    _loadAsset('assets/exam_list.csv').then((dynamic output) {
      String data = output;
      var lines = data.split('\n');
      var columns = lines[0];
      lines.removeAt(0);

      exams.clear();
      for (var line in lines) {
        var rows = line.split(',');
        exams.add(Exam(
          lessonCode: num.parse(rows[0]),
          lessonName: rows[1],
          teacher : rows[2],
          // Olması gereken format 2012-02-27T13:27:00
          date : DateTime.parse(rows[3]),
          location : rows[4],
        ));
      }
      print("Parsed exams count:" + exams.length.toString());
    });
  }
  static Future<String> _loadAsset(String path) async {
   return await rootBundle.loadString(path);
  }
}

class ExamItem extends StatelessWidget {
  
  const ExamItem({ Key key, @required this.exam})
    : assert(exam != null),
      super(key: key);

  // This height will allow for all the Card's content to fit comfortably within the card.
  static const double height = 160.0;
  final Exam exam;


  Card insideCard(BuildContext context) => Card(
            // This ensures that the Card's children are clipped correctly.
            clipBehavior: Clip.antiAlias,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(24.0)),
            ),
            color: exam.date.isBefore(DateTime.now()) ? Color(0xFFFFEBEE) : Colors.white,
            child: Stack(
              fit: StackFit.expand,
              overflow: Overflow.clip,
              children: <Widget>[
                Container(
                  alignment: Alignment.topRight,
                  margin: EdgeInsets.all(10.0),
                  child: FloatingActionButton(
                    mini: true,
                    backgroundColor: Colors.deepOrangeAccent,
                    child: Icon(Icons.calendar_today),
                    onPressed: (){
                      //--------------------------------------------
                      final Event event = Event(
                        title: exam.lessonName + " Exam",
                        //description: exam.lessonName + " Exam",
                        location: exam.location,
                        startDate: exam.date,
                        endDate: exam.date.add(Duration(hours: 2)),
                      );
                      Add2Calendar.addEvent2Cal(event);
                      //--------------------------------------------
                    },                    
                  ),
                ),
                Container(
                  alignment: Alignment.bottomLeft,
                  margin: EdgeInsets.fromLTRB(5.0,5.0,5.0,5.0),
                  child: Row(
                    children: <Widget>[
                      Column(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          const Text('No', textAlign: TextAlign.left,style: TextStyle(fontWeight: FontWeight.bold),),
                          const Text('Name', textAlign: TextAlign.left,style: TextStyle(fontWeight: FontWeight.bold),),
                          const Text('Teacher', textAlign: TextAlign.left,style: TextStyle(fontWeight: FontWeight.bold),),
                          const Text('Location', textAlign: TextAlign.left,style: TextStyle(fontWeight: FontWeight.bold),),
                          //const Text('Date', textAlign: TextAlign.left,style: TextStyle(fontWeight: FontWeight.bold),),
                          //const Text('Time', textAlign: TextAlign.left,style: TextStyle(fontWeight: FontWeight.bold),),
                        ],
                      ),
                      Column(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          const Text(':  ', textAlign: TextAlign.center,),
                          const Text(':  ', textAlign: TextAlign.center,),
                          const Text(':  ', textAlign: TextAlign.center,),
                          const Text(':  ', textAlign: TextAlign.center,),
                          //const Text(':  ', textAlign: TextAlign.center,),
                          //const Text(':  ', textAlign: TextAlign.center,),
                        ],
                      ),
                      Column(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Text(exam.lessonCode.toString(), textAlign: TextAlign.left,),
                          Text(exam.lessonName, textAlign: TextAlign.left,),
                          Text(exam.teacher, textAlign: TextAlign.left,),
                          Text(exam.location, textAlign: TextAlign.left,),
                          //Text(new DateFormat('yyyy-MM-dd').format(exam.date), textAlign: TextAlign.left,),
                          //Text(new DateFormat('hh:mm').format(exam.date), textAlign: TextAlign.left,),
                        ],
                      ),
                    ],
                  )
                ),
                Container(
                  alignment: Alignment.bottomRight,
                  margin: EdgeInsets.all(14.0),
                  child: Column(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          const Text('Date', 
                            textAlign: TextAlign.left,
                            style: TextStyle(fontWeight: FontWeight.bold), 
                          ),
                          Text(new DateFormat('yyyy-MM-dd').format(exam.date), 
                            textAlign: TextAlign.left,
                            ),
                          const Text('Time', 
                            textAlign: TextAlign.left,
                            style: TextStyle(fontWeight: FontWeight.bold),),
                          Text(new DateFormat('hh:mm').format(exam.date), 
                            textAlign: TextAlign.left,),
                        ],
                      ),
                ),
              ],
            ),
          );

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.all(2.0),
        child: SizedBox(
          height: height,
          width: MediaQuery.of(context).size.width * 9,
          child: Card(
            margin: EdgeInsets.all(5.0),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(24.0)),
            ),
            color: exam.date.isBefore(DateTime.now()) ? Colors.redAccent : Colors.grey,
            child: Stack(
              children: <Widget>[
                Container(
                  alignment: Alignment.bottomCenter,
                  child : insideCard(context)
                )
                
              ],
            ),
          )
        ),
      ),
    );
  }
}