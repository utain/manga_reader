import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:manga_reader/models/book.dart';

class BookReaderPage extends StatefulWidget {
  final Book book;

  const BookReaderPage({Key key, this.book}) : super(key: key);

  @override
  _BookReaderPageState createState() => _BookReaderPageState();
}

class _BookReaderPageState extends State<BookReaderPage> {
  bool showTool = false;
  bool isZoom = false;
  PageController _pageController =
      PageController(viewportFraction: 1, initialPage: 0);
  TransformationController _transformationController =
      TransformationController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      extendBody: true,
      extendBodyBehindAppBar: true,
      appBar: showTool == true
          ? AppBar(
              title: Text(
                widget.book.name,
                style: TextStyle(color: Colors.white),
              ),
              automaticallyImplyLeading: true,
              elevation: 0,
              backgroundColor: Colors.black54,
            )
          : null,
      body: GestureDetector(
        onTap: () {
          setState(() {
            showTool = !showTool;
          });
        },
        child: InteractiveViewer(
          maxScale: 6.0,
          minScale: 0.2,
          transformationController: _transformationController,
          onInteractionEnd: (details) {
            setState(() {
              isZoom =
                  _transformationController.value.getMaxScaleOnAxis() != 1.0;
            });
          },
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: PageView.builder(
              controller: _pageController,
              itemCount: widget.book.pages.length,
              physics:
                  isZoom ? NeverScrollableScrollPhysics() : PageScrollPhysics(),
              itemBuilder: (context, index) {
                return Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  child: Container(
                    child: Image.memory(widget.book.pages.elementAt(index)),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
