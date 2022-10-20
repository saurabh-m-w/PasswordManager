const mongoose=require('mongoose');

const passwordSchema=new mongoose.Schema({
    id:{
        type:String
    },
    username:{
        type:String
    },
	appname:{
		type:String
	},
	icon:{
		type:String
	},
	color:{
		type:String
	},
    encryptedpass:{
        type:String
    }
})

module.exports = mongoose.model("Pass",passwordSchema);