enum MyWorkspaceRole {
  owner,
  member,
}

class Test {
  final String a;
  Test({required this.a});
}

void main() {
  var map = {};
  // map.addAll({1: "345"});
  // map.addAll({1: "456"});
  map[1] = "343";
  map[1] = "2w34";
  print(map);

  // print(a.values.);
}
