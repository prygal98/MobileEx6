import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../view_models/photoVieuwModel.dart';
import 'addPhotoForm.dart';

class PhotoGrid extends StatelessWidget {
  final PhotoViewModel viewModel;

  const PhotoGrid({Key? key, required this.viewModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: viewModel.init(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: _buildLoadingIndicator(),
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Text('Error: ${snapshot.error}'),
          );
        } else {
          viewModel.photos.sort((a, b) => b.id.compareTo(a.id)); // Tri par ordre décroissant des id
          return Scaffold(
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AddPhotoForm()),
                ).then((value) {
                  // Recharger la galerie après l'ajout d'une photo
                  viewModel.reloadPhotos();
                });
              },
              child: Icon(Icons.add),
            ),
            body: ListView.builder(
              itemCount: viewModel.photos.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: Image.network(viewModel.photos[index].thumbnailUrl),
                  title: Text(viewModel.photos[index].title),
                  subtitle: Text('ID: ${viewModel.photos[index].id}'),
                );
              },
            ),
          );
        }
      },
    );
  }

  Widget _buildLoadingIndicator() {
    return const SpinKitFadingCircle(
      color: Colors.red,
      size: 50.0,
    );
  }
}
