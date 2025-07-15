const express = require('express');
const cors = require('cors');
const dotenv = require('dotenv');
const bodyParser = require('body-parser');
const connectDB = require('./config/db');
const bookRoutes = require('./routes/bookRoutes');

dotenv.config();
connectDB();

const app = express();
app.use(cors());
app.use(bodyParser.json());

// ✅ Serve uploaded images
app.use('/uploads', express.static('uploads'));

// ✅ Routes
app.use('/api/books', bookRoutes);

const PORT = process.env.PORT || 5000;
app.listen(PORT, () => console.log(`Server running on port ${PORT}`));
