import 'package:flutter/material.dart';
import '../models/book.dart';
import '../services/api_service.dart';
import 'add_book_page.dart';
import 'book_detail_page.dart';

class HomePage extends StatefulWidget {
  final VoidCallback toggleTheme;
  final bool isDark;

  const HomePage({super.key, required this.toggleTheme, required this.isDark});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Book> books = [];
  List<Book> filtered = [];
  final TextEditingController searchCtrl = TextEditingController();
  String? selectedGenre;

  @override
  void initState() {
    super.initState();
    loadBooks();
  }

  Future<void> loadBooks() async {
    books = await ApiService.getBooks();
    filtered = books;
    setState(() {});
  }

  void _search(String query) {
    setState(() {
      filtered = books.where((b) {
        final matchQuery = b.title.toLowerCase().contains(query.toLowerCase()) ||
            b.author.toLowerCase().contains(query.toLowerCase());
        final matchGenre = selectedGenre == null || selectedGenre == 'All'
            ? true
            : b.genre.toLowerCase() == selectedGenre!.toLowerCase();
        return matchQuery && matchGenre;
      }).toList();
    });
  }

  List<String> getGenres() {
    return [
      'All',
      'Fiction',
      'Non-fiction',
      'Mystery',
      'Fantasy',
      'Science Fiction',
      'Romance',
      'Horror',
      'Biography',
      'Historical',
      'Adventure',
      'Thriller',
      'Self-Help',
      'Poetry',
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5EFE6),
      appBar: AppBar(
        backgroundColor: const Color(0xFF8B6A4F),
        title: const Text('📚 Book Shelf Library'),
        titleTextStyle: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                  flex: 3,
                  child: TextField(
                    controller: searchCtrl,
                    onChanged: _search,
                    style: const TextStyle(color: Colors.black),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      hintText: 'Search books...',
                      hintStyle: const TextStyle(color: Colors.grey),
                      prefixIcon: const Icon(Icons.search, color: Colors.grey),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  flex: 2,
                  child: DropdownButtonFormField<String>(
                    isExpanded: true,
                    value: selectedGenre ?? 'All',
                    items: getGenres()
                        .map((genre) => DropdownMenuItem(
                              value: genre,
                              child: Text(
                                genre,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedGenre = value;
                        _search(searchCtrl.text);
                      });
                    },
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: filtered.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.65,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemBuilder: (_, i) {
                final book = filtered[i];
                return GestureDetector(
                  onTap: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => BookDetailPage(book: book),
                      ),
                    );
                    loadBooks();
                  },
                  child: Card(
                    color: const Color(0xFFEEE3D0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    elevation: 6,
                    shadowColor: Colors.brown.withOpacity(0.3),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        if (book.coverImage != null)
                          ClipRRect(
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(14),
                            ),
                            child: Image.network(
                              book.coverImage!,
                              height: 150,
                              fit: BoxFit.cover,
                            ),
                          ),
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                book.title,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15,
                                  color: Color(0xFF3E2C1C),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                book.author,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: Colors.brown,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF8B6A4F),
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddBookPage()),
          );
          loadBooks();
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
