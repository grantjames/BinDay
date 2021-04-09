import 'package:flutter/material.dart';
import 'package:bin_day/models/Bin.dart';
import 'package:intl/intl.dart';

class BinWidget extends StatelessWidget {
  final Bin _bin;

  BinWidget(this._bin);

  Color getLighterBinColour() {
    return Color.fromARGB(150, _bin.colour.red, _bin.colour.green, _bin.colour.blue);
  }

  @override
  Widget build(BuildContext context) {
    String subText;

    if (_bin.collectionsEnded()) {
      subText = 'Last collection was on ${DateFormat('EEEE d MMMM').format(_bin.getNextOrLastCollectionDate())}';
    }
    else {
      subText = 'Next collection due ${DateFormat('EEEE d MMMM').format(_bin.getNextOrLastCollectionDate())}';
    }

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        color: _bin.isDueOn(DateTime.now().add(Duration(days: 1))) ? _bin.colour : getLighterBinColour(),
      ),
      margin: EdgeInsets.only(
        bottom: 10
      ),
      padding: EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                _bin.name,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Visibility(
                visible: _bin.collectionsEnded(),
                  child: Chip(
                    label: Text('Ended'),
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  )
              )
            ]
          ),
          SizedBox(height: 6),
          Text(
              subText,
              style: TextStyle(
                  color: Colors.white70,
                  fontSize: 18,
                  fontWeight: FontWeight.normal
              )
          ),
          Visibility(
            visible: !_bin.collectionsEnded(),
            child: Column(
              children: <Widget>[
                SizedBox(height: 6),
                Text(
                  'Collected every ${_bin.frequency} days',
                  style: TextStyle(
                      color: Colors.white70,
                      fontSize: 18,
                      fontWeight: FontWeight.normal
                  )
                ),
              ]
            ),
          ),
        ]
      ),
    );
  }
}
