const express = require('express');
const router = express.Router();
const { getGameTime } = require('../controllers/gameController');

router.post('/time', getGameTime);

module.exports = router;
