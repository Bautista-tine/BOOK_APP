import 'dart:io';
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../models/book.dart';
import '../services/api_service.dart';

class EditBookPage extends StatefulWidget {
  final Book book;
  const EditBookPage({super.key, required this.book});

  @override
  State<EditBookPage> createState() => _EditBookPageState();
}

class _EditBookPageState extends State<EditBookPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController title;
  late TextEditingController author;
  late TextEditingController genre;
  late TextEditingController description;
  late TextEditingController publishedDate;

  File? file;
  Uint8List? bytes;

  @override
  void initState() {
    super.initState();
    title = TextEditingController(text: widget.book.title);
    author = TextEditingController(text: widget.book.author);
    genre = TextEditingController(text: widget.book.genre);
    description = TextEditingController(text: widget.book.description);
    publishedDate = TextEditingController(
      text: widget.book.publishedDate?.toIso8601String().split('T').first ?? '',
    );
  }

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

    final updatedBook = Book(
      id: widget.book.id,
      title: title.text,
      author: author.text,
      genre: genre.text,
      description: description.text,
      publishedDate: DateTime.tryParse(publishedDate.text),
      coverImage: widget.book.coverImage, // existing image stays if not changed
    );

    final success = await ApiService.updateBookWithImage(
      updatedBook,
      file,
      bytes,
    );
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
      appBar: AppBar(title: const Text('Edit Book')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              ElevatedButton.icon(
                onPressed: _pickImage,
                icon: const Icon(Icons.image),
                label: const Text('Change Cover Image'),
              ),
              const SizedBox(height: 10),
              if (bytes != null)
                Image.memory(bytes!, height: 150)
              else if (file != null)
                Image.file(file!, height: 150)
              else if (widget.book.coverImage != null)
                Image.network(widget.book.coverImage!, height: 150),
              _field(title, 'Title'),
              _field(author, 'Author'),
              _field(genre, 'Genre'),
              _field(description, 'Description'),
              _field(publishedDate, 'Published Date (YYYY-MM-DD)'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _submit,
                child: const Text('Update Book'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
