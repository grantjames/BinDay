import 'package:flutter_test/flutter_test.dart';
import 'package:bin_day/models/Bin.dart';

void main() {
  test('for a never-ending collection the next collection date is correctly calculated', () {
    final bin = Bin(
        firstCollectionDate: DateTime(2021, 3, 1),
        lastCollectionDate: null,
        frequency: 7
    );

    var today = DateTime(2021, 3, 10);

    expect(bin.getNextOrLastCollectionDate(today), DateTime(2021, 3, 15));
  });

  test('next collection date calculated if today', () {
    final bin = Bin(
        firstCollectionDate: DateTime(2021, 3, 1),
        lastCollectionDate: null,
        frequency: 7
    );

    var today = DateTime(2021, 3, 15);

    expect(bin.getNextOrLastCollectionDate(today), DateTime(2021, 3, 15));
  });

  test('next collection for a future start date', () {
    final bin = Bin(
        firstCollectionDate: DateTime(2021, 3, 8),
        lastCollectionDate: null,
        frequency: 7
    );

    var today = DateTime(2021, 3, 6);

    expect(bin.getNextOrLastCollectionDate(today), DateTime(2021, 3, 8));
  });

  test('the next collection date is correctly calculated for a collection that expires in the future', () {
    final bin = Bin(
        firstCollectionDate: DateTime(2021, 3, 1),
        lastCollectionDate: DateTime(2021, 3, 15),
        frequency: 7
    );

    var today = DateTime(2021, 3, 7);

    expect(bin.getNextOrLastCollectionDate(today), DateTime(2021, 3, 8));
  });

  test('the last collection date is correctly calculated for a collection that expired in the past', () {
    final bin = Bin(
        firstCollectionDate: DateTime(2021, 3, 1),
        lastCollectionDate: DateTime(2021, 3, 8),
        frequency: 7
    );

    var today = DateTime(2021, 3, 9);

    expect(bin.getNextOrLastCollectionDate(today), DateTime(2021, 3, 8));
  });

  test('the last collection date is correctly calculated for a collection that expired today', () {
    final bin = Bin(
        firstCollectionDate: DateTime(2021, 3, 1),
        lastCollectionDate: DateTime(2021, 3, 8),
        frequency: 7
    );

    var today = DateTime(2021, 3, 8);

    expect(bin.getNextOrLastCollectionDate(today), DateTime(2021, 3, 8));
  });

  test('the last collection date is correctly calculated for a collection that expires tomorrow', () {
    final bin = Bin(
        firstCollectionDate: DateTime(2021, 3, 23),
        lastCollectionDate: DateTime(2021, 4, 6),
        frequency: 14
    );

    var today = DateTime(2021, 4, 5);

    expect(bin.getNextOrLastCollectionDate(today), DateTime(2021, 4, 6));
  });
}