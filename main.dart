import 'dart:convert';
import 'package:checklist_tracker_wip/edit_info_screen.dart';
import 'package:flutter/material.dart';
import 'package:checklist_tracker_wip/item_data.dart';
import 'package:flutter_alarm_clock/flutter_alarm_clock.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_alarm_clock/flutter_alarm_clock.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

String _savedList = '';
int listLength = 0;
bool canLoad = true;

void loadList(){
  SharedPreferences.getInstance().then((pref) {
    _savedList = pref.getString('savedList')!;
    if(_savedList.length > 0) {
      const splitter = LineSplitter();
      final separatedText = splitter.convert(_savedList);
      listLength = separatedText.length ~/ 19;
      for (int i = 0; i < listLength; i++) {
        itemList.add(ChecklistItem('', false, false, false, false, false, 'Grey', Colors.grey, Colors.transparent, false, '', 1, 'Days', 0, 0, 99, 99, 9999, -1, -1, -1, -1, -1));
        //should find name values for each item
        //each item is 19 lines long
        //name is always on the first line of the block, color is always the second line, etc
        //start of substring containing info differs per line, but is the same per type
        //for example name for item 1 and name for item 2 will start at the same substring
        setState((){
          itemList[i].name = separatedText[0 + (19 * i)].substring(13, separatedText[0 + (19 * i)].length - 1);
          itemList[i].color = separatedText[1 + (19 * i)].substring(14, separatedText[1 + (19 * i)].length - 1);
          setDisplayColor();
          itemList[i].description = separatedText[2 + (19 * i)].substring(20, separatedText[2 + (19 * i)].length - 1);
          itemList[i].frequencyType = separatedText[3 + (19 * i)].substring(23, separatedText[3 + (19 * i)].length - 1);
          //if else to get bool from the list string
          if(separatedText[4 + (19 * i)].substring(18, separatedText[4 + (19 * i)].length - 1) == 'true'){
            itemList[i].completed = true;
          }
          else{
            itemList[i].completed = false;
          }
          if(separatedText[5 + (19 * i)].substring(14, separatedText[5 + (19 * i)].length - 1) == 'true'){
            itemList[i].alarm = true;
          }
          else{
            itemList[i].alarm = false;
          }
          if(separatedText[6 + (19 * i)].substring(33, separatedText[6 + (19 * i)].length - 1) == 'true'){
            itemList[i].alarmOnCheckmarkReset = true;
          }
          else{
            itemList[i].alarmOnCheckmarkReset = false;
          }
          if(separatedText[7 + (19 * i)].substring(21, separatedText[7 + (19 * i)].length - 1) == 'true'){
            itemList[i].alarmCustom = true;
          }
          else{
            itemList[i].alarmCustom = false;
          }
          itemList[i].frequencyNum = int.parse(separatedText[8 + (19 * i)].substring(25, separatedText[8 + (19 * i)].length - 1));
          itemList[i].checkedMonth = int.parse(separatedText[9 + (19 * i)].substring(29, separatedText[9 + (19 * i)].length - 1));
          itemList[i].checkedDay = int.parse(separatedText[10 + (19 * i)].substring(27, separatedText[10 + (19 * i)].length - 1));
          itemList[i].checkedYear = int.parse(separatedText[11 + (19 * i)].substring(28, separatedText[11 + (19 * i)].length - 1));
          itemList[i].checkedHour = int.parse(separatedText[12 + (19 * i)].substring(28, separatedText[12 + (19 * i)].length - 1));
          itemList[i].checkedMinute = int.parse(separatedText[13 + (19 * i)].substring(31, separatedText[13 + (19 * i)].length - 1));
          itemList[i].alarmDay = int.parse(separatedText[14 + (19 * i)].substring(18, separatedText[14 + (19 * i)].length - 1));
          itemList[i].alarmMonth = int.parse(separatedText[15 + (19 * i)].substring(20, separatedText[15 + (19 * i)].length - 1));
          itemList[i].alarmYear = int.parse(separatedText[16 + (19 * i)].substring(19, separatedText[16 + (19 * i)].length - 1));
          itemList[i].alarmHours = int.parse(separatedText[17 + (19 * i)].substring(19, separatedText[17 + (19 * i)].length - 1));
          itemList[i].alarmMinutes = int.parse(separatedText[18 + (19 * i)].substring(22, separatedText[18 + (19 * i)].length - 1));
        });
      }

    }
    else{
      _savedList = '';
    }
  });
  setState((){

  });
}

