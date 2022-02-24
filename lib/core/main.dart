class Pupil {
  List<Pupil> should;
  List<Pupil> shouldNot;
  List<Pupil> must;
  List<Pupil> mustNot;
  Group group;

  get getShould => this.should;

  set setShould(List<Pupil> should) => this.should = should;

  get getShouldNot => this.shouldNot;

  set setShouldNot(shouldNot) => this.shouldNot = shouldNot;

  get getMust => this.must;

  set setMust(must) => this.must = must;

  get getMustNot => this.mustNot;

  set setMustNot(mustNot) => this.mustNot = mustNot;

  get getGroup => this.group.getName();

  set setGroup(group) => this.group = group;
}

class Group {
  String name;

  String get getName => this.name;

  set setName(String name) => this.name = name;
}

main() {}
