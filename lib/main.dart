import 'dart:async';

import 'package:flutter/material.dart';
import 'package:merge_stream_ui_rxdart/api/api_service.dart';
import 'package:merge_stream_ui_rxdart/model/photo.dart';
import 'package:merge_stream_ui_rxdart/model/post.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'MergeStream and StreamZip'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with AutomaticKeepAliveClientMixin{
  final _dataList = <dynamic>[];
  StreamController _streamController;

  @override
  void initState() {
    _streamController = StreamController.broadcast();
    setupData();
    super.initState();
  }

  void setupData() async {
    Stream stream = await ApiService().getData()
      ..asBroadcastStream();
    stream.listen((event) {
      setState(() {
        _dataList.add(event[0]);
        _dataList.add(event[1]);
      });
    });
  }

  @override
  void dispose() {
    _streamController?.close();
    _streamController = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: ListView.builder(
        itemCount: _dataList.length,
        itemBuilder: (context, index) {
          final item = _dataList[index];

          if (item is Photo) {
            return ListTile(
              title: Text(item.title),
              subtitle: Image.network(
                item.url,
                scale: 0.5,
              ),
            );
          }

          if (item is Post) {
            return ListTile(
              title: Text('Title: ${item.title}'),
              subtitle: Text('Body: ${item.body}'),
              leading: Text(index.toString()),
            );
          }

          return null;
        },
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
