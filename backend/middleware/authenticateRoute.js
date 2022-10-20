const jwt = require('jsonwebtoken')

module.exports.authenticate = (req,res,next)=>{
    try{
        const token = req.headers["x-access-token"]

        if (!token) {
            return res.status(403).send("A token is required for authentication");
          }

        //console.log(token)
        const decode=jwt.verify(token,'secretValue')
        
        //req.user=decode
        next()
    }
    catch(error){
        res.json({
            message:"Authentication failed"
        })
    }
}