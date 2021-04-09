import 'package:bin_day/models/Bin.dart';
import 'package:bin_day/Repositories/BinRepository.dart';
import 'package:bin_day/screens/AddBinScreen.dart';
import 'package:bin_day/widgets/BinWidget.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class WhatBinTodayScreen extends StatefulWidget {
  @override
  _WhatBinTodayScreenState createState() => _WhatBinTodayScreenState();
}

class _WhatBinTodayScreenState extends State<WhatBinTodayScreen> with WidgetsBindingObserver {
  final binRepo = BinRepository();

  List<Bin> _tomorrowBins;
  List<Bin> _otherBins;
  var _mainText = '';
  var _dateText = '';

  void updateUI() async {
    print('***** Updating UI');
    _tomorrowBins = await binRepo.getBinsCollectedTomorrow();
    _otherBins = await binRepo.getBinsNotCollectedTomorrow();

    setState(() {
      _mainText = '${_tomorrowBins.length} bins need to be put out tonight';

      if (_tomorrowBins.length == 1) {
        _mainText = _mainText.replaceAll("bins need", "bin needs");
      }

      if (_tomorrowBins.length == 0) {
        _mainText = 'There are no bins that need to be put out tonight!';
      }

      _dateText = DateFormat('EEEE d MMMM').format(DateTime.now());
    });
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addObserver(this);
    updateUI();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      updateUI();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color.fromARGB(255, 240, 240, 240),
        appBar: AppBar(
          title: Text('Bin Day Reminder'),
          // actions: <Widget>[
          //   IconButton(
          //     icon: Icon(Icons.settings),
          //     tooltip: 'Settings',
          //     onPressed: () {
          //       // handle the press
          //     },
          //   ),
          // ],
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () {
            Navigator.of(context).pushNamed(AddBinScreen.routeName).then((value) => updateUI());
          },
          tooltip: 'Add a bin',
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Container(
                padding: EdgeInsets.all(10),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      SizedBox(height: 20),
                      Text(
                        _dateText,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black38,
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        _mainText,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black54,
                        ),
                      ),
                      SizedBox(height: 10),
                      Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: _tomorrowBins.map((bin) =>
                              Dismissible(
                                key: UniqueKey(),
                                child: BinWidget(bin),
                                onDismissed: (direction) {
                                  // TODO: Delete the bin from the db
                                  _tomorrowBins.remove(bin);
                                  updateUI();
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content: Text('${bin.name} bin deleted')
                                      )
                                  );
                                },
                              )
                          ).toList()
                      ),
                      SizedBox(height: 20),
                      Visibility(
                        visible: _otherBins.length > 0,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              'Other bins',
                              style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black26
                              ),
                            ),
                            SizedBox(height: 10),
                            Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: _otherBins.map((bin) =>
                                    Dismissible(
                                      key: UniqueKey(),
                                      child: BinWidget(bin),
                                      onDismissed: (direction) {
                                        // TODO: Delete the bin from the db
                                        _otherBins.remove(bin);
                                        updateUI();
                                        ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(
                                                content: Text('${bin.name} bin deleted')
                                            )
                                        );
                                      },
                                    )
                                ).toList()
                            ),
                          ],
                        ),
                      )
                    ]
                )
            ),
          ),
        )
    );
  }
}