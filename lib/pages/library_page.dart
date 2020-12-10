import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:manga_reader/db/db.dart';
import 'package:manga_reader/models/book.dart';
import 'package:manga_reader/pages/add_book.page.dart';
import 'package:manga_reader/pages/book_reader_page.dart';
import 'package:manga_reader/service/scraper.dart';
import 'package:hive_flutter/hive_flutter.dart';

class LibraryPage extends StatefulWidget {
  LibraryPage({Key key}) : super(key: key);

  @override
  _LibraryPageState createState() => _LibraryPageState();
}

class _LibraryPageState extends State<LibraryPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: UILibrary());
  }
}

class UILibrary extends StatelessWidget {
  const UILibrary({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Library",
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                    builder: (context) {
                      return AddBookPage();
                    },
                    fullscreenDialog: true),
              );
            },
          )
        ],
      ),
      body: UIBookGrid(),
    );
  }
}

class UIBookGrid extends StatefulWidget {
  const UIBookGrid({
    Key key,
  }) : super(key: key);

  @override
  _UIBookGridState createState() => _UIBookGridState();
}

class _UIBookGridState extends State<UIBookGrid> {
  Box<Book> bookBox;

  @override
  void initState() {
    bookBox = Hive.box(libraryDBName);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ValueListenableBuilder(
          valueListenable: bookBox.listenable(),
          builder: (context, Box<Book> box, _) {
            print("len: ${box.values.length}");
            return GridView.builder(
              itemCount: bookBox.values.length,
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 25),
              itemBuilder: (context, index) {
                return CupertinoContextMenu(
                  previewBuilder: (context, animation, child) {
                    return Container(
                      height: MediaQuery.of(context).size.height - 300,
                      child: AspectRatio(
                        child: child,
                        aspectRatio: 3 / 4.69,
                      ),
                    );
                  },
                  actions: [
                    CupertinoContextMenuAction(
                      trailingIcon: Icons.menu_book,
                      isDefaultAction: true,
                      child: const Text('Read'),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    CupertinoContextMenuAction(
                      trailingIcon: Icons.edit,
                      child: const Text('Edit'),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    CupertinoContextMenuAction(
                      trailingIcon: Icons.share,
                      child: const Text('Share'),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    CupertinoContextMenuAction(
                      trailingIcon: Icons.delete,
                      child: const Text('Delete'),
                      onPressed: () async {
                        await bookBox.values.elementAt(index).delete();
                        Navigator.pop(context);
                      },
                    ),
                  ],
                  child: Material(
                    clipBehavior: Clip.antiAlias,
                    borderRadius: BorderRadius.circular(8.0),
                    child: InkWell(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) {
                              return BookReaderPage(
                                book: bookBox.values.elementAt(index),
                              );
                            },
                            fullscreenDialog: true,
                            maintainState: true));
                      },
                      child: Container(
                        padding: EdgeInsets.all(10.0),
                        child: Column(
                          children: [
                            Material(
                              elevation: 5.0,
                              clipBehavior: Clip.antiAlias,
                              borderRadius: BorderRadius.circular(4.0),
                              child: AspectRatio(
                                aspectRatio: 3 / 4,
                                child: Image.memory(
                                    box.values.elementAt(index).pages.first,
                                    cacheHeight: 400,
                                    cacheWidth: 300),
                              ),
                            ),
                            Container(
                              child: Text(
                                box.values.elementAt(index).name,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              padding: EdgeInsets.only(top: 10),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount:
                    (MediaQuery.of(context).size.width / 200).round(),
                crossAxisSpacing: 15,
                mainAxisSpacing: 15,
                childAspectRatio: 3 / 4.69,
              ),
            );
          }),
    );
  }
}