void _saveList() {
    //initialize file to blank so items aren't duplicated if the button
    //is pressed more than once
    _savedList = '';
    //save each item's data
      for (int i = 0; i < itemList.length; i++) {
        _savedList += 'Item $i Name: ${itemList[i].name} \n';
        _savedList += 'Item $i Color: ${itemList[i].color} \n';
        _savedList += 'Item $i Description: ${itemList[i].description} \n';
        _savedList += 'Item $i Frequency Type: ${itemList[i].frequencyType} \n';
        _savedList += 'Item $i Completed: ${itemList[i].completed.toString()} \n';
        _savedList += 'Item $i Alarm: ${itemList[i].alarm.toString()} \n';
        _savedList += 'Item $i Alarm on Checkmark Reset: ${itemList[i].alarmOnCheckmarkReset.toString()} \n';
        _savedList += 'Item $i Custom Alarm: ${itemList[i].alarmCustom.toString()} \n';
        _savedList += 'Item $i Frequency Number: ${itemList[i].frequencyNum.toString()} \n';
        _savedList += 'Item $i Last Completed Month: ${itemList[i].checkedMonth.toString()} \n';
        _savedList += 'Item $i Last Completed Day: ${itemList[i].checkedDay.toString()} \n';
        _savedList += 'Item $i Last Completed Year: ${itemList[i].checkedYear.toString()} \n';
        _savedList += 'Item $i Last Completed Hour: ${itemList[i].checkedHour.toString()} \n';
        _savedList += 'Item $i Last Completed Minutes: ${itemList[i].checkedMinute.toString()} \n';
        _savedList += 'Item $i Alarm Day: ${itemList[i].alarmDay.toString()} \n';
        _savedList += 'Item $i Alarm Month: ${itemList[i].alarmMonth.toString()} \n';
        _savedList += 'Item $i Alarm Year: ${itemList[i].alarmYear.toString()} \n';
        _savedList += 'Item $i Alarm Hour: ${itemList[i].alarmHours.toString()} \n';
        _savedList += 'Item $i Alarm Minutes: ${itemList[i].alarmMinutes.toString()} \n';
      }
    setState((){

    });
}

List<ChecklistItem> itemList = <ChecklistItem>[];


void setDisplayColor(){
  //set color value for each list item based on its saved color name string
  for(int i = 0; i < itemList.length; i++){
    if(itemList[i].color.contains('Grey') == true){
      itemList[i].color = 'Grey'; //make sure there are no spacing issues for the other screen
      itemList[i].bgColor = Colors.grey;
    }
    else if(itemList[i].color.contains('Red') == true){
      itemList[i].color = 'Red';
      itemList[i].bgColor = Colors.red;
    }
    else if(itemList[i].color.contains('Orange') == true){
      itemList[i].color = 'Orange';
      itemList[i].bgColor = Colors.orange;
    }
    else if(itemList[i].color.contains('Yellow') == true){
      itemList[i].color = 'Yellow';
      itemList[i].bgColor = Colors.yellow;
    }
    else if(itemList[i].color.contains('Green') == true){
      itemList[i].color = 'Green';
      itemList[i].bgColor = Colors.green;
    }
    else if(itemList[i].color.contains('Blue') == true){
      itemList[i].color = 'Blue';
      itemList[i].bgColor = Colors.blue;
    }
    else if(itemList[i].color.contains('Purple') == true){
      itemList[i].color = 'Purple';
      itemList[i].bgColor = Colors.deepPurple;
    }
    else {
      itemList[i].color = 'Grey';
      itemList[i].bgColor = Colors.grey;
    }
  }
  setState(() {

  });
}

