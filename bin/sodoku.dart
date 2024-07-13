import "dart:io";

class Grid {
  late List<List<int>> grid;
  late List<List<Map<int, int>>> locationsMap;
  late Map<int, int> blockSegmentMap;

  Grid() {
    grid = [
      [4, 0, 9,  1, 0, 5,  0, 0, 6],
      [0, 0, 1,  0, 7, 4,  9, 8, 2],
      [3, 0, 0,  0, 0, 2,  0, 0, 1],

      [9, 0, 0,  5, 3, 0,  6, 2, 0],
      [0, 5, 0,  0, 0, 9,  0, 1, 0],
      [0, 0, 3,  8, 2, 7,  0, 0, 0],

      [8, 3, 2,  4, 0, 6,  1, 7, 5],
      [0, 0, 0,  0, 1, 8,  0, 0, 9],
      [0, 0, 0,  0, 0, 0,  2, 0, 0],
    ];

    locationsMap = generateLocationsMap();

    blockSegmentMap = {0: 0, 1: 0, 2: 0, 3: 1, 4: 1, 5: 1, 6: 2, 7: 2, 8: 2};
  }

  @override
  toString() {
    return "Grid";
  }

  List<List<Map<int, int>>> generateLocationsMap() {
    // generate the locations for the entire grid
    List<List<Map<int, int>>> segmentLocationsMap = [];
    List<Map<int, int>> rowLocations;

    for (int rowIdx = 0; rowIdx < grid.length; rowIdx++) {
      rowLocations = [];
      for (int colIdx = 0; colIdx < grid[rowIdx].length; colIdx++) {
        rowLocations.add({rowIdx: colIdx});
      }
      segmentLocationsMap.add(rowLocations);
    }

    return segmentLocationsMap;
  }

  void printGrid() {
    for (int i = 0; i < grid.length; i++) {
      print(grid[i]);
    }
  }

