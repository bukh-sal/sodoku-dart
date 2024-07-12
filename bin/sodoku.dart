import "dart:io";

class Grid {
  late List<List<String>> grid;
  late List<List<Map<dynamic, dynamic>>> locationsMap;
  late Map<dynamic, dynamic> blockSegmentMap;

  Grid() {
    grid = [
      ['0', '0', '0', '0',   '0', '1', '0', '6',    '0', '8', '0', '0',   'D', 'C', '0', '4'],
      ['0', '0', '6', 'C',   '7', '8', '2', '5',    '1', '0', '0', '3',   'B', 'E', 'A', '0'],
      ['0', '0', '4', 'E',   'C', '0', '0', '0',    'G', '5', 'A', '0',   '8', '0', '2', '0'],
      ['A', '8', '0', '0',   '0', 'E', '4', '0',    '0', '2', '6', '0',   '0', 'G', '0', '9'],

      ['4', 'E', 'B', '0',   '9', '0', '3', '0',    'A', '0', 'D', '0',   '7', '2', '6', '8'],
      ['0', '0', 'A', '0',   'G', 'F', '1', 'E',    '0', '0', '0', '2',   '5', '0', '0', 'D'],
      ['1', '0', 'C', '0',   '0', '0', 'D', '4',    '0', 'B', '0', '9',   '0', '0', '0', 'G'],
      ['6', '0', '0', 'G',   '2', 'A', '0', 'B',    '0', '0', '0', '0',   '0', '0', 'F', '0'],

      ['7', '0', '1', '0',   '4', '0', '0', 'G',    'B', 'D', '0', '5',   '0', '6', '0', '3'],
      ['G', 'B', '0', '0',   '0', '2', '6', '8',    '7', 'F', '0', '0',   'C', 'A', '0', '0'],
      ['E', '0', '0', '0',   '0', 'B', '0', '0',    '3', '0', '9', '0',   '0', 'D', 'G', '5'],
      ['8', 'C', '0', 'D',   '0', '0', 'E', '9',    '2', '0', '0', '6',   '4', '0', '0', '0'],

      ['0', 'F', '0', '0',   '0', '7', '9', '3',    '0', '0', '0', 'A',   'G', '8', '4', '2'],
      ['B', '0', '8', 'A',   '6', '0', '0', '0',    '0', '0', '3', '1',   '0', '0', 'D', 'C'],
      ['0', '0', '0', '0',   'E', 'D', '0', '0',    '0', '4', '8', 'B',   '6', '5', '0', '7'],
      ['0', '7', 'E', '6',   '0', '0', '0', '1',    'C', '0', '0', 'D',   '0', '0', 'B', 'A'],

    ];

    locationsMap = generateLocationsMap();

    blockSegmentMap = {
      0: 0,
      1: 0,
      2: 0,
      3: 0,

      4: 1,
      5: 1,
      6: 1,
      7: 1,

      8: 2,
      9: 2,
      10:2,
      11:2,

      12:3,
      13:3,
      14:3,
      15:3
      };
  }

  @override
  toString() {
    return "Grid";
  }

