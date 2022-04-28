import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firestorex/firestorex.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

void main() async {
  test('createIndexes', () {
    expect([], ''.searchIndex());
    expect([], '       '.searchIndex());
    expect([' '], ' ---------'.searchIndex(separator: '-'));
    expect(['test'], 'test'.searchIndex(minLen: 5));
    expect(['tes', 'test'], 'test'.searchIndex(minLen: 3).toList());
    expect(
      ['exam', 'examp', 'exampl', 'example', 'valu', 'value'],
      ' example Value '.searchIndex().toList(),
    );
    expect(
      ['a', 'quick', 'brown'],
      ' a  quick   brown'.searchIndex(minLen: 5).toList(),
    );
    expect(
      ['foo', 'bar', 'baz'],
      'foo,,,,bar,baz'.searchIndex(minLen: 6, separator: ',').toList(),
    );
  });

  test('cachedCollection', () async {
    final entity = Entity(FireFlags.serverDateTime);
    final cacheHandler = CacheHandlerMock();
    DateTime? timestamp;
    final collection = FakeFirebaseFirestore().cachedCollection<Entity>(
      path: 'test',
      fromJson: (json) => Entity.fromJson(json),
      toJson: (val) => val.toJson(),
      cacheHandler: (id, val, ts) {
        timestamp = ts;
        return cacheHandler(id, val, ts);
      },
    );
    final doc = collection.doc();
    await doc.get();
    verifyNever(cacheHandler(doc.id, any, any));
    await doc.set(entity);
    verify(cacheHandler(doc.id, any, any)).called(1); // irrelevant, fake
    Entity? data = await doc.get().then((value) => value.data());
    verify(cacheHandler(doc.id, any, any)).called(1);
    expect(data!.timestamp, equals(timestamp));
  });
}

class Entity {
  /// for [CacheHandlerMock]
  final DateTime timestamp;

  Entity(this.timestamp);

  factory Entity.fromJson(Map<String, dynamic> json) {
    return Entity(timestampConv.fromJson(json['timestamp']));
  }

  Map<String, Object?> toJson() => {};
}

class CacheHandlerMock extends Mock {
  void call(String? id, Entity? value, DateTime? timestamp);
}
