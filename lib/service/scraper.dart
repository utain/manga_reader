import 'dart:developer';
import 'dart:typed_data';

import 'package:http/http.dart' as http;
import 'package:manga_reader/db/db.dart';
import 'package:manga_reader/models/book.dart';
import 'package:web_scraper/web_scraper.dart';

abstract class ImageScraper {
  Future<List<String>> get load;

  Future<String> get bookName;

  Future<Book> save() async {
    List<String> imageList = await this.load;
    if (imageList == null || imageList.length == 0) {
      throw Exception("Not found images");
    }
    var book = Book();
    book.id = imageList.elementAt(0);
    book.name = await this.bookName ?? "Undefine";
    book.pages = List<Uint8List>();
    for (int i = 0; i < imageList.length; i++) {
      var resp = await http.get(imageList.elementAt(i));
      book.pages.add(resp.bodyBytes);
    }
    var box = await libraryDB;
    await box.add(book);
    return book;
  }
}

class MangaOnlineImageScraper extends ImageScraper {
  final String baseURL = "https://www.manga-online.co";
  final String url;
  final String name;
  WebScraper webScraper;

  MangaOnlineImageScraper({this.url, this.name}) {
    this.webScraper = WebScraper(baseURL);
  }

  @override
  Future<List<String>> get load async {
    Uri uri = Uri.parse(url);
    log(" uri.path: ${uri.path}");
    if (await webScraper.loadWebPage(url.replaceFirst(baseURL, ""))) {
      List<Map<String, dynamic>> elements = webScraper.getElement(
          'body > div.wrap > div > div.site-content > div > div > div > div > div > div > div.c-blog-post > div.entry-content > div > div > div.reading-content > div.page-break > img',
          ['src']);
      return elements.map<String>((element) {
        return element["attributes"]["src"];
      }).toList();
    }
  }

  @override
  Future<String> get bookName async {
    return name;
  }
}
