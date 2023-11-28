import 'dart:math';

class Grid {
  late List<List<int>> grid;

  Grid() {
    grid = [
      [1, 0, 0, 0, 0, 0, 0, 0, 0],
      [0, 2, 0, 0, 0, 0, 0, 0, 0],
      [0, 0, 3, 0, 0, 0, 0, 0, 0],
      [0, 0, 0, 4, 0, 0, 0, 0, 0],
      [0, 0, 0, 0, 5, 0, 0, 0, 0],
      [0, 0, 0, 0, 0, 6, 0, 0, 0],
      [0, 0, 0, 0, 0, 0, 7, 0, 0],
      [0, 0, 0, 0, 0, 0, 0, 8, 0],
      [0, 0, 0, 0, 0, 0, 0, 0, 9],
    ];
  }

  @override
  toString() {
    return "Grid";
  }

  void printGrid() {
    for (int i = 0; i < grid.length; i++) {
      print(grid[i]);
    }
  }

  List<int> getValuesInRow(int rowNumber) {
    List<int> uVals = [];
    List<int> row = grid[rowNumber];
    for (int i = 0; i < row.length; i++) {
      int value = row[i];
      if (!uVals.contains(value)) {
        uVals.add(value);
      }
    }
    return uVals;
  }

  List<int> getValuesInCol(int colNumber) {
    List<int> uVals = [];
    for (int i = 0; i < grid.length; i++) {
      List<int> row = grid[i];
      int value = row[colNumber];
      if (!uVals.contains(value)) {
        uVals.add(value);
      }
    }
    return uVals;
  }

  List<int> getValuesInSegment(int locX, int locY) {
    Map<int, int> startFromMap = {0: 0, 1: 3, 2: 6};
    int rowsStartFrom = startFromMap[locY]!;
    int colsStartFrom = startFromMap[locX]!;
    List<List<int>> rows = grid.sublist(rowsStartFrom, rowsStartFrom + 3);

    for (int i = 0; i < rows.length; i++) {
      List<int> rowValues = rows[i].sublist(colsStartFrom, colsStartFrom + 3);
      rows[i] = rowValues;
    }
    print(rows);

    List<int> uVals = [];
    for (int a = 0; a < rows.length; a++) {
      List<int> row = rows[a];

      for (int b = 0; b < row.length; b++) {
        int value = row[b];
        if (!uVals.contains(value)) {
          uVals.add(value);
        }
      }
    }

    return uVals;
  }

  List<int> getBlockSoloutionSpace(int locX, int locY) {
    List<int> soloutionSpace = [1, 2, 3, 4, 5, 6, 7, 8, 9];

    Map<int, int> blockSegmentMap = {
      0: 0,
      1: 0,
      2: 0,
      3: 1,
      4: 1,
      5: 1,
      6: 2,
      7: 2,
      8: 2,
    };

    int segX = ((locX) / 3).floor();
    int segY = ((locY) / 3).floor();
    List<int> segmentValues = getValuesInSegment(segX, segY);
    List<int> rowValues = getValuesInRow(locX);
    List<int> colValues = getValuesInCol(locY);

    int currentValue = grid[locY][locX];
    if (currentValue != 0) {
      List<int> cv = [currentValue];
      return cv;
    }

    List<int> conflictingValues = [];
    conflictingValues.addAll(segmentValues);
    conflictingValues.addAll(rowValues);
    conflictingValues.addAll(colValues);

    for (int i = 0; i < conflictingValues.length; i++) {
      int value = conflictingValues[i];
      if (soloutionSpace.contains(value)) {
        soloutionSpace.remove(value);
      }
    }

    return soloutionSpace;
  }

  // END OF CLASS
}

void main(List<String> arguments) {
  Grid grid = Grid();
  grid.printGrid();
  print("Values in row 0 ${grid.getValuesInRow(0)}");
  print("Values in col 0 ${grid.getValuesInCol(0)}");
  print("Values in segment x=0, y=0 ${grid.getValuesInSegment(0, 0)}");

  print('Block Soloution Space ${grid.getBlockSoloutionSpace(2, 8)}');

  print('soloution space ${grid.getBlockSoloutionSpace(1, 0)}');
}
