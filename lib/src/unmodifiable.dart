part of firestorex;

/// As of [freezed] 2.0, collections are unmodifiable by default.
/// To work with collections effectively, you can use this extensions methods.
/// Methods with [copy] prefix means, it returns copy of itself(just like copyWith).
///
/// Using Unmodifiable collections is recommended for non-small projects.
/// Beware your application may suffer skipped frames with large data sets,
/// if so use mutable collections or span new [Isolate].
///
/// Every unmodifiable collection operation starts with [copy] prefix

extension MapX<K, V> on Map<K, V> {
  Map<K, V> copyRemove(K id) {
    return {
      for (var k in keys)
        if (k != id) k: this[k]!
    };
  }

  Map<K, V> copySet(K k, V v) => {...this, k: v};

  Map<K, V> copyUpdate(
    K key,
    V Function(V value) update, {
    V Function()? ifAbsent,
  }) {
    final value = this[key];
    final V newValue;
    if (value != null) {
      newValue = update(value);
    } else {
      if (ifAbsent == null) {
        throw ArgumentError('$key not found in map (tip: provide ifAbsent)');
      }
      newValue = ifAbsent.call();
    }
    return {...this, key: newValue};
  }

  Map<K, V> copySetBatch(Iterable<MapEntry<K, V>> entries) {
    return {...this, for (var e in entries) e.key: e.value};
  }

  Map<K, V> copyWhere(bool Function(K key, V value) test) {
    return <K, V>{
      for (var k in keys)
        if (test(k, this[k] as V)) k: this[k] as V
    };
  }
}

extension ListX<E> on List<E> {
  List<E> copyAdd(E e) => [...this, e];

  List<E> copyRemoveAt(int index) {
    return [
      for (int i = 0; i < length; i++)
        if (i != index) elementAt(i)
    ];
  }

  List<E> copyUpdateAt(int index, E e) {
    return [
      for (int i = 0; i < length; i++)
        if (i == index) e else elementAt(i)
    ];
  }
}

extension SetX<E> on Set<E> {
  Set<E> copyAdd(E arg) {
    return <E>{...this, arg};
  }

  Set<E> copyRemove(E arg) {
    return {
      for (var e in this)
        if (e != arg) e
    };
  }
}
