const mongoose = require('mongoose');

const masterpass = new mongoose.Schema({
    id:{
        type:String
    },
    hashmaster:{
        type:String
    },
});

module.exports = mongoose.model("masterpass",masterpass);