const Book = require('../models/Book');

exports.createBook = async (req, res) => {
  try {
    const { title, author, genre, description, publishedDate } = req.body;
    const coverImage = req.file ? `uploads/${req.file.filename}` : null;

    const book = await Book.create({
      title,
      author,
      genre,
      description,
      publishedDate,
      coverImage,
    });

    res.status(201).json(book);
  } catch (error) {
    res.status(400).json({ error: error.message });
  }
};

exports.getBooks = async (req, res) => {
  try {
    const books = await Book.find().sort({ createdAt: -1 });

    const booksWithImageUrls = books.map((book) => ({
      ...book.toObject(),
      coverImage: book.coverImage
        ? `${req.protocol}://${req.get('host')}/${book.coverImage}`
        : null,
    }));

    res.json(booksWithImageUrls);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

exports.getBookById = async (req, res) => {
  const book = await Book.findById(req.params.id);
  res.json(book);
};

exports.updateBook = async (req, res) => {
  const book = await Book.findByIdAndUpdate(req.params.id, req.body, {
    new: true,
  });
  res.json(book);
};

exports.deleteBook = async (req, res) => {
  await Book.findByIdAndDelete(req.params.id);
  res.json({ message: 'Book deleted' });
};
