import 'package:ex6/views/photoGrid.dart';
import 'package:flutter/material.dart';

import '../view_models/photoVieuwModel.dart';


class HomePage extends StatelessWidget {
  final PhotoViewModel _viewModel = PhotoViewModel();

  HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Galerie de photos'),
      ),
      body: PhotoGrid(viewModel: _viewModel),
    );
  }
}
