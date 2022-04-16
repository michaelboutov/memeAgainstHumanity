class GifModel {
  String name, url, id;
  GifModel(this.name, this.url, this.id);

  Map<String, dynamic> toJson() =>
      <String, dynamic>{'id': id, 'name': name, 'url': url};
}
