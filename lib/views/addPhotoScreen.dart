import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AddPhotoScreen extends StatefulWidget {
  const AddPhotoScreen({Key? key}) : super(key: key);

  @override
  State<AddPhotoScreen> createState() => _AddPhotoScreenState();
}

class _AddPhotoScreenState extends State<AddPhotoScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _thumbnailUrlController = TextEditingController();

  bool _isLoading = false;

  Future<void> _addPhoto() async {
    setState(() {
      _isLoading = true;
    });

    final title = _titleController.text.trim();
    final thumbnailUrl = _thumbnailUrlController.text.trim();

    final data = {'title': title, 'thumbnailUrl': thumbnailUrl};
    final jsonData = jsonEncode(data);

    final response = await http.post(
      Uri.parse('https://unreal-api.azurewebsites.net/photos'),
      headers: {'Content-Type': 'application/json'},
      body: jsonData,
    );

    if (response.statusCode == 201) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Photo added successfully')),
      );
      Navigator.pop(context, true); // Retour à la vue précédente en indiquant qu'une photo a été ajoutée
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to add photo')),
      );
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Photo'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  hintText: 'Title',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _thumbnailUrlController,
                decoration: const InputDecoration(
                  hintText: 'Thumbnail URL',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a thumbnail URL';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: _isLoading ? null : () {
                  if (_formKey.currentState!.validate()) {
                    _addPhoto();
                  }
                },
                child: _isLoading
                    ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                  ),
                )
                    : const Text('Add Photo'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