void setCheckmarkReset(int index){
  final now = DateTime.now();
  if(itemList[index].frequencyType == 'Hours'){
    if(now.hour >= itemList[index].checkedHour + itemList[index].frequencyNum && now.minute >= itemList[index].checkedMinute){
      //if current time is later than when the check mark should reset,
      //reset the check mark
      itemList[index].completed = false;
    }
  }
  else{
    if(now.hour >= itemList[index].checkedHour && now.minute >= itemList[index].checkedMinute){
      //if current time is later than when the check mark should reset,
      //reset the check mark
      itemList[index].completed = false;
    }
  }
}

void setAlarmAndCheckmarkReset(){
  final now = DateTime.now();
  //if alarm is set, make the icon visible by changing its color
  //if alarm is not set, make the icon invisible by making it transparent
  for(int i = 0; i < itemList.length; i++) {
    if (itemList[i].alarm == true) { //alarm set
      itemList[i].alarmColor = itemList[i].bgColor[900]; //alarm icon
      if (itemList[i].alarmOnCheckmarkReset == true && itemList[i].completed == true) { //alarm on check mark reset
        if (itemList[i].frequencyType == 'Hours') { //alarm type hours
          FlutterAlarmClock.createAlarm(itemList[i].checkedHour + itemList[i].frequencyNum, itemList[i].checkedMinute);
          setCheckmarkReset(i);
        }
        else if (itemList[i].frequencyType == 'Days') { //alarm type days
          if (now.day >= itemList[i].checkedDay + itemList[i].frequencyNum) { //if today is when the check mark should reset
            FlutterAlarmClock.createAlarm(itemList[i].checkedHour, itemList[i].checkedMinute);
            setCheckmarkReset(i);
          }
        }
        else if (itemList[i].frequencyType == 'Weeks') { //alarm type weeks
          if (now.day >= itemList[i].checkedDay + itemList[i].frequencyNum * 7) {
            FlutterAlarmClock.createAlarm(itemList[i].checkedHour, itemList[i].checkedMinute);
            setCheckmarkReset(i);
          }
        }
        else if (itemList[i].frequencyType == 'Months') { //alarm type weeks
          if (now.month >= itemList[i].checkedMonth + itemList[i].frequencyNum) {
            FlutterAlarmClock.createAlarm(itemList[i].checkedHour, itemList[i].checkedMinute);
            setCheckmarkReset(i);

          }
        }
      }
      else if(itemList[i].alarmCustom == true){
        if (itemList[i].frequencyType == 'Hours') { //alarm type hours
          FlutterAlarmClock.createAlarm(itemList[i].alarmHours, itemList[i].alarmMinutes);
          setCheckmarkReset(i);
        }
        else if (itemList[i].frequencyType == 'Days') { //alarm type days
          if (now.day >= itemList[i].checkedDay + itemList[i].frequencyNum) {
            FlutterAlarmClock.createAlarm(itemList[i].alarmHours, itemList[i].alarmMinutes);
            setCheckmarkReset(i);
          }
        }
        else if (itemList[i].frequencyType == 'Weeks') { //alarm type weeks
          if (now.day >= itemList[i].checkedDay + itemList[i].frequencyNum * 7) {
            FlutterAlarmClock.createAlarm(itemList[i].alarmHours, itemList[i].alarmMinutes);
            setCheckmarkReset(i);
          }
        }
        else if (itemList[i].frequencyType == 'Months') { //alarm type weeks
          if (now.month >= itemList[i].checkedMonth + itemList[i].frequencyNum) {
            FlutterAlarmClock.createAlarm(itemList[i].alarmHours, itemList[i].alarmMinutes);
            setCheckmarkReset(i);
          }
        }
      }
    }
    else { //no alarm
      itemList[i].alarmColor = Colors.transparent;
      switch(itemList[i].frequencyType){
        case 'Hours': {
          setCheckmarkReset(i);
        }
        break;
        case 'Days': {
          if (now.day >= itemList[i].checkedDay + itemList[i].frequencyNum) {
            setCheckmarkReset(i);
          }
        }
        break;
        case 'Weeks': {
          if (now.day >= itemList[i].checkedDay + itemList[i].frequencyNum * 7) {
            setCheckmarkReset(i);
          }
        }
        break;
        case 'Months': {
          if (now.month >= itemList[i].checkedMonth + itemList[i].frequencyNum) {
            setCheckmarkReset(i);
          }
        }
        break;
        default:
        break;
      }
    }
  }
  setState(() {

  });
}


