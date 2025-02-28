
const mongoose = require('mongoose');

const RankingSchema = new mongoose.Schema({
  userId: { type: mongoose.Schema.Types.ObjectId, ref: 'User', required: true },
  score: { type: Number, required: true },
});

module.exports = mongoose.model('Ranking', RankingSchema);
    