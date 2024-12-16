import 'dart:convert';
import 'dart:io';

class Test {
  static final Test instance = Test._();

  Test._();
}

void main() async {
  var obj1 = Test.instance;
  var obj2 = Test.instance;
  if (obj1 == obj2) {
    print("okay");
  } else {
    print("!okay");
  }
}
