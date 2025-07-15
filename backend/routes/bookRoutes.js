const express = require('express');
const router = express.Router();
const upload = require('../middleware/uploadMiddleware');
const bookCtrl = require('../controllers/bookController');

router.get('/', bookCtrl.getBooks);
router.get('/:id', bookCtrl.getBookById);
router.post('/', upload.single('coverImage'), bookCtrl.createBook);
router.put('/:id', bookCtrl.updateBook);
router.delete('/:id', bookCtrl.deleteBook);

module.exports = router;