  List<List<Map<dynamic, dynamic>>> generateLocationsMap() {
    // generate the locations for the entire grid
    List<List<Map<dynamic, dynamic>>> segmentLocationsMap = [];
    List<Map<dynamic, dynamic>> rowLocations;

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
      List<String> row = grid[rowIdx];
      for (int colIdx = 0; colIdx < row.length; colIdx++) {
        String value = row[colIdx];
        stdout.write('$value ');

        if (colIdx == 3 || colIdx == 7 || colIdx == 11) {
          stdout.write('  ');
        }
      }

      if (rowIdx == 3 || rowIdx == 7 || rowIdx == 11 ) {
        stdout.write('\n\n');
      } else {
        stdout.write('\n');
      }
    }
  }

  List<String> getValuesInRow(int rowNumber) {
    List<String> uVals = [];
    List<String> row = grid[rowNumber];
    for (int i = 0; i < row.length; i++) {
      String value = row[i];
      if (!uVals.contains(value)) {
        uVals.add(value);
      }
    }
    return uVals;
  }

  List<String> getValuesInCol(int colNumber) {
    List<String> uVals = [];
    for (int i = 0; i < grid.length; i++) {
      List<String> row = grid[i];
      String value = row[colNumber];
      if (!uVals.contains(value)) {
        uVals.add(value);
      }
    }
    return uVals;
  }

  List<String> getValuesInSegment(int locX, int locY) {
    Map<dynamic, dynamic> startFromMap = {
      0: 0,
      1: 4,
      2: 8,
      3: 12,
      };
    int rowsStartFrom = startFromMap[locY]!;
    int colsStartFrom = startFromMap[locX]!;
    List<List<String>> rows = grid.sublist(rowsStartFrom, rowsStartFrom + 4);

    for (int i = 0; i < rows.length; i++) {
      List<String> rowValues = rows[i].sublist(colsStartFrom, colsStartFrom + 4);
      rows[i] = rowValues;
    }

    List<String> uVals = [];
    for (int a = 0; a < rows.length; a++) {
      List<String> row = rows[a];

      for (int b = 0; b < row.length; b++) {
        String value = row[b];
        if (!uVals.contains(value)) {
          uVals.add(value);
        }
      }
    }

    return uVals;
  }

  List<Map<dynamic, dynamic>> getSegmentLocations(int locX, int locY) {
    // reduce the locations to the desired segments
    Map<dynamic, dynamic> startFromMap = {
      0: 0,
      1: 4,
      2: 7,
      3: 12,
    };
    List<Map<dynamic, dynamic>> combined = [];

    int rowsStartFrom = startFromMap[locY]!;
    int colsStartFrom = startFromMap[locX]!;
    List<List<Map<dynamic, dynamic>>> rows =
        locationsMap.sublist(rowsStartFrom, rowsStartFrom + 4);

    for (int i = 0; i < rows.length; i++) {
      List<Map<dynamic, dynamic>> rowValues =
          rows[i].sublist(colsStartFrom, colsStartFrom + 4);
      combined.addAll(rowValues);
    }

    return combined;
  }

  List<String> getBlockSolutionSpace(int locX, int locY) {
    String currentValue = grid[locY][locX];
    if (currentValue != '0') {
      List<String> cv = [currentValue];
      return cv;
    }

    List<String> solutionSpace = ['1', '2', '3', '4', '5', '6', '7', '8', '9', 'A', 'B', 'C', 'D', 'E', 'F', 'G'];

    // Getting values in segment, row, and column
    int segX = blockSegmentMap[locX]!;
    int segY = blockSegmentMap[locY]!;
    List<String> segmentValues = getValuesInSegment(segX, segY);
    List<String> rowValues = getValuesInRow(locY);
    List<String> colValues = getValuesInCol(locX);

    // combine segment, row, and column into one list
    List<String> conflictingValues = [];
    conflictingValues.addAll(segmentValues);
    conflictingValues.addAll(rowValues);
    conflictingValues.addAll(colValues);

    // remove conflicting values from solution space
    for (int i = 0; i < conflictingValues.length; i++) {
      String value = conflictingValues[i].toString();
      if (solutionSpace.contains(value)) {
        solutionSpace.remove(value);
      }
    }

    return solutionSpace;
  }

  void singleOptionPass() {
    for (int y = 0; y < 16; y++) {
      for (int x = 0; x < 16; x++) {
        List<String> solSpace = getBlockSolutionSpace(x, y);
        if (solSpace.length == 1) {
          grid[y][x] = solSpace[0];
        }
      }
    }
  }

  void eliminationPass() {
    for (int y = 0; y < 16; y++) {
      for (int x = 0; x < 16; x++) {
        List<String> blockSolutionSpace = getBlockSolutionSpace(x, y);
        if (blockSolutionSpace.length > 1) {
          List<Map<dynamic, dynamic>> neighborBlocksLocations =
              getSegmentLocations(blockSegmentMap[y]!, blockSegmentMap[x]!);
          neighborBlocksLocations.remove({y: x});

          // check if solution exists in any other block, if it does remove it from space
          for (int i = 0; i < blockSolutionSpace.length; i++) {
            if (grid[y][x] == '0') {
              // checking every possible solution
              var solution = blockSolutionSpace[i];

              for (int neighborBlock = 0;
                  neighborBlock < neighborBlocksLocations.length;
                  neighborBlock++) {
                int locY = neighborBlocksLocations[i].keys.first;
                int locX = neighborBlocksLocations[i][locY]!;
                List<String> nBlockSolutions = getBlockSolutionSpace(locX, locY);
                if (nBlockSolutions.contains(solution)) {
                  blockSolutionSpace.remove(solution);
                }
              }
            }
          }

          if (blockSolutionSpace.length == 1) {
            grid[y][x] = blockSolutionSpace[0];
            print('set y=$y x=$x to ${blockSolutionSpace[0]}');
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

    for (int y = 0; y < 16; y++) {
      for (int x = 0; x < 16; x++) {
        if (grid[y][x] == '0') {
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
  print('space for row 4 col 1 ${grid.getBlockSolutionSpace(0, 3)}');

  grid.displayGrid();
  print("Zero count = ${grid.countEmpty()}");

  grid.singleOptionPass();
  grid.singleOptionPass();
  grid.singleOptionPass();
  print('\n\n');
  grid.displayGrid();
  print("Zero count = ${grid.countEmpty()}");

  print("ELIMINATION PASS");
  grid.eliminationPass();
  grid.eliminationPass();
  grid.eliminationPass();
  print('\n\n');
  grid.displayGrid();
  print("Zero count = ${grid.countEmpty()}");

  grid.singleOptionPass();
  grid.singleOptionPass();
  grid.singleOptionPass();
  print('\n\n');
  grid.displayGrid();
  print("Zero count = ${grid.countEmpty()}");

  print("ELIMINATION PASS");
  grid.eliminationPass();
  grid.eliminationPass();
  grid.eliminationPass();
  print('\n\n');
  grid.displayGrid();
  print("Zero count = ${grid.countEmpty()}");

  grid.singleOptionPass();
  grid.singleOptionPass();
  grid.singleOptionPass();
  print('\n\n');
  grid.displayGrid();
  print("Zero count = ${grid.countEmpty()}");

  print("ELIMINATION PASS");
  grid.eliminationPass();
  grid.eliminationPass();
  grid.eliminationPass();
  print('\n\n');
  grid.displayGrid();
  print("Zero count = ${grid.countEmpty()}");


  grid.singleOptionPass();
  grid.singleOptionPass();
  grid.singleOptionPass();
  print('\n\n');
  grid.displayGrid();
  print("Zero count = ${grid.countEmpty()}");

  print("ELIMINATION PASS");
  grid.eliminationPass();
  grid.eliminationPass();
  grid.eliminationPass();
  print('\n\n');
  grid.displayGrid();
  print("Zero count = ${grid.countEmpty()}");



  grid.singleOptionPass();
  grid.singleOptionPass();
  grid.singleOptionPass();
  print('\n\n');
  grid.displayGrid();
  print("Zero count = ${grid.countEmpty()}");

  print("ELIMINATION PASS");
  grid.eliminationPass();
  grid.eliminationPass();
  grid.eliminationPass();
  print('\n\n');
  grid.displayGrid();
  print("Zero count = ${grid.countEmpty()}");



  grid.singleOptionPass();
  grid.singleOptionPass();
  grid.singleOptionPass();
  print('\n\n');
  grid.displayGrid();
  print("Zero count = ${grid.countEmpty()}");

  print("ELIMINATION PASS");
  grid.eliminationPass();
  grid.eliminationPass();
  grid.eliminationPass();
  print('\n\n');
  grid.displayGrid();
  print("Zero count = ${grid.countEmpty()}");


  grid.singleOptionPass();
  grid.singleOptionPass();
  grid.singleOptionPass();
  print('\n\n');
  grid.displayGrid();
  print("Zero count = ${grid.countEmpty()}");

  print("ELIMINATION PASS");
  grid.eliminationPass();
  grid.eliminationPass();
  grid.eliminationPass();
  print('\n\n');
  grid.displayGrid();
  print("Zero count = ${grid.countEmpty()}");
}
