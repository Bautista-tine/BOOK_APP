import 'package:flutter/material.dart';
import '../models/book.dart';
import '../services/api_service.dart';
import 'edit_book_page.dart';

class BookDetailPage extends StatelessWidget {
  final Book book;
  const BookDetailPage({super.key, required this.book});

  void _delete(BuildContext context) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Delete Book'),
        content: const Text('Are you sure you want to delete this book?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await ApiService.deleteBook(book.id);
      if (context.mounted) Navigator.pop(context);
    }
  }

  void _edit(BuildContext context) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => EditBookPage(book: book)),
    );
    if (context.mounted) Navigator.pop(context); // Reload home after edit
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(book.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => _edit(context),
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () => _delete(context),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            if (book.coverImage != null)
              Image.network(book.coverImage!, height: 200),
            const SizedBox(height: 12),
            Text(
              book.title,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text('Author: ${book.author}'),
            const SizedBox(height: 4),
            Text('Genre: ${book.genre}'),
            const SizedBox(height: 4),
            if (book.publishedDate != null)
              Text(
                'Published: ${book.publishedDate!.toIso8601String().split('T').first}',
              ),
            const SizedBox(height: 8),
            Text(book.description),
          ],
        ),
      ),
    );
  }
}
