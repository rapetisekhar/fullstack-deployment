const express = require('express');
const mongoose = require('mongoose');
const cors = require('cors');
const bodyParser = require('body-parser');

const app = express();
app.use(cors());
app.use(bodyParser.json());

const mongoUri = process.env.MONGO_URI || 'mongodb://root:password@mongodb-0.mongodb.data-engine.svc.cluster.local:27017/?authSource=admin';
mongoose.connect(mongoUri, { useNewUrlParser: true, useUnifiedTopology: true })
  .then(()=> console.log('Connected to MongoDB'))
  .catch(err => console.error('Mongo connection error', err));

const productSchema = new mongoose.Schema({
  name: String,
  price: Number,
  size: String,
  color: String,
  stock: Number
}, { timestamps: true });

const Product = mongoose.model('Product', productSchema);

// Routes
app.get('/api/health', (req,res) => res.json({status: 'ok'}));
app.get('/api/products', async (req,res) => {
  const products = await Product.find().sort({createdAt:-1});
  res.json(products);
});
app.get('/api/products/:id', async (req,res) => {
  const p = await Product.findById(req.params.id);
  if(!p) return res.status(404).send('Not found');
  res.json(p);
});
app.post('/api/products', async (req,res) => {
  const p = new Product(req.body);
  await p.save();
  res.status(201).json(p);
});
app.put('/api/products/:id', async (req,res) => {
  const p = await Product.findByIdAndUpdate(req.params.id, req.body, { new: true });
  res.json(p);
});
app.delete('/api/products/:id', async (req,res) => {
  await Product.findByIdAndDelete(req.params.id);
  res.status(204).send();
});

const PORT = process.env.PORT || 4000;
app.listen(PORT, ()=> console.log(`Backend listening on ${PORT}`));

