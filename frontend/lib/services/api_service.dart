import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../models/book.dart';

class ApiService {
  static const String baseUrl = 'http://localhost:5000/api/books';

  static Future<List<Book>> getBooks() async {
    try {
      final response = await http.get(Uri.parse(baseUrl));
      if (response.statusCode == 200) {
        final List jsonData = json.decode(response.body);
        return jsonData.map((e) => Book.fromJson(e)).toList();
      }
    } catch (e) {
      print('Get books error: $e');
    }
    return [];
  }

  static Future<Book?> getBookById(String id) async {
    try {
      final res = await http.get(Uri.parse('$baseUrl/$id'));
      if (res.statusCode == 200) {
        return Book.fromJson(json.decode(res.body));
      }
    } catch (e) {
      print('Get book error: $e');
    }
    return null;
  }

  static Future<bool> addBookWithImage(
    Book book,
    File? file,
    Uint8List? bytes,
  ) async {
    try {
      final request = http.MultipartRequest('POST', Uri.parse(baseUrl));
      request.fields.addAll(book.toJson().map((k, v) => MapEntry(k, v ?? '')));
      if (!kIsWeb && file != null) {
        request.files.add(
          await http.MultipartFile.fromPath('coverImage', file.path),
        );
      }
      if (kIsWeb && bytes != null) {
        request.files.add(
          http.MultipartFile.fromBytes(
            'coverImage',
            bytes,
            filename: 'upload.jpg',
          ),
        );
      }
      final response = await request.send();
      return response.statusCode == 201;
    } catch (e) {
      print('Add book error: $e');
      return false;
    }
  }

  static Future<bool> updateBookWithImage(
    Book book,
    File? file,
    Uint8List? bytes,
  ) async {
    try {
      final request = http.MultipartRequest(
        'PUT',
        Uri.parse('$baseUrl/${book.id}'),
      );
      request.fields.addAll(book.toJson().map((k, v) => MapEntry(k, v ?? '')));
      if (!kIsWeb && file != null) {
        request.files.add(
          await http.MultipartFile.fromPath('coverImage', file.path),
        );
      }
      if (kIsWeb && bytes != null) {
        request.files.add(
          http.MultipartFile.fromBytes(
            'coverImage',
            bytes,
            filename: 'upload.jpg',
          ),
        );
      }
      final response = await request.send();
      return response.statusCode == 200;
    } catch (e) {
      print('Update book error: $e');
      return false;
    }
  }

  static Future<bool> deleteBook(String id) async {
    try {
      final res = await http.delete(Uri.parse('$baseUrl/$id'));
      return res.statusCode == 200;
    } catch (e) {
      print('Delete book error: $e');
      return false;
    }
  }
}
