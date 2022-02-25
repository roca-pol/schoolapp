import 'package:csv/csv.dart';
//import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'dart:convert';

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

  int getScore() {
    int score = 0;
    for (var s in should) {
      score += s.group == group ? 1 : 0;
    }
    for (var s in shouldNot) {
      score += s.group == group ? -1 : 0;
    }
    return score;
  }
}

class Group {
  int name;
  int score = 0;
  Group(this.name);

  addScore(int point) => score += point;
  resetScore() => score = 0;
}

/// Checks if [Pupil] already exists otherwise adds it to the list and returns it
Pupil getOrInsertPupil(String name, List<Pupil> pupils) {
  Pupil pupil = Pupil(name);
  int idx = pupils.indexOf(pupil);
  if (idx == -1) {
    pupils.add(pupil);
  } else {
    pupil = pupils[idx];
  }
  return pupil;
}

List<int> range(int start, [int? stop]) {
  if (stop == null) {
    stop = start;
    start = 0;
  }
  return [for (var i = start; i < stop; i++) i];
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
  }

  print(pupils.length);
  var groups = [Group("3r A"), Group("3r B"), Group("3r C")];
  var ass = [for (int i in range(pupils.length)) i % groups.length];
  ass.shuffle();

  int i = 0;
  for (Pupil p in pupils.values) {
    p.group = groups[ass[i++]];

    p.group?.addScore(p.getScore());
    print(p.name);
    print(p.group?.name);
    print(p.getScore());
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
  print("\n");
  for (var g in groups) {
    print('Group ${g.name} ${g.score}');
  }
}
