import 'package:checklist_tracker_wip/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'item_data.dart';

enum AlarmType { onCheckReset, custom, none }

class EditInfoPage extends StatefulWidget {
  const EditInfoPage({Key? key}) : super(key: key);

  @override
  State<EditInfoPage> createState() => _EditInfoPageState();
}

class _EditInfoPageState extends State<EditInfoPage> {

  String colorName = 'Grey';
  String frequencyName = 'Days';
  String initialTitle = '';
  String initialFrequencyNum = '1';
  String initialAlarmHours = '00';
  String initialAlarmMinutes = '00';
  String initialDescription = '';
  var colorDisplay = Colors.grey;
  bool alarmSet = false;
  bool alarmOnCheckReset = false;
  bool alarmCustom = false;
  AlarmType? _type = AlarmType.onCheckReset;
  bool alarmCustomInput = false;
  bool initialized = false;

  //displays chosen color in preview box and sets bg color of list item
  void setDisplayColor(String newColorName){
    switch(newColorName){
      case 'Grey': {colorDisplay = Colors.grey;}
      break;

      case 'Red': {colorDisplay = Colors.red;}
      break;

      case 'Orange': {colorDisplay = Colors.orange;}
      break;

      case 'Yellow': {colorDisplay = Colors.yellow;}
      break;

      case 'Green': {colorDisplay = Colors.green;}
      break;

      case 'Blue': {colorDisplay = Colors.blue;}
      break;

      case 'Purple': {colorDisplay = Colors.deepPurple;}
      break;

      default: {colorDisplay = Colors.grey;}
      break;
    }
  }

  //initializes the color of the item being edited to its current value
  void initializeDisplayColor(var displayColor){
    if(displayColor == Colors.grey){
      colorName = 'Grey';
    }
    else if(displayColor == Colors.red){
      colorName = 'Red';
    }
    else if(displayColor == Colors.orange){
      colorName = 'Orange';
    }
    else if(displayColor == Colors.yellow){
      colorName = 'Yellow';
    }
    else if(displayColor == Colors.green){
      colorName = 'Green';
    }
    else if(displayColor == Colors.blue){
      colorName = 'Blue';
    }
    else if(displayColor == Colors.deepPurple){
      colorName = 'Purple';
    }
    else{
      colorName = 'Grey';
    }
  }

  //sets alarm state between custom or on check mark reset
  void setAlarmState(AlarmType? type){
    if(type == AlarmType.custom){
      alarmCustomInput = true;
      alarmSet = true;
      alarmCustom = true;
      alarmOnCheckReset = false;
    }
    else if (type == AlarmType.onCheckReset){
      alarmCustomInput = false;
      alarmSet = true;
      alarmOnCheckReset = true;
      alarmCustom = false;
    }
    else{
      alarmCustomInput = false;
      alarmSet = false;
      alarmOnCheckReset = false;
      alarmCustom = false;
    }
  }

  bool checkInputValidity(){
    //check if the number inputs are numbers
    //return false if not
    for(int i = 0; i < initialFrequencyNum.length; i++){
        if(initialFrequencyNum.codeUnitAt(i) < 48 || initialFrequencyNum.codeUnitAt(i) > 57){
          return false;
        }
    }
    for(int i = 0; i < initialAlarmHours.length; i++){
      if(initialAlarmHours.codeUnitAt(i) < 48 || initialAlarmHours.codeUnitAt(i) > 57){
        return false;
      }
    }
    for(int i = 0; i < initialAlarmMinutes.length; i++){
      if(initialAlarmMinutes.codeUnitAt(i) < 48 || initialAlarmMinutes.codeUnitAt(i) > 57){
        return false;
      }
    }
    //check if clock values are <24 for hours and <60 for minutes
    if(int.parse(initialAlarmHours) > 23 || int.parse(initialAlarmHours) < 0){
      return false;
    }
    if(int.parse(initialAlarmMinutes) > 59 || int.parse(initialAlarmMinutes) < 0){
      return false;
    }
    return true;
  }

