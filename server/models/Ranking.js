
const mongoose = require("mongoose");

const RankingSchema = new mongoose.Schema({
  email: String,
  score: Number,
});

module.exports = mongoose.model("Ranking", RankingSchema);

    
