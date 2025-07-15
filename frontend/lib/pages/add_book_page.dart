import 'dart:io';
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../models/book.dart';
import '../services/api_service.dart';

class AddBookPage extends StatefulWidget {
  const AddBookPage({super.key});

  @override
  State<AddBookPage> createState() => _AddBookPageState();
}

class _AddBookPageState extends State<AddBookPage> {
  final _formKey = GlobalKey<FormState>();
  final title = TextEditingController();
  final author = TextEditingController();
  final genre = TextEditingController();
  final description = TextEditingController();
  final publishedDate = TextEditingController();

  File? file;
  Uint8List? bytes;

  Future<void> _pickImage() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.image);
    if (result != null) {
      if (kIsWeb) {
        bytes = result.files.first.bytes;
      } else {
        file = File(result.files.first.path!);
      }
      setState(() {});
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final book = Book(
      id: '',
      title: title.text,
      author: author.text,
      genre: genre.text,
      description: description.text,
      publishedDate: DateTime.tryParse(publishedDate.text),
      coverImage: null,
    );

    final success = await ApiService.addBookWithImage(book, file, bytes);
    if (success && context.mounted) Navigator.pop(context);
  }

  Widget _field(TextEditingController c, String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: TextFormField(
        controller: c,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
        ),
        validator: (v) => v == null || v.isEmpty ? 'Required' : null,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Book')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              ElevatedButton.icon(
                onPressed: _pickImage,
                icon: const Icon(Icons.image),
                label: const Text('Pick Cover Image'),
              ),
              if (bytes != null)
                Image.memory(bytes!, height: 150)
              else if (file != null)
                Image.file(file!, height: 150),
              _field(title, 'Title'),
              _field(author, 'Author'),
              _field(genre, 'Genre'),
              _field(description, 'Description'),
              _field(publishedDate, 'Published Date (YYYY-MM-DD)'),
              const SizedBox(height: 16),
              ElevatedButton(onPressed: _submit, child: const Text('Add Book')),
            ],
          ),
        ),
      ),
    );
  }
}
