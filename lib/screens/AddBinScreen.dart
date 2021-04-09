import 'package:bin_day/Repositories/BinRepository.dart';
import 'package:bin_day/models/Bin.dart';
import 'package:flutter/material.dart';

class AddBinScreen extends StatefulWidget {
  static String routeName = 'add_bin';

  @override
  _AddBinScreenScreenState createState() => _AddBinScreenScreenState();
}

class _AddBinScreenScreenState extends State<AddBinScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          ElevatedButton(
            child: Text('Create Bin'),
            onPressed: () async {
              // Create a bin
              var repo = BinRepository();
              var bin = Bin(
                  name: 'Test Bin',
                  frequency: 7,
                  colour: Color.fromARGB(255, 46, 46, 46),
                  firstCollectionDate: DateTime(2021, 3, 23),
                  lastCollectionDate: null
              );
              var key = await repo.addBin(bin);
              bin.id = key;

              showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                        title: Text('Bin created')
                    );
                  }
              );
            },
          ),
          ElevatedButton(
            child: Text('Clear Bins'),
            onPressed: () async {
              var repo = BinRepository();
              await repo.clearBins();
              showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                        title: Text('Bins cleared')
                    );
                  }
              );
            },
          )
        ],
      ),
    );
  }
}