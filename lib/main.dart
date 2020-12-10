import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:manga_reader/db/db.dart';
import 'package:manga_reader/models/book.dart';
import 'package:manga_reader/pages/library_page.dart';

void main() async {
  await Hive.initFlutter();
  // Register Adapter
  Hive.registerAdapter(BookAdapter());
  //Register box
  await Hive.openBox<Book>(libraryDBName);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Manga Reader',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.system,
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: Colors.deepOrange
      ),
      darkTheme: ThemeData.dark(),
      home: LibraryPage(),
    );
  }
}
