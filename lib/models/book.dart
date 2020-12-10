import 'dart:typed_data';

import 'package:hive/hive.dart';

part 'book.g.dart';

@HiveType(typeId: 0)
class Book extends HiveObject {
  Book();
  Book.ofMap(Map<String, dynamic> data) {
    this.id = data['id'];
    this.name = data['name'];
    this.pages = data['pages'];
  }

  @HiveField(0)
  String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  List<Uint8List> pages;

  Map<String, dynamic> toMap() {
    Map<String, dynamic> data = Map();
    data['id'] = this.id;
    data['name'] = this.name;
    data['pages'] = this.pages;
    return data;
  }
}

// class BookAdapter extends TypeAdapter<Book> {
//   @override
//   final typeId = 16;
//
//   @override
//   Book read(BinaryReader reader) {
//     var micros = reader.readMap();
//     return Book.ofMap(micros);
//   }
//
//   @override
//   void write(BinaryWriter writer, Book obj) {
//     writer.writeMap(obj.toMap());
//   }
// }
