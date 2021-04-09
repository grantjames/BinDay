import 'package:bin_day/models/Bin.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';
import 'package:path/path.dart';

class BinRepository {
  var _bins = <Bin>[
    // Bin(
    //     id: 'bin1',
    //     colour: Color.fromARGB(255, 46, 46, 46),
    //     name: 'Household Waste',
    //     firstCollectionDate: DateTime(2021, 3, 23),
    //     lastCollectionDate: null,
    //     frequency: 7
    // ),
    // Bin(
    //     id: 'bin2',
    //     colour: Color.fromARGB(255, 84, 67, 9),
    //     name: 'Garden Waste',
    //     firstCollectionDate: DateTime(2021, 3, 23),
    //     lastCollectionDate: DateTime(2021, 4, 10),
    //     frequency: 14
    // ),
    // Bin(
    //     id: 'bin3',
    //     colour: Color.fromARGB(255, 27, 75, 148),
    //     name: 'Recycling',
    //     firstCollectionDate: DateTime(2021, 3, 4),
    //     lastCollectionDate: null,
    //     frequency: 14
    // )
  ];

  Future<DatabaseClient> _getDb() async {
    return await databaseFactoryIo.openDatabase(join((await getApplicationDocumentsDirectory()).path, 'bins.db'));
  }

  Future addBin(Bin bin) async {
    var store = StoreRef.main();
    await store.add(await _getDb(), bin.toJson());
  }

  Future clearBins() async {
    var store = StoreRef.main();
    store.drop(await _getDb());
  }

  Future _getBins() async {
    var store = StoreRef.main();

    var bins = await store.find(await _getDb());
    _bins = bins.map((map) => Bin.fromJson(map.value)).toList();
  }

  Future<List<Bin>> getBinsCollectedTomorrow() async {
    await _getBins();

    print('***** ${_bins.length}');

    var tomorrow = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day).add(Duration(days: 1));
    return _bins.where((bin) => bin.isDueOn(tomorrow)).toList();
  }

  Future<List<Bin>> getBinsNotCollectedTomorrow() async {
    await _getBins();

    var tomorrow = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day).add(Duration(days: 1));
    var otherBins = _bins.where((bin) => !bin.isDueOn(tomorrow)).toList();

    otherBins.sort((a, b) {
      if (a.collectionsEnded()) {
        return 1;
      }

      if (b.collectionsEnded()) {
        return -1;
      }

      return a.getNextOrLastCollectionDate().compareTo(b.getNextOrLastCollectionDate());
    });

    return otherBins;
  }
}