class Clock {
  const Clock();
  Stream<int> tick({required int ticks}) {
    return Stream.periodic(const Duration(seconds: 1), (x) => ticks + x + 1);
  }

  List<Stream<int>> tickList({required List<int> ticksList}) {
    List<Stream<int>> tempList = [];
    for (var i in ticksList) {
      tempList.add(Stream.periodic(const Duration(seconds: 1), (x) => i + x + 1));
    }
    return tempList;
  }
}
