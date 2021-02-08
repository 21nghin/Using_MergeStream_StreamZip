import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:merge_stream_ui_rxdart/model/photo.dart';
import 'package:merge_stream_ui_rxdart/model/post.dart';
import 'package:async/async.dart';

class ApiService {


  Future<Stream> getData() async {
    final client = http.Client();

    Stream streamPhoto = await getPhotos(client);
    Stream streamPost = await getPosts(client);

    return StreamZip([streamPhoto,streamPost]).asBroadcastStream();
  }

  Future<Stream> getPhotos(http.Client client) async {
    final url = 'https://jsonplaceholder.typicode.com/photos';
    final request = http.Request('get', Uri.parse(url));

    http.StreamedResponse streamedResponse = await client.send(request);

    return streamedResponse.stream
        .transform(utf8.decoder)
        .transform(json.decoder)
        .expand((element) => element)
        .map((json) => Photo.fromJson(json));
  }

  Future<Stream> getPosts(http.Client client) async {
    final url = 'https://jsonplaceholder.typicode.com/posts';
    final request = http.Request('get', Uri.parse(url));

    http.StreamedResponse streamedResponse = await client.send(request);

    return streamedResponse.stream
        .transform(utf8.decoder)
        .transform(json.decoder)
        .expand((element) => element)
        .map((json) => Post.fromJson(json));
  }
}
