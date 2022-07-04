import 'package:flutter/material.dart';

class ChecklistItem {
  String name = '';
  String color = 'Grey';
  var bgColor = Colors.grey;
  var alarmColor = Colors.grey[500];
  String description = '';
  String frequencyType = 'Days';
  bool completed = false;
  bool alarm = false;
  bool alarmOnCheckmarkReset = false;
  bool alarmCustom = false;
  bool isNew = false;
  bool toBeDeleted = false;
  int frequencyNum = 1;
  int checkedMonth = 1;
  int checkedDay = 1;
  int checkedYear = 2022;
  int checkedHour = 0;
  int checkedMinute = 0;
  int alarmDay = -1;
  int alarmMonth = -1;
  int alarmYear = -1;
  int alarmHours = -1;
  int alarmMinutes = -1;

  ChecklistItem(this.name, this.alarm, this.alarmCustom, this.alarmOnCheckmarkReset, this.isNew, this.toBeDeleted,
      this.color, this.bgColor, this.alarmColor, this.completed, this.description, this.frequencyNum, this.frequencyType, this.checkedHour,
      this.checkedMinute, this.checkedDay, this.checkedMonth, this.checkedYear, this.alarmDay, this.alarmMonth, this.alarmYear, this.alarmHours, this.alarmMinutes);
}