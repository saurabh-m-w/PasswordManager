import 'package:flutter/material.dart';
import 'package:password_manager/Screens/Login/components/background.dart';
import 'package:password_manager/Screens/Signup/signup_screen.dart';
import 'package:password_manager/Screens/getmasterpass.dart';
import 'package:password_manager/Screens/homepage.dart';
import 'package:password_manager/components/already_have_an_account_acheck.dart';
import 'package:password_manager/components/rounded_button.dart';
import 'package:password_manager/components/rounded_input_field.dart';
import 'package:password_manager/components/rounded_password_field.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import '../../../apicalls.dart';
import 'package:password_manager/Userprovider.dart';

class Body extends StatefulWidget {
  const Body({
    Key key,
  }) : super(key: key);

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {

  String username;
  String password;
  String message="";

  showLoaderDialog(BuildContext context){
    AlertDialog alert=AlertDialog(
      content: new Row(
        children: [
          CircularProgressIndicator(),
          Container(margin: EdgeInsets.only(left: 7),child:Text("Loading..." )),
        ],),
    );
    showDialog(barrierDismissible: false,
      context:context,
      builder:(BuildContext context){
        return alert;
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    final userauth=Provider.of<UserProvider>(context);

    Size size = MediaQuery.of(context).size;
    return Container(
      padding: EdgeInsets.all(10),
      width: size.width>500?500:size.width,
      child: Background(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                "LOGIN",
                style: TextStyle(fontWeight: FontWeight.bold,fontSize: 25),
              ),
              SizedBox(height: size.height * 0.03),
              SvgPicture.asset(
                "assets/icons/login2.svg",
                height: size.height * 0.35,
              ),
              SizedBox(height: size.height * 0.03),
              RoundedInputField(
                hintText: "Your Email",
                onChanged: (value) {
                  setState(() {
                    username=value;
                  });
                },
              ),
              RoundedPasswordField(
                onChanged: (value) {
                  setState(() {
                    password=value;
                  });
                },
              ),
              RoundedButton(
                text: "LOGIN",
                press: () async {
                  showLoaderDialog(context);

                  List<dynamic> response =await userauth.login(username,password);
                  Navigator.pop(context);
                  if(response[0]==true)
                    {
                      print("login");
                      Navigator.pop(context);
                      //Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>home()));
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>getMasterPass()));
                    }
                  else{

                    Fluttertoast.showToast(
                        msg: response[1],
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.CENTER,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.red,
                        textColor: Colors.white,
                        fontSize: 16.0
                    );

                  }
                },
              ),
              SizedBox(height: size.height * 0.03),
              AlreadyHaveAnAccountCheck(
                press: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return SignUpScreen();
                      },
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
