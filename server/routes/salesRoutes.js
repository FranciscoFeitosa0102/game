
const express = require('express');
const Sale = require('../models/Sale');
const router = express.Router();

// Rota para cadastrar vendas
router.post('/', async (req, res) => {
  const { userId, salesCount } = req.body;
  const newSale = new Sale({ userId, salesCount });

  try {
    const savedSale = await newSale.save();
    res.json(savedSale);
  } catch (err) {
    res.status(500).json(err);
  }
});

module.exports = router;
    