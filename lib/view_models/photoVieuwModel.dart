import 'package:flutter/foundation.dart';

import '../models/photos.dart';

class PhotoViewModel extends ChangeNotifier {
  late Future<List<Photo>> _photosFuture;
  List<Photo> _photos = [];

  List<Photo> get photos => _photos;

  Future<void> init() async {
    _photosFuture = Photo.fetchPhotos();
    await Future.delayed(const Duration(seconds: 4));
    _photos = await _photosFuture;
    notifyListeners();
  }

  Future<void> addPhoto(String title, String thumbnailUrl) async {
    final newPhoto = Photo(title: title, thumbnailUrl: thumbnailUrl);
    final response = await Photo.createPhoto(newPhoto.toJson());
    if (response.statusCode == 201) {
      final addedPhoto = Photo.fromJson(response.body as Map<String, dynamic>);
      _photos.insert(0, addedPhoto);
      notifyListeners();
    } else {
      throw Exception('Failed to add photo');
    }
  }

  Future<void> reloadPhotos() async {
    _photos = await _photosFuture;
    notifyListeners();
  }
}

