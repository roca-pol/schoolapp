import 'package:csv/csv.dart';
//import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'dart:convert';

import 'package:flutter/widgets.dart';

class Pupil {
  String name;
  UniqueKey id = UniqueKey();
  List<Pupil>? should;
  List<Pupil>? shouldNot;
  List<Pupil>? must;
  List<Pupil>? mustNot;
  Group? group;

  Pupil(this.name);

  get getShould => should;

  set setShould(List<Pupil> should) => this.should = should;

  get getShouldNot => shouldNot;

  set setShouldNot(shouldNot) => this.shouldNot = shouldNot;

  get getMust => must;

  set setMust(must) => this.must = must;

  get getMustNot => mustNot;

  set setMustNot(mustNot) => this.mustNot = mustNot;

  get getGroup => group?.getName;

  set setGroup(Group group) => this.group = group;

  UniqueKey get getId => id;

  set setId(UniqueKey id) => this.id = id;

  @override
  bool operator ==(Object other) => other is Pupil && other.name == name;

  @override
  int get hashCode => name.hashCode;
}

class Group {
  String name;

  Group(this.name);

  get getName => name;

  set setName(String name) => this.name = name;
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

// Test main
main() {
  final File file = File('test/pupils.csv');
  Stream<List> inputStream = file.openRead();
  List<Pupil> pupils = [];

  inputStream
      .transform(utf8.decoder)
      .transform(const LineSplitter())
      .listen((String line) {
    List row = line.split(',');

    // ['Name', 'Positive 1', 'Positive 2', 'Positive 2', 'Negative 1', 'Negative 2', 'Negative 3']
    var pupil = getOrInsertPupil(row[0], pupils);
    for (String? p in row.sublist(1, 4)) {
      if (p == null) break;
      pupil.getShould.add(getOrInsertPupil(p, pupils));
    }
    for (String? p in row.sublist(4)) {
      if (p == null) break;
      pupil.getShouldNot.add(getOrInsertPupil(p, pupils));
    }
  });
  for (Pupil p in pupils) {
    print(p.id);
    print(p.name);
    print('---------------SHOULD----------------');
    p.should?.forEach((s) => print(s.name));

    print('---------------SHOULD NOT----------------');
    p.shouldNot?.forEach((s) => print(s.name));
    print('=========================================');
  }
}
