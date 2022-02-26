import 'package:csv/csv.dart';
//import 'package:file_picker/file_picker.dart';
import 'dart:io';

// import 'package:flutter/widgets.dart';

class Pupil {
  String name;
  // UniqueKey id = UniqueKey();
  List<Pupil> should = [];
  List<Pupil> shouldNot = [];
  List<Pupil> must = [];
  List<Pupil> mustNot = [];
  Group? group;

  Pupil(this.name);

  @override
  bool operator ==(Object other) => other is Pupil && other.name == name;

  @override
  int get hashCode => name.hashCode;

  int get score {
    int score = 0;
    for (var s in should) {
      score += s.group == group ? 1 : 0;
    }
    for (var s in shouldNot) {
      score += s.group == group ? -1 : 0;
    }
    return score;
  }

  bool get isAlone {
    return should.isEmpty ? false : !should.any((p) => p.group == group);
  }

  int get nMatches =>
      should.fold(0, (acum, p) => p.group == group ? acum + 1 : acum);

  int get nMismatches =>
      shouldNot.fold(0, (acum, p) => p.group == group ? acum + 1 : acum);
}

class Group {
  String name;
  List<Pupil> pupils = [];
  Group(this.name);

  void reset() => pupils.clear();

  int get nAlone =>
      pupils.map((p) => p.isAlone ? 1 : 0).reduce((x, y) => x + y);
  int get nMatches => pupils.map((p) => p.nMatches).reduce((x, y) => x + y);
  int get nMismatches =>
      pupils.map((p) => p.nMismatches).reduce((x, y) => x + y);
  int get score => pupils.map((p) => p.score).reduce((x, y) => x + y);

  @override
  bool operator ==(Object other) => other is Group && other.name == name;

  @override
  int get hashCode => name.hashCode;
}

List<int> range(int start, [int? stop]) {
  if (stop == null) {
    stop = start;
    start = 0;
  }
  return [for (var i = start; i < stop; i++) i];
}

int computeTotalScore(List<Pupil> pupils) {
  return pupils.fold(0, (acum, p) => acum + p.score);
}

void assignGrouping(
    List<int> grouping, List<Pupil> pupils, List<Group> groups) {
  for (var g in groups) {
    g.reset();
  }
  int i = 0;
  for (var p in pupils) {
    p.group = groups[grouping[i]];
    groups[grouping[i]].pupils.add(p);
    i++;
  }
}

List<int> randomGrouping(List<Pupil> pupils, List<Group> groups) {
  var gping = [for (int i in range(pupils.length)) i % groups.length];
  gping.shuffle();
  assignGrouping(gping, pupils, groups);
  return gping;
}

int bestOf(int nTries, List<Pupil> pupils, List<Group> groups) {
  var bestScore = -1000;
  List<int> bestGping = <int>[];

  for (var _ in range(nTries)) {
    var gping = randomGrouping(pupils, groups);
    var score = computeTotalScore(pupils);
    if (score > bestScore) {
      bestScore = score;
      bestGping = gping;
    }
  }

  assignGrouping(bestGping, pupils, groups);
  return bestScore;
}

void printSummary(List<Group> groups) {
  print('');
  for (var g in groups) {
    print('Group ${g.name}');
    print('   matches: ${g.nMatches}');
    print('mismatches: ${g.nMismatches}');
    print('     alone: ${g.nAlone}');
    print('     score: ${g.score}');
    print('\n===============\n');
  }
}

printLong(List<Pupil> pupils, List<Group> groups) {
  int i = 0;
  for (Pupil p in pupils) {
    print(p.name);
    print(p.group?.name);
    print(p.score);
    print('-----------------SHOULD------------------');
    for (var s in p.should) {
      print(s.name);
    }
    print('---------------SHOULD NOT----------------');
    for (var s in p.shouldNot) {
      print(s.name);
    }
    print('=========================================');
  }
  for (var g in groups) {
    print('Group ${g.name} ${g.score}');
  }
  print("\n");
}

// Test main
main() {
  final File file = File('test/pupils.csv');

  List<List<String>> rows =
      const CsvToListConverter().convert(file.readAsStringSync());
  Map<String, Pupil> pupils = {};

  // ['Name', 'Positive 1', 'Positive 2', 'Positive 2', 'Negative 1', 'Negative 2', 'Negative 3']
  for (List row in rows.sublist(1)) {
    pupils[row[0]] = Pupil(row[0]);
  }

  for (List row in rows.sublist(1)) {
    Pupil pupil = pupils[row[0]]!;
    row
        .sublist(1, 4)
        .where((name) => name != '')
        .forEach((name) => pupil.should.add(pupils[name]!));
    row
        .sublist(5)
        .where((name) => name != '')
        .forEach((name) => pupil.shouldNot.add(pupils[name]!));
    // row
    //     .sublist(8, 11)
    //     .where((name) => name != '')
    //     .forEach((name) => pupil.must.add(pupils[name]!));
    // row
    //     .sublist(11)
    //     .where((name) => name != '')
    //     .forEach((name) => pupil.mustNot.add(pupils[name]!));
  }

  var groups = [Group("3r A"), Group("3r B"), Group("3r C")];

  var bestScore = bestOf(1000000, pupils.values.toList(), groups);
  printSummary(groups);
  print('Total score: $bestScore');
}
