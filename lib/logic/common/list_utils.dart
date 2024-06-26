
class IndexIterator<T> implements Iterator<T> {
  final List<T> _list;
  final int _startIndex;
  int _currentIndex = -1;

  IndexIterator(this._list, this._startIndex) {
    _currentIndex;
  }

  int _getIndex() {
    var index = (_startIndex+_currentIndex) % _list.length;
    while(index < 0) {
      index+=_list.length;
    }
    return index;
  }

  @override
  bool moveNext() {
    _currentIndex++;
    return _currentIndex < _list.length;
  }

  @override
  T get current => _list[_getIndex()];
}

class IndexIterable<T> extends Iterable<T> {
  final List<T> _list;
  final int _startIndex;

  IndexIterable(this._list, this._startIndex);

  @override
  Iterator<T> get iterator => IndexIterator<T>(_list, _startIndex);
}