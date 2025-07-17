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

  Widget _field(TextEditingController c, String label, IconData icon, {int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: TextFormField(
        controller: c,
        maxLines: maxLines,
        style: const TextStyle(color: Colors.black),
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: Colors.white,
          labelStyle: const TextStyle(color: Colors.brown),
          prefixIcon: Icon(icon, color: Colors.brown),  // Add icon inside TextFormField
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        validator: (v) => v == null || v.isEmpty ? 'Required' : null,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5EFE6), // Library beige
      appBar: AppBar(
        backgroundColor: const Color(0xFF8B6A4F), // Wood tone
        title: const Text('Add Book'),
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF8B6A4F),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: _pickImage,
                icon: const Icon(Icons.image),
                label: const Text('Pick Cover Image'),
              ),
              const SizedBox(height: 10),
              if (bytes != null)
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.memory(bytes!, height: 150, fit: BoxFit.cover),
                )
              else if (file != null)
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.file(file!, height: 150, fit: BoxFit.cover),
                ),
              const SizedBox(height: 10),
              _field(title, 'Title', Icons.title),
              _field(author, 'Author', Icons.person),
              _field(genre, 'Genre', Icons.category),
              _field(description, 'Description', Icons.description, maxLines: 3),
              _field(publishedDate, 'Published Date (YYYY-MM-DD)', Icons.date_range),
              const SizedBox(height: 16),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF8B6A4F),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: _submit,
                child: const Text('Add Book', style: TextStyle(fontSize: 16)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
