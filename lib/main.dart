import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

void main() async {
//  String data = await readData();
//  String message;
//  if (data != null) {
//    message = data;
//  } else {
//    message = 'save data to retrieve';
//  }
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'data persistence',
    home: Home(),
  ));
}

class Home extends StatefulWidget {
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  TextEditingController enterDataFieldController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
        centerTitle: true,
        title: Text('data persistence app'),
      ),
      body: ListView(
        children: <Widget>[
          ListTile(
            title: TextField(
              controller: enterDataFieldController,
              decoration:
                  InputDecoration(labelText: 'to save', hintText: 'enter text'),
            ),
            trailing: Text('and press save'),
          ),
          ListTile(
            title: RaisedButton(
              child: Text('Save!'),
              onPressed: () {
                try {
                  writeData(enterDataFieldController.text);
                } catch (e) {
                  debugPrint('Nothing to Save Yet');
                }
              },
            ),
          ),
          ListTile(
            title: RaisedButton(
              onPressed: null,
              child: Text('Load Data'),
            ),
          ),
          ListTile(
            title: Text('Saved Data'),
            subtitle: FutureBuilder(
              future: readData(),
              builder: (BuildContext context, AsyncSnapshot<String> data) {
                if (data.hasData) {
                  return Text(
                    data.data.toString(),
                    style: TextStyle(color: Colors.red),
                  ); // data.data i.e object.content
                } else {
                  return Text('Let\'s save some data');
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

// get the device directory ro create file in
Future<String> get _localPath async {
  final directory = await getApplicationDocumentsDirectory();
  return directory.path;
}

// create new file
Future<File>
    get _localFile async // need to modify it to two functions, if file exist return existing function
{
  final filesPath = await _localPath;
  return File('$filesPath/File.txt');
}

// write in file
Future<File> writeData(String message) async {
  final file = await _localFile;
  return file.writeAsString('$message');
}

// read text from file
Future<String> readData() async {
  try {
    final file = await _localFile;
    String data = await file.readAsString();
    return data;
  } on Exception catch (e) {
    debugPrint('File Not Found');
    debugPrint(e.toString());
    return "File Not Found";
  }
}
