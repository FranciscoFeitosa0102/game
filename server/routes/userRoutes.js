
const express = require('express');
const User = require('../models/User');
const bcrypt = require('bcrypt');
const jwt = require('jsonwebtoken');
const router = express.Router();

// Rota para cadastrar usuário
router.post('/register', async (req, res) => {
  const { username, password } = req.body;
  const salt = await bcrypt.genSalt(10);
  const hashedPassword = await bcrypt.hash(password, salt);
  const newUser = new User({ username, password: hashedPassword });

  try {
    const savedUser = await newUser.save();
    res.json(savedUser);
  } catch (err) {
    res.status(500).json(err);
  }
});

// Rota para login de usuário
router.post('/login', async (req, res) => {
  const { username, password } = req.body;
  const user = await User.findOne({ username });
  if (!user) return res.status(400).json('Usuário não encontrado');

  const validPassword = await bcrypt.compare(password, user.password);
  if (!validPassword) return res.status(400).json('Senha incorreta');

  const token = jwt.sign({ id: user._id }, process.env.JWT_SECRET);
  res.json({ token });
});

module.exports = router;
    