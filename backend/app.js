const express=require('express');
const morgan=require("morgan");
const bodyParser=require('body-parser')
const mongoose=require('mongoose');
const authRoute=require('./router/authroute.js')

var uri = "mongodb+srv://admin:<password>@cluster0.xqrxg.mongodb.net/?retryWrites=true&w=majority"
mongoose.connect(uri)
.then(()=>console.log("DB connected"));
//"mongodb+srv://admin:saurabh123@cluster0.xqrxg.mongodb.net/myFirstDatabase?retryWrites=true&w=majority"

mongoose.connection.on('error',err=>{
    console.log('DB connection error: '+err.message);
})

const app = express()

app.use(morgan("dev"));
app.use(bodyParser.json());
app.use('/',authRoute)

const port=process.env.PORT || 8000;
app.listen(port,()=> {console.log('Api started at \n'+'http://localhost:'+port+'/')});