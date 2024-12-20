class Test {
  final String a;
  Test({required this.a});
}

void main() {
  var b = Test(a: "asdf");
  print(b.a);
}
