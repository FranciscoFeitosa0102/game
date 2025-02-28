
const express = require('express');
const router = express.Router();

// Rota para acessar o jogo
router.get('/', (req, res) => {
  res.json({ message: 'Jogo liberado!' });
});

module.exports = router;
    