import 'package:csv/csv.dart';
//import 'package:file_picker/file_picker.dart';
import 'dart:io';

class Pupil {
  String name;
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
}

class Group {
  String name;

  Group(this.name);

  get getName => name;

  set setName(String name) => this.name = name;
}

//test main
main() {
  var p = Pupil('Miguel Corcho');
  p.group = Group('Perlana');

  print(p.group);
}
