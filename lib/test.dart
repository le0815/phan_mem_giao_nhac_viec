import 'dart:convert';
import 'dart:math' as math;

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
  String a =
      "{uid: nlVmz66WNDfhzOyMdTxLJOvoziq1, due: 1735889402285, timeUpdate: 1735803008477, assigner: null, description: , startTime: 1735803120000, state: pending, title: sreer, createAt: 1735803008477, workspaceID: null}";
  print(jsonDecode(a));
}
