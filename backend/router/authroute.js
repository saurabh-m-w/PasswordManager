const express = require('express')
const router = express.Router()

const authController = require('../controllers/authController.js')
const authen = require('../middleware/authenticateRoute.js')


router.get('/',authController.home)
router.post('/register',authController.register)
router.post('/login',authController.login)
router.post('/storePass',authController.storePass)
//router.post('/mypass',authController.mypass);
router.get('/mypass/:id/',authController.mypass);
router.delete('/deletepass/:id/',authController.deletepass)
router.post('/setmasterpass',authController.masterpass)
router.post('/checkmasterpass',authController.checkmasterpass)
router.post('/updatemasterpass',authController.updatemasterpass)

module.exports=router