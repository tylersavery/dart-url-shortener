import '../src/link.dart';

Future<void> main() async {
  final link = await Link.create("https://youtube.com/tyler2");

  if (link != null) {
    print(link);
  } else {
    print("ERROR");
  }
}