//sets 'last completed' to current date and time when the item is checked off
void setToCurrentDateAndTime(bool isCompleted, int index) {
  final now = DateTime.now();
  String checkedHour = '00';
  String checkedMinute = '00';
  //if item is being marked as complete,
  //set 'last completed' to current date/time
  if (isCompleted == true) {
    itemList[index].checkedDay = now.day;
    itemList[index].checkedMonth = now.month;
    itemList[index].checkedYear = now.year;
    itemList[index].checkedHour = now.hour;
    itemList[index].checkedMinute = now.minute;
  }
  //if a clock value is < 10,
  //display w/ a 0 before it
  if(itemList[index].checkedHour < 10){
    checkedHour = '0${itemList[index].checkedHour}';
  }
  else if(itemList[index].checkedMinute < 10){
    checkedMinute = '0${itemList[index].checkedMinute}';
  }
  else{
    checkedHour = '${itemList[index].checkedHour}';
    checkedMinute = '${itemList[index].checkedMinute}';
  }
}

//if a clock value is <10, display w/ a 0 before it
String displayDateAndTime(int index){
  String dateAndTime = '';
  if(itemList[index].checkedHour < 10 && itemList[index].checkedMinute < 10){
    dateAndTime = '${itemList[index].checkedMonth}/${itemList[index].checkedDay}/${itemList[index].checkedYear}   0${itemList[index].checkedHour}:0${itemList[index].checkedMinute}';
  }
  else if(itemList[index].checkedHour < 10){
    dateAndTime = '${itemList[index].checkedMonth}/${itemList[index].checkedDay}/${itemList[index].checkedYear}   0${itemList[index].checkedHour}:${itemList[index].checkedMinute}';
  }
  else if(itemList[index].checkedMinute < 10){
    dateAndTime = '${itemList[index].checkedMonth}/${itemList[index].checkedDay}/${itemList[index].checkedYear}   ${itemList[index].checkedHour}:0${itemList[index].checkedMinute}';
  }
  else{
    dateAndTime = '${itemList[index].checkedMonth}/${itemList[index].checkedDay}/${itemList[index].checkedYear}   ${itemList[index].checkedHour}:${itemList[index].checkedMinute}';
  }
  return dateAndTime;
}

  @override
  Widget build(BuildContext context) {
    setDisplayColor();
    setAlarmAndCheckmarkReset();
    int length = 0;
    return Scaffold(
      body: SingleChildScrollView(
        physics: const ScrollPhysics(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            //title row
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                //title
                Container(
                  margin: EdgeInsets.only(top: 30, left: 15),
                  child: Text(
                    'Items',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 50,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Spacer(),
                //clear, load, save
                Container(
                  child: FloatingActionButton(
                    onPressed: (){
                      SharedPreferences.getInstance().then((pref) {
                        _savedList = '';
                        pref.setString('savedList', _savedList);
                        length = itemList.length;
                        for(int i = length - 1; i >= 0; i--){
                          itemList.removeAt(i);
                        }
                        setState((){

                        });
                      });
                    },
                    child: Icon(Icons.clear),
                    backgroundColor: Colors.red,
                    tooltip: 'delete save data',
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 5, right: 5),
                child: FloatingActionButton(
                  onPressed: (){
                    if(canLoad == true) {
                      setState(() {
                        loadList();
                      });
                      canLoad = false; //prevents loading more than once
                    }
                  },
                  child: Icon(Icons.upload),
                  backgroundColor: Colors.indigo[400],
                  tooltip: 'load list',
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(right: 10),
                  child: FloatingActionButton(
                    onPressed: (){
                      SharedPreferences.getInstance().then((pref) {
                        _saveList();
                        pref.setString('savedList', _savedList);
                      });
                    },
                    child: Icon(Icons.save),
                    backgroundColor: Colors.indigo[400],
                    tooltip: 'save list',
                  ),
                ),
              ],
            ),
            //line below title
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Container(
                    margin: EdgeInsets.only(top: 5, left: 10, right: 10),
                    alignment: Alignment.center,
                    color: Colors.grey,
                    height: 2,
                  ),
                ),
              ],
            ),
           //main item list
           itemList.length > 0
           ? ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: itemList.length,
                itemBuilder: (BuildContext context, int index){
                  return Container(
                    margin: const EdgeInsets.only(top: 5, left: 10, right: 10, bottom: 5),
                    height: 100,
                    decoration: const BoxDecoration(
                      border: Border(
                        top: BorderSide(width: 4.0, color: Colors.black),
                        left: BorderSide(width: 4.0, color: Colors.black),
                        right: BorderSide(width: 4.0, color: Colors.black),
                        bottom: BorderSide(width: 4.0, color: Colors.black),
                      ),
                    ),
                    child: Material(
                      color: itemList[index].bgColor,
                      child: ListTile(
                        onTap: (){
                        },
                        enabled: false,
                        title: Container(
                          child: Row(
                            children: [
                              //checkbox for each item
                              Container(
                                margin: EdgeInsets.only(bottom: 10, left: 5),
                                child: Transform.scale(
                                  scale: 4.4,
                                  child: Checkbox(
                                    checkColor: Colors.white,
                                    activeColor: itemList[index].bgColor[900],
                                    value: itemList[index].completed,
                                    onChanged:  (bool? value){
                                      setState(() {
                                        itemList[index].completed = value!;
                                        setToCurrentDateAndTime(itemList[index].completed, index);
                                        setAlarmAndCheckmarkReset();
                                        });
                                    },
                                  ),
                                ),
                              ),
                              //labels for each item
                              Container(
                                margin: EdgeInsets.only(left: 25),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    //item name label
                                    //stack is for the black outline around the white text
                                    Stack(
                                      children: [
                                        Text(
                                        itemList[index].name,
                                        style: TextStyle(
                                          fontSize: 33,
                                          fontWeight: FontWeight.bold,
                                          foreground: Paint()
                                            ..style = PaintingStyle.stroke
                                            ..strokeWidth = 6
                                            ..color = Colors.black,
                                          ),
                                        ),
                                        Text(
                                          itemList[index].name,
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 33,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                    //last completed label
                                    Stack(
                                      children: [
                                        //outline
                                        Text(
                                        'Last Completed:',
                                        style: TextStyle(
                                          fontSize: 19,
                                          foreground: Paint()
                                            ..style = PaintingStyle.stroke
                                            ..strokeWidth = 4
                                            ..color = Colors.black,
                                        ),
                                      ),
                                        //fill
                                        Text(
                                          'Last Completed:',
                                          style: TextStyle(
                                            fontSize: 19,
                                            color: Colors.white,
                                            ),
                                          ),
                                            ]
                                    ),
                                        //date and time item was last completed labels
                                        Stack(
                                          children: [
                                            //outline
                                            Text(
                                              displayDateAndTime(index),
                                              style: TextStyle(
                                              fontSize: 23,
                                              foreground: Paint()
                                                ..style = PaintingStyle.stroke
                                                ..strokeWidth = 4
                                                ..color = Colors.black,
                                            ),
                                          ),
                                            //fill
                                            Text(
                                              displayDateAndTime(index),
                                              style: TextStyle(
                                                fontSize: 23,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ]
                                        ),
                                  ],
                                ),
                              ),
                              Spacer(),
                              //edit button and alarm icon
                              Container(
                                child: Column(
                                  children: [
                                    //edit button
                                    FloatingActionButton.small(
                                        onPressed: () async {
                                          final value = await Navigator.push(
                                            context,
                                            MaterialPageRoute(builder: (context) => EditInfoPage(),
                                              settings: RouteSettings(
                                                arguments: itemList[index],
                                              ),
                                            ),
                                          );
                                            //if item returns marked for deletion, it is cancelled and deleted
                                            if(itemList[index].toBeDeleted == true){
                                              itemList.removeAt(index);
                                            }
                                          _saveList();
                                          setAlarmAndCheckmarkReset();
                                          setState((){
                                          });
                                        },
                                      child: Icon(Icons.edit),
                                      foregroundColor: Colors.white,
                                      backgroundColor: itemList[index].bgColor[800],
                                      tooltip: 'edit',
                                      shape: ContinuousRectangleBorder(),
                                    ),
                                    //alarm icon
                                    Container(
                                      margin: EdgeInsets.only(top: 5),
                                      child: Icon(
                                          Icons.alarm,
                                        size: 33,
                                        color: itemList[index].alarmColor,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
            )
               : Container(
                 margin: EdgeInsets.only(left: 10, right: 7),
                 child: Column(
                 children: [
                   Text(
                    'No Items',
                  style: TextStyle(
                      fontSize: 50,
                    fontWeight: FontWeight.bold,
                    ),
                     textAlign: TextAlign.center,
                  ),
                   Text(
                     '- Tap "+ New" to add an item',
                     style: TextStyle(
                       fontSize: 30,
                     ),
                     textAlign: TextAlign.center,
                   ),
                   Text(
                     '- Tap "Load" (top middle) to load saved list',
                     style: TextStyle(
                       fontSize: 30,
                     ),
                   ),
                   Text(
                     '- Tap "Save" (top right) to save current/edited list',
                     style: TextStyle(
                       fontSize: 30,
                     ),
                   ),

                   Text(
                     '- Tap "X" (top left) to permanently clear all list save data',
                     style: TextStyle(
                       fontSize: 30,
                     ),
                   ),
                   Text(
                     '- Starting "Last Completed" date is 99/99/9999; this will update when item is checked off',
                     style: TextStyle(
                       fontSize: 30,
                     ),
                   ),
                 ]
              ),
               ),
          ],
        ),
      ),
      //add new item
      floatingActionButton:FloatingActionButton.extended(
        onPressed: () async {
          //add new item w/ default settings
          itemList.add(ChecklistItem('', false, false, false, false, false, 'Grey', Colors.grey, Colors.transparent, false, '', 1, 'Days', 0, 0, 99, 99, 9999, -1, -1, -1, -1, -1));
          //set that this is a new item; itemList.length - 1 is the newest item in the list
          itemList[itemList.length - 1].isNew = true;
          final value = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => EditInfoPage(),
              settings: RouteSettings(
                arguments: itemList[itemList.length - 1],
              ),
            ),
          );
            //if item returns as still new, it is cancelled and deleted
            if(itemList[itemList.length - 1].isNew == true || itemList[itemList.length - 1].toBeDeleted == true){
              itemList.removeAt(itemList.length - 1);
            }
          setState((){
            _saveList();
          });
        },
        icon: Icon(Icons.add),
        backgroundColor: Colors.indigo[400],
        label: Text(
          'New',
          style: TextStyle(
            fontSize: 30,
          ),
        ),
      ),
    );
  }
}