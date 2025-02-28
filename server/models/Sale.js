
const mongoose = require('mongoose');

const SaleSchema = new mongoose.Schema({
  userId: { type: mongoose.Schema.Types.ObjectId, ref: 'User', required: true },
  salesCount: { type: Number, required: true },
});

module.exports = mongoose.model('Sale', SaleSchema);
    