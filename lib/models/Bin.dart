import 'package:flutter/material.dart';

class Bin {
  String id;
  Color colour;
  String name;
  DateTime firstCollectionDate;
  DateTime lastCollectionDate; // inclusive
  int frequency; // days

  Bin({this.id, this.colour, this.name, this.firstCollectionDate, this.lastCollectionDate, this.frequency});

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'colour' : colour.toString().replaceAll('Color(', '').replaceAll(')', ''),
      'name': name,
      'firstCollectionDate': firstCollectionDate.toString(),
      'lastCollectionDate': lastCollectionDate.toString(),
      'frequency': frequency
    };
  }

  factory Bin.fromJson(Map<String, dynamic> map) {
    return Bin(
      id: map['id'],
      colour: Color(int.parse(map['colour'])),
      name: map['name'],
      firstCollectionDate: DateTime.parse(map['firstCollectionDate']),
      lastCollectionDate: map['lastCollectionDate'] == 'null' ? null : DateTime.parse(map['lastCollectionDate']),
      frequency: map['frequency'],
    );
  }

  bool isDueOn(DateTime day) => getNextOrLastCollectionDate().isAtSameMomentAs(DateTime(day.year, day.month, day.day));

  DateTime getNextOrLastCollectionDate([DateTime date]) {
    if (date == null) {
      date = DateTime.now();
    }

    // set the compare date to midnight
    date = DateTime(date.year, date.month, date.day);

    // If the collections haven't started yet, return the start date
    if (date.compareTo(firstCollectionDate) < 0) {
      return firstCollectionDate;
    }

    // If today is the last collection, or the last collection date is in the past, return the end date
    if (lastCollectionDate != null && lastCollectionDate.compareTo(date) < 1) {
      return lastCollectionDate;
    }

    // Add on an hour to the date passed to difference() so that it counts the extra day
    var difference = firstCollectionDate.difference(date.add(Duration(hours: 1))).inDays.abs();
    var daysOut = difference % frequency;

    // This makes it return today if the next collection is today
    if (daysOut == 0) {
      daysOut = frequency;
    }

    var nextCollection = date.add(Duration(days: frequency - daysOut));

    // If the next calculated collection is after the last collection date, set it to the last collection
    if (lastCollectionDate != null) {
      while (nextCollection.isAfter(lastCollectionDate)) {
        nextCollection = nextCollection.subtract(Duration(days: frequency));
      }
    }

    return nextCollection;
  }

  bool collectionsEnded() {
    if (lastCollectionDate == null) {
      return false;
    }

    var today = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day).add(Duration(days: 1));
    return getNextOrLastCollectionDate().compareTo(today) == -1;
  }
}