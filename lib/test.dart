Future func1() => Future.delayed(Duration(seconds: 5), () => print("func1"));
Future func2() => Future.delayed(Duration(seconds: 3), () => print("func2"));

class Test {
  late int a;
  static final Test instance = Test._();
  Test._();
  factory Test({required int b}) {
    instance.a = b;
    return instance;
  }
  log() {
    print(a);
  }
}

void main() async {
  var b = Test(b: 10);
  var c = Test(b: 34);
  if (b == c) {
    print("okay");
    b.log();
    c.log();
  } else {
    print("not okay");
    b.log();
    c.log();
  }
}
