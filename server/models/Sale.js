const mongoose = require("mongoose");

const SaleSchema = new mongoose.Schema({
  userId: mongoose.Schema.Types.ObjectId,
  amount: Number,
});

module.exports = mongoose.model("Sale", SaleSchema);
