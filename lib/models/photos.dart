import 'dart:convert';

import 'package:http/http.dart' as http;

class Photo {
  final int id;
  final String title;
  final String thumbnailUrl;

  Photo({
    this.id = 0,
    required this.title,
    required this.thumbnailUrl,
  });

  factory Photo.fromJson(Map<String, dynamic> json) {
    return Photo(
      id: json['id'],
      title: json['title'],
      thumbnailUrl: json['thumbnailUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'thumbnailUrl': thumbnailUrl,
    };
  }

  static Future<List<Photo>> fetchPhotos() async {
    final response = await http.get(Uri.parse('https://unreal-api.azurewebsites.net/photos'));
    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body);
      return jsonList.map((json) => Photo.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load photos');
    }
  }

  static Future<http.Response> createPhoto(Map<String, dynamic> photo) async {
    final response = await http.post(
      Uri.parse('https://unreal-api.azurewebsites.net/photos'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(photo),
    );
    return response;
  }
}
