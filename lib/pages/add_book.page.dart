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
  Widget _buildForm() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 25.0, horizontal: 20.0),
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
              enabled: loading != true,
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
              enabled: loading != true,
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
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Scaffold(
            appBar: AppBar(
              title: Text("Add Book"),
            ),
            body: _buildForm(),
          ),
          if (loading == true)
            Container(
              padding: EdgeInsets.only(top: 120),
              alignment: Alignment.topCenter,
              color: Colors.black54,
              child: CircularProgressIndicator(),
            ),
        ],
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
