import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:manga_reader/service/scraper.dart';

class AddBookPage extends StatefulWidget {
  @override
  _AddBookPageState createState() => _AddBookPageState();
}

class _AddBookPageState extends State<AddBookPage> {
  TextEditingController _titleCtl = TextEditingController();
  TextEditingController _urlCtl = TextEditingController();
  bool loading = false;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Book"),
      ),
      body: Container(
        clipBehavior: Clip.antiAlias,
        padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 15.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.0),
            topRight: Radius.circular(20.0),
          ),
        ),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                child: Text(
                  "Add New Book",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                ),
              ),
              SizedBox(height: 20),
              TextFormField(
                keyboardType: TextInputType.text,
                enabled: loading,
                inputFormatters: [
                  FilteringTextInputFormatter.singleLineFormatter
                ],
                controller: _titleCtl,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  isDense: true,
                  labelText: 'Title',
                ),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter book title';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              TextFormField(
                keyboardType: TextInputType.url,
                inputFormatters: [
                  FilteringTextInputFormatter.singleLineFormatter
                ],
                controller: _urlCtl,
                enabled: loading,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  isDense: true,
                  labelText: 'URL',
                  hintText:
                      "https://www.manga-online.co/manga/wu-dong-qian-kun/%E0%B8%95%E0%B8%AD%E0%B8%99%E0%B8%97%E0%B8%B5%E0%B9%88-60/?style=list",
                ),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter manga url';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),
              Text(
                  "For now support only manage from web https://www.manga-online.co"),
              Text(
                  "Example URL: https://www.manga-online.co/manga/wu-dong-qian-kun/%E0%B8%95%E0%B8%AD%E0%B8%99%E0%B8%97%E0%B8%B5%E0%B9%88-60/?style=list"),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  FlatButton(
                    onPressed: loading
                        ? null
                        : () {
                            Navigator.pop(context);
                          },
                    child: Text("Cancel"),
                  ),
                  SizedBox(width: 20),
                  FlatButton(
                    onPressed: loading == true ? null : _handleAdd,
                    child: Text(
                      "Add",
                      style: TextStyle(color: Colors.white),
                    ),
                    color: Colors.blue,
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  void _handleAdd() async {
    if (!_formKey.currentState.validate()) {
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Processing Data'),
      ),
    );
    setState(() {
      loading = true;
    });
    String url = _urlCtl.value.text;
    MangaOnlineImageScraper(url: url, name: _titleCtl.value.text)
        .save()
        .then((value) {
      setState(() {
        loading = false;
      });
      Navigator.pop(context);
    });
  }
}
