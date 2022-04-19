import 'package:pure/model/gif_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class GifRepository {
  Future<List> getGifs() async {
    int i = 0;
    List<GifModel> listOfGif = [];
    while (i < 14) {
      listOfGif.add(await _getGif());
      i++;
    }
    return listOfGif;
  }
}

Future<GifModel> _getGif() async {
  final response = await http.get(Uri.parse(
      'https://api.giphy.com/v1/gifs/random?api_key=[yourApikey]&tag=meme'));

  GifModel _gif = GifModel('', '', '');

  if (response.statusCode == 200) {
    String bodyData = utf8.decode(response.bodyBytes);
    final jsonData = jsonDecode(bodyData);

    _gif = GifModel(jsonData['data']['title'],
        jsonData['data']['images']['downsized']['url'], jsonData['data']['id']);

    return _gif;
  } else {
    throw Exception('Fail conection');
  }
}
