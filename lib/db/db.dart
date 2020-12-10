import 'package:hive/hive.dart';
import 'package:manga_reader/models/book.dart';

var libraryDBName = "library";
var libraryDB = Hive.openBox<Book>(libraryDBName);
