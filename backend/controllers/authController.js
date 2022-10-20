const User = require('../models/user.js')
const bcrypt = require('bcrypt')
const jwt = require('jsonwebtoken')
const Pass=require('../models/pass.js')
const Masterpass=require('../models/masterpass.js')


exports.home=(req,res)=>{
    res.json({
        message:"Server started"
    })
}

exports.register = (req,res)=>{
    console.log(req.body);
	
	
		
		User.findOne({$or:[{email:req.body.email},{phone: req.body.phone}]}).then((user)=>
			{
				if(user){
					if(user.email===req.body.email)
					{
						res.json({
						success:"false",
						message:"Email already registered"
						})
					}
					else
					{
						res.json({
						success:"false",
						message:"Phone no. already registered"
						})
					}
				}
				else{
								bcrypt.hash(req.body.password,10,function(err, hashedpass){
								if(err)
								{
									res.json({
										error:err
									})
								}

								let user = new User({
									name:req.body.name,
									email:req.body.email,
									phone:req.body.phone,
									password:hashedpass
								})
								// user.save()
								// .then(user=>{
								//     res.json({
								//         message:"User added successfully"
								//     })
								// })
								// .catch(error =>{
								//     req.json({
								//         message:"An error occured"
								//     })
								// })

								
								
								
								user.save((err,result)=>{
									if(err)
									{
										return res.status(400).json({
											success:"false",
											error:err
										});
									}
									res.status(200).json({
										success:"true",
										message:"User added successfully",
										user:result
									})
								})
							})
					
				}
			}
			 
		);
	
    
    
}

exports.login = (req,res,next)=>{
    var username=req.body.username
    var password=req.body.password

    User.findOne({$or:[{email:username},{phone: username}]})
    .then(user=>{
        if(user)
        {
            bcrypt.compare(password,user.password,function(err,result){
                if(err)
                {
                    res.json({
                        error:err
                    })
                }
                if(result)
                {
                    let token = jwt.sign({name:user.name},'secretValue',{})
                    res.json({
                        message:'Login successfully',
                        token:token,
                        _id:user['_id']
                    })
                }
                else
                {
                    res.json({
                        message:"Incorrect password"
                    })
                }
            })
        }
        else
        {
            res.json({
                message:"No user found"
            })
        }
    })
}


exports.storePass=(req,res)=>{

    const pass=new Pass({
        id:req.body.id,
        username:req.body.username,
		appname:req.body.appname,
		icon:req.body.icon,
		color:req.body.color,
        encryptedpass:req.body.encryptedpass
    })
	//console.log(req.body);
	
    pass.save((err,result)=>{
        if(err)
        {
            return res.status(400).json({
				success:"false",
                error:err
            });
        }
        res.status(200).json({
			success:"true",
            message:"Password added successfully",
            user:result
        })
    })
    
}

// exports.mypass=(req,res)=>{
//     var id=req.body.id;

//     Pass.find({id:id},function(err,data) {
//         if(err)
//         {
//             res.json({
//                 error:err
//             })
//         }
//         res.json({
//             data
//         });
//     })
// }

exports.mypass=(req,res)=>{
    var id=req.params.id;
    console.log(req.params.id)
    Pass.find({id:id},function(err,data) {
        if(err)
        {
           return res.json({
                error:err
            })
        }
        return res.json({
            data
        });
    })
}

exports.masterpass=(req,res)=>{
    const masterpass=new Masterpass({
        id:req.body.id,
        hashmaster:req.body.hashmaster
    })

    masterpass.save((err,result)=>{
        if(err)
        {
            return res.status(400).json({
				success:false,
                error:err
            });
        }
        res.status(200).json({
			success:true,
            message:"Master Password set",
        })
    })

}

exports.checkmasterpass=(req,res)=>{
   
    var id=req.body.id
    Masterpass.findOne({id:id}, function(err,data){
        if(err)
        {
            res.json({
                success:false,
                message:err
            })
        }
        else
        {
            if(req.body.hashmaster===data["hashmaster"])
            {
                res.json({
                    success:true,
                    message:"Password match"
                })
            }
            else
            {
                res.json({
                    success:false,
                    message:"Password not match"
                })
            }
        }
    })
}

exports.updatemasterpass=(req,res)=>{
    console.log(req.body)
    Masterpass.findOneAndUpdate({id:req.body.id},{hashmaster:req.body.hashmaster}).then(()=>
    {
        res.json({
            success:true
        })
    })
    .catch(err=>{
        res.json({
            success:false
        })
    })
    
}

exports.deletepass=(req,res)=>{
    console.log(req.params)
    
    Pass.findByIdAndDelete(req.params.id,function(err){
        if(err)
            res.json({
                sucess:false,
                message:err
            })
        else
            res.json({
                success:true,
                message:"deleted"
            })
    })
    
}