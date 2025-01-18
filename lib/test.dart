void main() async {
  List a = [1, 2, 5];
  List b = List.generate(
    a.length,
    (index) => false,
  );
  print(b);
}