  void displayGrid() {
    for (int rowIdx = 0; rowIdx < grid.length; rowIdx++) {
      List<int> row = grid[rowIdx];
      for (int colIdx = 0; colIdx < row.length; colIdx++) {
        int value = row[colIdx];
        stdout.write('$value ');

        if (colIdx == 2 || colIdx == 5) {
          stdout.write('  ');
        }
      }

      if (rowIdx == 2 || rowIdx == 5) {
        stdout.write('\n\n');
      } else {
        stdout.write('\n');
      }
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

  List<Map<int, int>> getSegmentLocations(int locX, int locY) {
    // reduce the locations to the desired segments
    Map<int, int> startFromMap = {0: 0, 1: 3, 2: 6};
    List<Map<int, int>> combined = [];

    int rowsStartFrom = startFromMap[locY]!;
    int colsStartFrom = startFromMap[locX]!;
    List<List<Map<int, int>>> rows =
        locationsMap.sublist(rowsStartFrom, rowsStartFrom + 3);

    for (int i = 0; i < rows.length; i++) {
      List<Map<int, int>> rowValues =
          rows[i].sublist(colsStartFrom, colsStartFrom + 3);
      combined.addAll(rowValues);
    }

    return combined;
  }

  List<int> getBlockSoloutionSpace(int locX, int locY) {
    int currentValue = grid[locY][locX];
    if (currentValue != 0) {
      List<int> cv = [currentValue];
      return cv;
    }

    List<int> soloutionSpace = [1, 2, 3, 4, 5, 6, 7, 8, 9];

    // Getting values in segment, row, and column
    int segX = blockSegmentMap[locX]!;
    int segY = blockSegmentMap[locY]!;
    List<int> segmentValues = getValuesInSegment(segX, segY);
    List<int> rowValues = getValuesInRow(locY);
    List<int> colValues = getValuesInCol(locX);

    // combine segment, row, and column into one list
    List<int> conflictingValues = [];
    conflictingValues.addAll(segmentValues);
    conflictingValues.addAll(rowValues);
    conflictingValues.addAll(colValues);

    // remove conflicting values from soloution space
    for (int i = 0; i < conflictingValues.length; i++) {
      int value = conflictingValues[i];
      if (soloutionSpace.contains(value)) {
        soloutionSpace.remove(value);
      }
    }

    return soloutionSpace;
  }

  void singleOptionPass() {
    for (int y = 0; y < 9; y++) {
      for (int x = 0; x < 9; x++) {
        List<int> solSpace = getBlockSoloutionSpace(x, y);
        if (solSpace.length == 1) {
          grid[y][x] = solSpace[0];
        }
      }
    }
  }

  void elemenationPass() {
    for (int y = 0; y < 9; y++) {
      for (int x = 0; x < 9; x++) {
        List<int> blockSoloutionSpace = getBlockSoloutionSpace(x, y);
        if (blockSoloutionSpace.length > 1) {
          List<Map<int, int>> neighbourBlocksLocations =
              getSegmentLocations(blockSegmentMap[y]!, blockSegmentMap[x]!);
          neighbourBlocksLocations.remove({y: x});

          // check if soloution exsits in any other block, if it does remove it from space
          for (int i = 0; i < blockSoloutionSpace.length; i++) {
            if (grid[y][x] == 0) {
              // checking every possible soloution
              int soloution = blockSoloutionSpace[i];

              for (int neighbourBlock = 0;
                  neighbourBlock < neighbourBlocksLocations.length;
                  neighbourBlock++) {
                int locY = neighbourBlocksLocations[i].keys.first;
                int locX = neighbourBlocksLocations[i][locY]!;
                List<int> nBlockSoloutions = getBlockSoloutionSpace(locX, locY);
                if (nBlockSoloutions.contains(soloution)) {
                  blockSoloutionSpace.remove(soloution);
                }
              }
            }
          }

          if (blockSoloutionSpace.length == 1) {
            grid[y][x] = blockSoloutionSpace[0];
            print('set y=$y x=$x to ${blockSoloutionSpace[0]}');
          }
        }
      }
    }
  }

  void runPass() {
    singleOptionPass();
  }

  int countEmpty() {
    int zeroCount = 0;

    for (int y = 0; y < 9; y++) {
      for (int x = 0; x < 9; x++) {
        if (grid[y][x] == 0) {
          zeroCount++;
        }
      }
    }

    return zeroCount;
  }

  // END OF CLASS
}

void main(List<String> arguments) {
  Grid grid = Grid();
  print('space for row 4 col 1 ${grid.getBlockSoloutionSpace(0, 3)}');

  grid.displayGrid();
  print("Zero count = ${grid.countEmpty()}");

  grid.singleOptionPass();
  grid.singleOptionPass();
  grid.singleOptionPass();
  print('\n\n');
  grid.displayGrid();
  print("Zero count = ${grid.countEmpty()}");

  print("ELEMENATION PASS");
  grid.elemenationPass();
  grid.elemenationPass();
  grid.elemenationPass();
  print('\n\n');
  grid.displayGrid();
  print("Zero count = ${grid.countEmpty()}");

  grid.singleOptionPass();
  grid.singleOptionPass();
  grid.singleOptionPass();
  print('\n\n');
  grid.displayGrid();
  print("Zero count = ${grid.countEmpty()}");

  print("ELEMENATION PASS");
  grid.elemenationPass();
  grid.elemenationPass();
  grid.elemenationPass();
  print('\n\n');
  grid.displayGrid();
  print("Zero count = ${grid.countEmpty()}");

  grid.singleOptionPass();
  grid.singleOptionPass();
  grid.singleOptionPass();
  print('\n\n');
  grid.displayGrid();
  print("Zero count = ${grid.countEmpty()}");

  print("ELEMENATION PASS");
  grid.elemenationPass();
  grid.elemenationPass();
  grid.elemenationPass();
  print('\n\n');
  grid.displayGrid();
  print("Zero count = ${grid.countEmpty()}");
}
