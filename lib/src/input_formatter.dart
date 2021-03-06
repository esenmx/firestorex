part of firestorex;

/// TODO doc
class FirestoreSearchInputFormatter extends TextInputFormatter {
  FirestoreSearchInputFormatter({
    this.separator = ' ',
    this.length = kFirestoreEqualityLimit ~/ 2,
  });

  final String separator;
  final int length;

  @override
  TextEditingValue formatEditUpdate(oldValue, newValue) {
    final newText = newValue.text;
    if (newText.startsWith(separator)) {
      return oldValue;
    }
    if (newText.endsWith('$separator$separator')) {
      return oldValue;
    }
    if (newText.endsWith(separator)) {
      if (newText._warmup(separator).length == length) {
        return oldValue;
      }
    }
    return newValue;
  }
}
