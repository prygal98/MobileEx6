import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AddPhotoForm extends StatefulWidget {
  const AddPhotoForm({Key? key}) : super(key: key);

  @override
  _AddPhotoFormState createState() => _AddPhotoFormState();
}

class _AddPhotoFormState extends State<AddPhotoForm> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _thumbnailUrlController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add a new photo'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _titleController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
                decoration: const InputDecoration(
                  hintText: 'Enter a title',
                ),
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _thumbnailUrlController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a thumbnail URL';
                  }
                  return null;
                },
                decoration: const InputDecoration(
                  hintText: 'Enter a thumbnail URL',
                ),
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    final photo = {
                      'title': _titleController.text,
                      'thumbnailUrl': _thumbnailUrlController.text,
                    };

                    final response = await http.post(
                      Uri.parse('https://unreal-api.azurewebsites.net/photos'),
                      headers: <String, String>{
                        'Content-Type': 'application/json; charset=UTF-8',
                      },
                      body: jsonEncode(photo),
                    );

                    if (response.statusCode == 201) {
                      Navigator.pop(context);
                    } else {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text('Error'),
                            content: Text('Failed to add photo: ${response.statusCode} - ${response.reasonPhrase}'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text('OK'),
                              )
                            ],
                          );
                        },
                      );
                    }
                  }
                },
                child: const Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
