class Photo{
  final String url;
  final String title;

  Photo({this.url, this.title});

  Photo.fromJson(Map json) : url = json['url'], title = json['title'];
}