  static const routeName = '/extractArguments';

  @override
  Widget build(BuildContext context) {
    final item = ModalRoute.of(context)!.settings.arguments as ChecklistItem;
    //initialize options to autofill w/ current item's settings
    //initialized bool makes sure initialization only happens once
    if(initialized == false) {
      initialTitle = item.name;
      colorDisplay = item.bgColor;
      initializeDisplayColor(colorDisplay);
      frequencyName = item.frequencyType;
      initialFrequencyNum = item.frequencyNum.toString();
      //set saved type of alarm and saved alarm time
      //if no alarm is set, default to on check mark reset
      alarmSet = item.alarm;
      if(item.alarm == true) {
        if (item.alarmOnCheckmarkReset == true) {
          _type = AlarmType.onCheckReset;
        }
        else {
          _type = AlarmType.custom;
          //display values < 10 w/ a 0 before them
          if (item.alarmHours < 10) {
            initialAlarmHours = '0${item.alarmHours}';
          }
          else {
            initialAlarmHours = item.alarmHours.toString();
          }
          if (item.alarmMinutes < 10) {
            initialAlarmMinutes = '0${item.alarmMinutes}';
          }
          else {
            initialAlarmMinutes = item.alarmMinutes.toString();
          }
        }
      }
      else{
        _type = AlarmType.none;
      }
      initialDescription = item.description;
    }
    setAlarmState(_type);
    setState((){
      initialized = true;
    });
    return Scaffold(
      body: Container(
        margin: EdgeInsets.only(left: 10, right: 10),
        child: SingleChildScrollView(
          child: Column(
            children: [
              //title, cancel, save
              Container(
                margin: EdgeInsets.only(top: 25),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    //cancel
                    FloatingActionButton(
                      onPressed: (){
                        item.isNew = true; //tells other page this item should be cancelled/deleted
                        Navigator.pop(context);
                      },
                      child: Icon(Icons.arrow_back),
                      tooltip: 'Cancel',
                      backgroundColor: Colors.indigo[400],
                    ),
                    Spacer(),
                    //title
                    Text(
                      'Edit Info',
                      style: TextStyle(
                        fontSize: 45,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Spacer(),
                    //save
                    FloatingActionButton(
                      onPressed: (){
                        bool validity = checkInputValidity();
                        if(validity == true){
                          //if no errors are found, save settings to item data
                          setAlarmState(_type);
                          item.isNew = false; //tells other page this item should be saved
                          //save input data to item
                          item.name = initialTitle;
                          item.bgColor = colorDisplay; //color displayed saved as var
                          item.color = colorName; //color name saved as string
                          item.frequencyNum = int.parse(initialFrequencyNum);
                          item.frequencyType = frequencyName;
                          item.alarm = alarmSet;
                          item.alarmOnCheckmarkReset = alarmOnCheckReset;
                          item.alarmCustom = alarmCustom;
                          item.alarmHours = int.parse(initialAlarmHours);
                          item.alarmMinutes = int.parse(initialAlarmMinutes);
                          item.description = initialDescription;
                          //and return to main screen
                          Navigator.pop(context);
                        }
                        else{
                          //if error is found, show error dialog box
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text('Input Error',
                                style: TextStyle(
                                  fontSize: 30,
                                  ),
                                ),
                                content: Text(
                                    'Error in an input field, please revise try again',
                                style: TextStyle(
                                  fontSize: 25,
                                  ),
                                ),
                                actions: [
                                  TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: Text('OK',
                                      style: TextStyle(
                                        fontSize: 20,
                                        ),
                                      ),
                                  ),
                                ],
                              );
                            }
                          );
                        }
                      },
                      child: Icon(Icons.check),
                      tooltip: 'Save & Exit',
                      backgroundColor: Colors.green[800],
                    ),
                  ],
                ),
              ),
              //line below title
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.only(top: 5, bottom: 20),
                      alignment: Alignment.center,
                      color: Colors.grey,
                      height: 2,
                    ),
                  ),
                ],
              ),
              //label title row
              Container(
                height: 50,
                margin: EdgeInsets.only(bottom: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    //label title text
                    Text(
                      'Label Title: ',
                      style: TextStyle(
                        fontSize: 25,
                      ),
                    ),
                    //label title input field
                    Expanded(
                      child: Container(
                        decoration: const BoxDecoration(
                          border: Border(
                            top: BorderSide(width: 2.0, color: Colors.black),
                            left: BorderSide(width: 2.0, color: Colors.black),
                            right: BorderSide(width: 2.0, color: Colors.black),
                            bottom: BorderSide(width: 2.0, color: Colors.black),
                          ),
                        ),
                        alignment: Alignment.center,
                        child: Container(
                          margin: EdgeInsets.only(left: 5),
                          child: TextField(
                            controller: TextEditingController(
                              text: initialTitle
                            ),
                            textAlignVertical: TextAlignVertical.top,
                            obscureText: false,
                            maxLength: 10,
                            maxLengthEnforcement: MaxLengthEnforcement.enforced,
                            style: TextStyle(
                              fontSize: 25,
                            ),
                            decoration: null,
                            onSubmitted: (String savedString){
                              initialized = true;
                              initialTitle = savedString;
                              },
                            ),
                        ),
                      ),
                      ),
                  ],
                ),
              ),
              //label color row
              Container(
                margin: EdgeInsets.only(bottom: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    //label color text
                    Text(
                      'Label Color: ',
                      style: TextStyle(
                        fontSize: 25,
                      ),
                    ),
                    //label color dropdown
                    Container(
                      width: 120,
                      height: 45,
                        decoration: const BoxDecoration(
                          border: Border(
                            top: BorderSide(width: 2.0, color: Colors.black),
                            left: BorderSide(width: 2.0, color: Colors.black),
                            right: BorderSide(width: 2.0, color: Colors.black),
                            bottom: BorderSide(width: 2.0, color: Colors.black),
                          ),
                        ),
                        child: Container(
                          margin: EdgeInsets.only(left: 5),
                          child: DropdownButton<String>(
                            value: colorName,
                            icon: Icon(Icons.arrow_drop_down),
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 25,
                            ),
                            underline: Container(
                              color: Colors.transparent,
                            ),
                            iconSize: 30,
                            onChanged: (String? newColorName){
                              setState((){
                                initialized = true;
                                colorName = newColorName!;
                                setDisplayColor(newColorName);
                              });
                            },
                            items:
                              <String>['Grey', 'Red', 'Orange', 'Yellow', 'Green', 'Blue', 'Purple']
                              .map<DropdownMenuItem<String>>((String colorName){
                                return DropdownMenuItem<String>(
                                value: colorName,
                                child: Text(colorName),
                                );
                              }).toList(),
                          ),
                        ),
                      ),
                    //label color preview
                    Expanded(
                      child: Stack(
                        children: [
                          Container(
                            margin: EdgeInsets.only(left: 10),
                            height: 45,
                            color: colorDisplay,
                          ),
                          Container(
                          margin: EdgeInsets.only(left: 10),
                          height: 45,
                          decoration: const BoxDecoration(
                            border: Border(
                              top: BorderSide(width: 2.0, color: Colors.black),
                              left: BorderSide(width: 2.0, color: Colors.black),
                              right: BorderSide(width: 2.0, color: Colors.black),
                              bottom: BorderSide(width: 2.0, color: Colors.black),
                            ),
                          ),
                        ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              //reset check mark label
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                      'Reset check mark every:',
                    style: TextStyle(
                      fontSize: 25,
                    ),
                  ),
                ],
              ),
              //reset check mark input and dropdown
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  //number input
                    Container(
                      width: 70,
                      height: 50,
                      margin: EdgeInsets.only(top: 10, left: 90),
                      decoration: const BoxDecoration(
                        border: Border(
                          top: BorderSide(width: 2.0, color: Colors.black),
                          left: BorderSide(width: 2.0, color: Colors.black),
                          right: BorderSide(width: 2.0, color: Colors.black),
                          bottom: BorderSide(width: 2.0, color: Colors.black),
                        ),
                      ),
                      child: Container(
                        margin: EdgeInsets.only(top: 9),
                        child: TextField(
                            controller: TextEditingController(
                              text: initialFrequencyNum
                            ),
                            textAlignVertical: TextAlignVertical.top,
                            textAlign: TextAlign.end,
                            maxLength: 2,
                            maxLengthEnforcement: MaxLengthEnforcement.enforced,
                            obscureText: false,
                            keyboardType: TextInputType.number,
                            style: TextStyle(
                              fontSize: 25,
                            ),
                            decoration: null,
                            onSubmitted: (String newFrequencyNum){
                            initialized = true;
                            initialFrequencyNum = newFrequencyNum;
                          },
                        ),
                      ),
                    ),
                  //dropdown
                  Container(
                    margin: EdgeInsets.only(top: 10, left: 5),
                    width: 130,
                    height: 50,
                    decoration: const BoxDecoration(
                      border: Border(
                        top: BorderSide(width: 2.0, color: Colors.black),
                        left: BorderSide(width: 2.0, color: Colors.black),
                        right: BorderSide(width: 2.0, color: Colors.black),
                        bottom: BorderSide(width: 2.0, color: Colors.black),
                      ),
                    ),
                    child: Container(
                      margin: EdgeInsets.only(left: 5),
                      child: DropdownButton<String>(
                        value: frequencyName,
                        icon: Icon(Icons.arrow_drop_down),
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 25,
                        ),
                        underline: Container(
                          color: Colors.transparent,
                        ),
                        iconSize: 30,
                        onChanged: (String? newFrequencyName){
                          setState((){
                            initialized = true;
                            frequencyName = newFrequencyName!;
                          });
                        },
                        items:
                        <String>['Hours', 'Days', 'Weeks', 'Months']
                            .map<DropdownMenuItem<String>>((String frequencyName){
                          return DropdownMenuItem<String>(
                            value: frequencyName,
                            child: Text(frequencyName),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                    ],
                  ),
              //set alarm label
              Container(
                margin: EdgeInsets.only(top: 10),
                child: Row(
                  children: [
                    //label
                    Text(
                      'Set alarm (optional):',
                      style: TextStyle(
                        fontSize: 25,
                      ),
                    ),
                  ],
                ),
              ),
              //set alarm type radio buttons
              Column(
                children: [
                  //on check mark reset
                  RadioListTile<AlarmType>(
                    title: const Text(
                      'On check mark reset',
                      style: TextStyle(
                        fontSize: 25,
                      ),
                    ),
                      value: AlarmType.onCheckReset,
                      groupValue: _type,
                      toggleable: true,
                      onChanged: (AlarmType? value){
                        setState((){
                          initialized = true;
                          _type = value;
                          setAlarmState(_type);
                        });
                      },
                  ),
                  //custom
                  RadioListTile<AlarmType>(
                    title: Text(
                      'Custom alarm time:',
                      style: TextStyle(
                        fontSize: 25,
                      ),
                    ),
                    value: AlarmType.custom,
                    groupValue: _type,
                    toggleable: true,
                    onChanged: (AlarmType? value) {
                      setState((){
                        initialized = true;
                        _type = value;
                        setAlarmState(_type);
                      });
                    },
                  ),
                ],
              ),
              //custom alarm time input row
              Container(
                margin: EdgeInsets.only(left: 30, right: 30),
                child: Row(
                  children: [
                    //hour input box
                    Expanded(
                      flex: 45,
                        child: Container(
                          height: 55,
                          decoration: const BoxDecoration(
                            border: Border(
                              top: BorderSide(width: 2.0, color: Colors.black),
                              left: BorderSide(width: 2.0, color: Colors.black),
                              right: BorderSide(width: 2.0, color: Colors.black),
                              bottom: BorderSide(width: 2.0, color: Colors.black),
                            ),
                          ),
                          //hours
                          child: Container(
                            margin: EdgeInsets.only(top: 20, right: 5),
                            child: TextField(
                              controller: TextEditingController(
                                  text: initialAlarmHours
                              ),
                              textAlign: TextAlign.end,
                              textAlignVertical: TextAlignVertical.bottom,
                              obscureText: false,
                              maxLength: 2,
                              maxLengthEnforcement: MaxLengthEnforcement.enforced,
                              enabled: alarmCustomInput,
                              keyboardType: TextInputType.number,
                              style: TextStyle(
                                fontSize: 30,
                              ),
                              decoration: InputDecoration(
                                hintText: '00-23',
                                counterText: '',
                              ),
                              onChanged: (String newAlarmHours){
                                  initialized = true;
                                  initialAlarmHours = newAlarmHours;
                              },
                            ),
                          ),
                        )
                    ),
                    //: label
                    Expanded(
                      flex: 10,
                        child: Text(
                            ':',
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                    ),
                    //minutes input box
                    Expanded(
                      flex: 45,
                        child: Container(
                          height: 55,
                          decoration: const BoxDecoration(
                            border: Border(
                              top: BorderSide(width: 2.0, color: Colors.black),
                              left: BorderSide(width: 2.0, color: Colors.black),
                              right: BorderSide(width: 2.0, color: Colors.black),
                              bottom: BorderSide(width: 2.0, color: Colors.black),
                            ),
                          ),
                          child: Container(
                            margin: EdgeInsets.only(left: 5, top: 20),
                            child: TextField(
                              controller: TextEditingController(
                                  text: initialAlarmMinutes
                              ),
                              textAlignVertical: TextAlignVertical.bottom,
                              obscureText: false,
                              maxLength: 2,
                              maxLengthEnforcement: MaxLengthEnforcement.enforced,
                              enabled: alarmCustomInput,
                              keyboardType: TextInputType.number,
                              style: TextStyle(
                                fontSize: 30,
                              ),
                              decoration: InputDecoration(
                                hintText: '00-59',
                                counterText: '',
                              ),
                              onChanged: (String newAlarmMinutes){
                                  initialized = true;
                                  initialAlarmMinutes = newAlarmMinutes;
                              },
                            ),
                          ),
                        ),
                    ),
                  ],
                ),
              ),
              //item description label
              Container(
                margin: EdgeInsets.only(top: 10, bottom: 5),
                child: Row(
                  children: [
                    Text(
                      'Item Description:',
                      style: TextStyle(
                        fontSize: 25,
                      ),
                    ),
                  ],
                ),
              ),
              //item description text field
              Container(
                margin: EdgeInsets.only(bottom: 15),
                height: 100,
                decoration: const BoxDecoration(
                  border: Border(
                    top: BorderSide(width: 2.0, color: Colors.black),
                    left: BorderSide(width: 2.0, color: Colors.black),
                    right: BorderSide(width: 2.0, color: Colors.black),
                    bottom: BorderSide(width: 2.0, color: Colors.black),
                  ),
                ),
                child: Container(
                  margin: EdgeInsets.only(left: 5, right: 5),
                  child: TextField(
                    controller: TextEditingController(
                        text: initialDescription
                    ),
                    textAlignVertical: TextAlignVertical.bottom,
                    obscureText: false,
                    maxLines: 2,
                    maxLength: 90,
                    maxLengthEnforcement: MaxLengthEnforcement.enforced,
                    style: TextStyle(
                      fontSize: 25,
                    ),
                    decoration: null,
                    onChanged: (String newDescription){
                        initialized = true;
                        initialDescription = newDescription;
                    },
                  ),
                ),
              ),
              //delete button
              FloatingActionButton.extended(
                      onPressed: (){
                        item.toBeDeleted = true; //tells other page this item should be deleted
                        Navigator.pop(context);
                      },
                    icon: Icon(Icons.delete),
                backgroundColor: Colors.red,
                    label: Text(
                        'Delete Item',
                      style: TextStyle(
                        fontSize: 25,
                      ),
                    ),
                  ),
            ],
          ),
        ),
      ),
    );
  }
}